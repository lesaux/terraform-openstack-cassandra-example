output "network_id" {
  value = "${openstack_networking_network_v2.network.id}"
}

output "subnet_id" {
  value = "${openstack_networking_subnet_v2.subnet.id}"
}

output "router_id" {
  value = "${openstack_networking_router_v2.router.id}"
}
