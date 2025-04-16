variable "metadata" {
  type        = map(string)
  default = {}
}
variable "token" {
  type        = string
}
variable "cloud_id" {
  type        = string
}
variable "folder_id" {
  type        = string
}
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}
variable "vpc_name" {
  type        = string
  default     = "public"
  description = "VPC name"
}
variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
}
variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
}
variable "public_cidr_name" {
  type        = string
  default     = "public"
  description = "subnet name"
}
variable "private_cidr_name" {
  type        = string
  default     = "private"
  description = "subnet name"
}
variable "vms_ssh_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}
variable "each_vm" {
  type = map(object({
    platform_id=string
    vm_name=string
    cpu=number
    ram=number
    core_fraction=number
    type=string
    disk_volume=number
    network_interface=bool
    scheduling_policy=bool
    os_family=string
    subnet_name=string
    }))
  default = {
    "vm1" = {
      platform_id="standard-v3"
      vm_name="public-instance"
      cpu=2
      ram=1
      core_fraction=20
      type="network-hdd"
      disk_volume=10
      network_interface=true
      scheduling_policy=true
      os_family="fd8jnll1ou4fv2gil3rv"
      subnet_name="public"
    }
    "vm2" = {
      platform_id="standard-v3"
      vm_name="private-instance"
      cpu=2
      ram=1
      core_fraction=20
      type="network-hdd"
      disk_volume=10
      network_interface=false
      scheduling_policy=true
      os_family="fd8jnll1ou4fv2gil3rv"
      subnet_name="private"
    }
  }
}

variable "nat_vm" {
  description = "Configuration for NAT instance"
  type = object({
    platform_id       = string
    vm_name           = string
    cpu               = number
    ram               = number
    core_fraction     = number
    type              = string
    disk_volume       = number
    scheduling_policy = bool
    os_family         = string
    ip_address        = string
  })

  default = {
    platform_id       = "standard-v3"
    vm_name           = "nat-instance"
    cpu               = 2
    ram               = 1
    core_fraction     = 20
    type              = "network-hdd"
    disk_volume       = 10
    scheduling_policy = true
    os_family         = "fd80mrhj8fl2oe87o4e1"
    ip_address        = "192.168.10.254"
  }
}
