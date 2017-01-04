resource "openstack_compute_servergroup_v2" "servergroup" {
  name = "servergroup"
  policies = ["anti-affinity"]
}

resource "openstack_compute_floatingip_v2" "cassandra-servers" {
  count = "${var.count - var.seed_count}"
  pool = "${var.public_pool}"
}

resource "openstack_compute_floatingip_v2" "cassandra-seeds" {
  count = "${var.seed_count}"
  pool = "${var.public_pool}"
}

resource "openstack_compute_instance_v2" "cassandra-seeds" {
  name = "${var.server_name}-seed-${count.index}"
  image_id = "${var.image_id}"
  flavor_id = "${var.flavor_id}"
  count = "${var.seed_count}"
  key_pair = "${var.keypair_name}"
  security_groups = ["cassandra_internal_secgroup","cassandra_external_secgroup"]
  
  config_drive = false
  #user_data = "${element(data.template_file.user_data.*.rendered, count.index)}"

  #scheduler_hints {
  #  group = "${openstack_compute_servergroup_v2.servergroup.id}"
  #  #target_cell = "zone1"
  #}

  block_device {
    boot_index = 0
    delete_on_termination = true
    destination_type = "local"
    source_type = "image"
    uuid = "${var.image_id}"
    volume_size = 20
  }

  metadata {
    this = "that"
  }

  network {
    access_network = "true"
    uuid = "${var.network_id}"
    floating_ip = "${element(openstack_compute_floatingip_v2.cassandra-seeds.*.address, count.index)}"
  }

}

resource "openstack_compute_instance_v2" "cassandra-servers" {

  depends_on = ["openstack_compute_instance_v2.cassandra-seeds"]

  name = "${var.server_name}-${count.index}"
  image_id = "${var.image_id}"
  flavor_id = "${var.flavor_id}"
  count = "${var.count - var.seed_count}"
  key_pair = "${var.keypair_name}"
  security_groups = ["cassandra_internal_secgroup","cassandra_external_secgroup"]
  
  config_drive = true
  #user_data = "${element(data.template_file.user_data.*.rendered, count.index)}"

  #scheduler_hints {
  #  group = "${openstack_compute_servergroup_v2.servergroup.id}"
  #  #target_cell = "zone2"
  #}

  block_device {
    boot_index = 0
    delete_on_termination = true
    destination_type = "local"
    source_type = "image"
    uuid = "${var.image_id}"
    volume_size = 20
  }

  metadata {
    this = "that"
  }

  network {
    access_network = "true"
    uuid = "${var.network_id}"
    floating_ip = "${element(openstack_compute_floatingip_v2.cassandra-servers.*.address, count.index)}"
  }

}
