locals {
  cloud_init_configs = {
    vm1 = file("${path.module}/cloud-init/vm1.yaml")
    vm2 = file("${path.module}/cloud-init/vm2.yaml")
    vm3 = file("${path.module}/cloud-init/vm3.yaml")
    vm4 = file("${path.module}/cloud-init/vm4.yaml")
    vm5 = file("${path.module}/cloud-init/vm5.yaml")
  }
}