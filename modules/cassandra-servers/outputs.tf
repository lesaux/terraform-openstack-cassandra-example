output "seed_address" {
  value = "${openstack_compute_instance_v2.cassandra-seeds.0.network.0.floating_ip}"
}
