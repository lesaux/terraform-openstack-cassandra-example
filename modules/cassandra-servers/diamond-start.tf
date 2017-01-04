resource "null_resource" "diamond_start_seeds" {

  depends_on = ["null_resource.hostname_seeds"]

  count = "${var.seed_count}"

  connection {
    type = "ssh"
    user = "${var.default_user}"
    host = "${element(openstack_compute_instance_v2.cassandra-seeds.*.access_ip_v4, count.index)}"
    port = "22"
    agent = "true"
  }

  provisioner "file" {
    source      = "${path.module}/files/diamond.conf"
    destination = "/tmp/diamond.conf"
  }

  provisioner "file" {
    source      = "${path.module}/files/telegraf.conf"
    destination = "/tmp/telegraf.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/diamond.conf /etc/diamond/diamond.conf",
      "sudo cp /tmp/telegraf.conf /etc/telegraf/telegraf.conf",
      "sudo service diamond stop",
      "sudo service telegraf restart",
    ]
  }

}

resource "null_resource" "diamond_start_servers" {

  depends_on = ["null_resource.hostname_servers"]

  count = "${var.count - var.seed_count}"

  connection {
    type = "ssh"
    user = "${var.default_user}"
    host = "${element(openstack_compute_instance_v2.cassandra-servers.*.access_ip_v4, count.index)}"
    port = "22"
    agent = "true"
  }

  provisioner "file" {
    source      = "${path.module}/files/diamond.conf"
    destination = "/tmp/diamond.conf"
  }

  provisioner "file" {
    source      = "${path.module}/files/telegraf.conf"
    destination = "/tmp/telegraf.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/diamond.conf /etc/diamond/diamond.conf",
      "sudo cp /tmp/telegraf.conf /etc/telegraf/telegraf.conf",
      "sudo service diamond stop",
      "sudo service telegraf restart",
    ]
  }

}
