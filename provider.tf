provider "openstack" {
    user_name   = "${var.openstack["user_name"]}"
    tenant_name = "${var.openstack["tenant_name"]}"
    password    = "${var.openstack["password"]}"
    auth_url    = "${var.openstack["auth_url"]}"
    insecure    = "${var.openstack["insecure"]}"
}
