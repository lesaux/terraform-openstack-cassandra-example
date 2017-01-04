resource "openstack_networking_network_v2" "network" {
  name = "${var.network_name}-network"
  admin_state_up = "true"
  shared = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name = "${var.network_name}-subnet"
  network_id = "${openstack_networking_network_v2.network.id}"
  cidr = "${var.cidr}"
  dns_nameservers = "${split(",", var.dns_nameservers)}"
}

resource "openstack_networking_router_v2" "router" {
  name             = "${var.network_name}-router"
  admin_state_up   = "true"
  external_gateway = "${var.external_gateway_id}"
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet.id}"
}
