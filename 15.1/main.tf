resource "yandex_vpc_network" "my_network" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_cidr_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my_network.id
  v4_cidr_blocks = var.public_cidr
}
resource "yandex_vpc_subnet" "private" {
  name           = var.private_cidr_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my_network.id
  v4_cidr_blocks = var.private_cidr
}

locals {
  subnet_map = {
    public  = yandex_vpc_subnet.public.id
    private = yandex_vpc_subnet.private.id
  }
}

data "template_file" "cloudinit" {
  for_each = local.cloud_init_configs

  template = each.value

  vars = {
    vms_ssh_root_key = var.vms_ssh_root_key
  }
}
data "template_file" "nat_cloudinit" {
  template = file("${path.module}/cloud-init/nat.yaml")

  vars = {
    vms_ssh_root_key = var.vms_ssh_root_key
  }
}

resource "yandex_compute_instance" "nat-instance" {
  name              = var.nat_vm.vm_name
  hostname          = var.nat_vm.vm_name
  platform_id       = var.nat_vm.platform_id
  zone              = var.default_zone
  resources {
    cores           = var.nat_vm.cpu
    memory          = var.nat_vm.ram
    core_fraction   = var.nat_vm.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id      = var.nat_vm.os_family
      type          = var.nat_vm.type
      size          = var.nat_vm.disk_volume
    }
  }
  scheduling_policy {
    preemptible     = var.nat_vm.scheduling_policy
  }
  network_interface {
    subnet_id       = yandex_vpc_subnet.public.id
    ip_address      = var.nat_vm.ip_address
  }

  metadata = merge(
    var.metadata,
    {
      user-data          = data.template_file.nat_cloudinit.rendered
      serial-port-enable = 1
    }
  )
}

resource "yandex_compute_instance" "public-instance" {
  for_each = var.each_vm
  name              = each.value.vm_name
  hostname          = each.value.vm_name
  platform_id       = each.value.platform_id
  zone              = var.default_zone
  resources {
    cores           = each.value.cpu
    memory          = each.value.ram
    core_fraction   = each.value.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id      = each.value.os_family
      type          = each.value.type
      size          = each.value.disk_volume
    }
  }
  scheduling_policy {
    preemptible     = each.value.scheduling_policy
  }
  network_interface {
    subnet_id = local.subnet_map[each.value.subnet_name]
    nat             = each.value.network_interface
  }

  metadata = merge(
    {
      for k, v in var.metadata : k => v
    },
    {
    user-data = data.template_file.cloudinit[each.key].rendered
    serial-port-enable = 1
    }
  )
}