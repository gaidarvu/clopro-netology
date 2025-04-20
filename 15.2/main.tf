resource "yandex_vpc_network" "my_network" {
  name                    = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name                    = var.public_cidr_name
  zone                    = var.default_zone
  network_id              = yandex_vpc_network.my_network.id
  v4_cidr_blocks          = var.public_cidr
}

data "template_file" "cloudinit" {
  template                = file("${path.module}/cloud-init/cloud-init.yaml")
  vars = {
    vms_ssh_root_key      = var.vms_ssh_root_key
  }
}

resource "yandex_compute_instance_group" "my_group_instances" {  
  name                    = var.group_instance_config.group_name
  service_account_id      = var.default_account_id
  folder_id               = var.folder_id
  instance_template {
    platform_id           = var.group_instance_config.platform_id
    resources {
      cores               = var.group_instance_config.cpu
      memory              = var.group_instance_config.ram
      core_fraction       = var.group_instance_config.core_fraction
    }

    boot_disk {
      initialize_params {
        image_id          = var.group_instance_config.os_image_id
        type              = var.group_instance_config.disk_type
        size              = var.group_instance_config.disk_size
      }
    }

    network_interface {
      subnet_ids          = [yandex_vpc_subnet.public.id]
      nat                 = var.group_instance_config.nat
    }

    scheduling_policy {
      preemptible         = var.group_instance_config.preemptible
    }

    metadata = {
      user-data           = data.template_file.cloudinit.rendered
      serial-port-enable  = 1
    }
  }

  scale_policy {
    fixed_scale {
      size = var.group_instance_config.scale_policy
    }
  }
  deploy_policy {
    max_unavailable       = 1
    max_creating          = 2
    max_expansion         = 1
    max_deleting          = 1
  }
  allocation_policy {
    zones                 = [var.default_zone]
  }
}

resource "yandex_storage_bucket" "image_bucket" {
  bucket                  = var.bucket_config.name
  acl                     = var.bucket_config.access_level

  default_storage_class   = var.bucket_config.storage_class
  max_size                = var.bucket_config.max_bucket_size

  anonymous_access_flags {
    read                  = var.bucket_config.link_access
    list                  = var.bucket_config.bucket_access
  }
}

resource "yandex_storage_object" "image_object" {
  bucket                  = yandex_storage_bucket.image_bucket.bucket
  key                     = var.bucket_config.uploaded_name
  source                  = var.bucket_config.image_path
  acl                     = var.bucket_config.access_level
}

resource "yandex_lb_network_load_balancer" "web_lb" {
  name                    = var.load_balancer_config.name
  region_id               = var.default_region

  listener {
    name                  = var.load_balancer_config.listener_name
    port                  = var.load_balancer_config.listener_port
    target_port           = var.load_balancer_config.target_port
    protocol              = var.load_balancer_config.protocol
    external_address_spec {
      ip_version          = var.load_balancer_config.ip_version
    }
  }

  attached_target_group {
    target_group_id       = yandex_lb_target_group.my_target_group.id

    healthcheck {
      name                = var.load_balancer_config.healthcheck_name
      tcp_options {
        port              = var.load_balancer_config.target_port
      }
    }
  }
}

locals {
  lb_targets = [
    for instance in yandex_compute_instance_group.my_group_instances.instances :
    {
      subnet_id           = yandex_vpc_subnet.public.id
      address             = instance.network_interface[0].ip_address
    }
  ]
}

resource "yandex_lb_target_group" "my_target_group" {
  name                    = var.target_group_name
  region_id               = var.default_region

  dynamic "target" {
    for_each              = local.lb_targets
    content {
      subnet_id           = target.value.subnet_id
      address             = target.value.address
    }
  }
}
