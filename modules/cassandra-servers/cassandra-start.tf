data "template_file" "cassandra_yaml_seeds" {

  count = "${var.seed_count}"

  template = "${file("${path.module}/templates/cassandra.yaml.tpl")}"
  vars {
    cluster_name    = "${var.cluster_name}"
    num_tokens      = "${var.num_tokens}"
    seed_provider   = "${var.seed_provider}"
    seeds           = "${join(",", openstack_compute_instance_v2.cassandra-seeds.*.network.0.floating_ip)}" #workaround github issue 7430
    listen_address  = "${element(openstack_compute_instance_v2.cassandra-seeds.*.network.0.fixed_ip_v4, count.index)}"
    rpc_address     = "0.0.0.0"
    endpoint_snitch = "${var.endpoint_snitch}"
    start_rpc       = "${var.start_rpc}"
    broadcast_address = "${element(openstack_compute_instance_v2.cassandra-seeds.*.network.0.floating_ip, count.index)}"
    broadcast_rpc_address = "${element(openstack_compute_instance_v2.cassandra-seeds.*.network.0.floating_ip, count.index)}"
  }
}

data "template_file" "cassandra_yaml_servers" {

  count = "${var.count - var.seed_count}"

  template = "${file("${path.module}/templates/cassandra.yaml.tpl")}"
  vars {
    cluster_name    = "${var.cluster_name}"
    num_tokens      = "${var.num_tokens}"
    seed_provider   = "${var.seed_provider}"
    seeds           = "${join(",", openstack_compute_instance_v2.cassandra-seeds.*.network.0.floating_ip)}" #workaround github issue 7430
    listen_address  = "${element(openstack_compute_instance_v2.cassandra-servers.*.network.0.fixed_ip_v4, count.index)}"
    rpc_address     = "0.0.0.0"
    endpoint_snitch = "${var.endpoint_snitch}"
    start_rpc       = "${var.start_rpc}"
    broadcast_address = "${element(openstack_compute_instance_v2.cassandra-servers.*.network.0.floating_ip, count.index)}"
    broadcast_rpc_address = "${element(openstack_compute_instance_v2.cassandra-servers.*.network.0.floating_ip, count.index)}"
  }
}

data "template_file" "cassandra_env_seeds" {

  count = "${var.seed_count}"

  template = "${file("${path.module}/templates/cassandra-env.sh.tpl")}"
  vars {
    public_host  = "${element(openstack_compute_instance_v2.cassandra-seeds.*.network.0.floating_ip, count.index)}"
  }
}

data "template_file" "cassandra_env_servers" {

  count = "${var.count - var.seed_count}"

  template = "${file("${path.module}/templates/cassandra-env.sh.tpl")}"
  vars {
    public_host  = "${element(openstack_compute_instance_v2.cassandra-servers.*.network.0.floating_ip, count.index)}"
  }
}

resource "null_resource" "cassandra_install_seeds" {

  depends_on = ["null_resource.diamond_start_seeds"]

  count = "${var.seed_count}"

  connection {
    type = "ssh"
    user = "${var.default_user}"
    host = "${element(openstack_compute_instance_v2.cassandra-seeds.*.access_ip_v4, count.index)}"
    port = "22"
    agent = "true"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/mount.sh"
    destination = "/tmp/mount.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sh /tmp/mount.sh"
    ]
  }

  provisioner "file" {
    content     = "${element(data.template_file.cassandra_yaml_seeds.*.rendered, count.index)}"
    destination = "/tmp/cassandra.yaml"
  }

  provisioner "file" {
    content     = "${element(data.template_file.cassandra_env_seeds.*.rendered, count.index)}"
    destination = "/tmp/cassandra-env.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep ${count.index * 120}",
      "sudo cp /tmp/cassandra.yaml /etc/cassandra/cassandra.yaml",
      "sudo cp /tmp/cassandra-env.sh /etc/cassandra/cassandra-env.sh",
      "sudo service cassandra start"
    ]
  }

}

resource "null_resource" "cassandra_install_servers" {

  count = "${var.count - var.seed_count}"

  depends_on = ["null_resource.cassandra_install_seeds","null_resource.diamond_start_servers"]

  connection {
    type = "ssh"
    user = "${var.default_user}"
    host = "${element(openstack_compute_instance_v2.cassandra-servers.*.access_ip_v4, count.index)}"
    port = "22"
    agent = "true"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/mount.sh"
    destination = "/tmp/mount.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sh /tmp/mount.sh"
    ]
  }

  provisioner "file" {
    content     = "${element(data.template_file.cassandra_yaml_servers.*.rendered, count.index)}"
    destination = "/tmp/cassandra.yaml"
  }

  provisioner "file" {
    content     = "${element(data.template_file.cassandra_env_servers.*.rendered, count.index)}"
    destination = "/tmp/cassandra-env.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep ${count.index * 120}",
      "sudo cp /tmp/cassandra.yaml /etc/cassandra/cassandra.yaml",
      "sudo cp /tmp/cassandra-env.sh /etc/cassandra/cassandra-env.sh",
      "sudo service cassandra start"
    ]
  }

}

