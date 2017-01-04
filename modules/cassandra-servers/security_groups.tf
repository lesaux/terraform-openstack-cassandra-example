resource "openstack_networking_secgroup_v2" "cassandra_internal_secgroup" {
  name = "cassandra_internal_secgroup"
  description = "internal network security group"
}

resource "openstack_networking_secgroup_rule_v2" "cassandra_internal_secgroup_rule_1" {
  direction = "egress"
  ethertype = "IPv4"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.cassandra_internal_secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "cassandra_internal_secgroup_rule_2" {
  direction = "ingress"
  ethertype = "IPv4"
  remote_group_id = "${openstack_networking_secgroup_v2.cassandra_internal_secgroup.id}"
  security_group_id = "${openstack_networking_secgroup_v2.cassandra_internal_secgroup.id}"
}

resource "openstack_networking_secgroup_v2" "cassandra_external_secgroup" {
  name = "cassandra_external_secgroup"
  description = "external network security group"
}

resource "openstack_networking_secgroup_rule_v2" "cassandra_external_secgroup_rule_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = "22"
  port_range_max = "65535"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.cassandra_external_secgroup.id}"
}
