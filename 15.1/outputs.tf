# output "vm_details" {
#   value = [
#     for instance in yandex_compute_instance.kuber : {
#       name        = instance.name,
#       ip_address  = instance.network_interface[0].nat_ip_address
#     }
#   ]
# }