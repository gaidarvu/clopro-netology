output "vm_details" {
  value = [
    for instance in yandex_compute_instance.my_network_instances : {
      name        = instance.name,
      ext_ip_address  = instance.network_interface[0].nat_ip_address
      int_ip_address  = instance.network_interface[0].ip_address
    }
  ]
}