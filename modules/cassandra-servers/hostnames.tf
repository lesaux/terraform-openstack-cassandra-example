resource "null_resource" "hostname_seeds" {

  count = "${var.seed_count}"

  connection {
    type = "ssh"
    user = "${var.default_user}"
    host = "${element(openstack_compute_instance_v2.cassandra-seeds.*.access_ip_v4, count.index)}"
    port = "22"
    agent = "true"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${element(openstack_compute_instance_v2.cassandra-seeds.*.access_ip_v4, count.index)} ${var.server_name}-seed-${count.index} |sudo tee -a /etc/hosts"
    ]
  }

}

resource "null_resource" "hostname_servers" {

  count = "${var.count - var.seed_count}"

  connection {
    type = "ssh"
    user = "${var.default_user}"
    host = "${element(openstack_compute_instance_v2.cassandra-servers.*.access_ip_v4, count.index)}"
    port = "22"
    agent = "true"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${element(openstack_compute_instance_v2.cassandra-servers.*.access_ip_v4, count.index)} ${var.server_name}-${count.index} |sudo tee -a /etc/hosts"
    ]
  }

}
