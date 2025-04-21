variable "metadata" {
  type                = map(string)
  default             = {}
}
variable "default_account_id" {
  type                = string
}
variable "token" {
  type                = string
}
variable "iam_token" {
  type                = string
}
variable "cloud_id" {
  type                = string
}
variable "folder_id" {
  type                = string
}
variable "default_zone" {
  type                = string
  default             = "ru-central1-a"
}
variable "default_region" {
  type                = string
  default             = "ru-central1"
}
variable "vpc_name" {
  type                = string
  default             = "my_vpc"
  description         = "VPC name"
}
variable "public_cidr" {
  type                = list(string)
  default             = ["192.168.10.0/24"]
}
variable "public_cidr_name" {
  type                = string
  default             = "public"
  description         = "subnet name"
}
variable "vms_ssh_root_key" {
  type                = string
  description         = "ssh-keygen -t ed25519"
}

variable "group_instance_config" {
  type = object({
    platform_id       = string
    group_name        = string
    cpu               = number
    ram               = number
    core_fraction     = number
    disk_type         = string
    disk_size         = number
    os_image_id       = string
    preemptible       = bool
    nat               = bool
    scale_policy      = number
    max_unavailable   = number
    max_creating      = number
    max_expansion     = number
    max_deleting      = number
  })
  default = {
    platform_id       = "standard-v3"
    group_name        = "group"
    cpu               = 2
    ram               = 1
    core_fraction     = 20
    disk_type         = "network-hdd"
    disk_size         = 10
    os_image_id       = "fd827b91d99psvq5fjit"
    preemptible       = true
    nat               = true
    scale_policy      = 3
    max_unavailable   = 1
    max_creating      = 3
    max_expansion     = 1
    max_deleting      = 2
  }
}

variable "bucket_config" {
  description           = "bucket variables"
  type = object({
    name                = string
    access_level        = string
    storage_class       = string
    max_bucket_size     = number
    link_access         = bool
    bucket_access       = bool
    uploaded_name       = string
    image_path          = string
  })
  default = {
    name                = "gaidar-vu-student-1986-02-25"
    access_level        = "public-read"
    storage_class       = "COLD"
    max_bucket_size     = 104857600
    link_access         = true
    bucket_access       = false
    uploaded_name       = "uploaded_image.jpg"
    image_path          = "pics/image.jpg"
  }
}

variable "load_balancer_config" {
  description           = "load-balancer variables"
  type = object({
    name                = string
    target_group_name   = string
    listener_name       = string
    listener_port       = number
    target_port         = number
    protocol            = string
    ip_version          = string
    healthcheck_name    = string
  })
  default = {
    name                = "web-balance"
    target_group_name   = "my-target-group"
    listener_name       = "http-listener"
    listener_port       = 80
    target_port         = 80
    protocol            = "tcp"
    ip_version          = "ipv4"
    healthcheck_name    = "http-healthcheck"
  }
}

variable "target_group_name" {
  default               = "target-group"
  description           = "target-group name"
  }
