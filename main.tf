module "network" {
  source                    = "./modules/network"
  network_name              = "${var.network["network_name"]}"
  domain_name               = "${var.network["domain_name"]}"
  dns_nameservers           = "${var.network["dns_nameservers"]}"
  cidr                      = "${var.network["cidr"]}"
  public_pool               = "${var.network["public_pool"]}"
  external_gateway_id       = "${var.network["external_gateway_id"]}"
}
module "cassandra-server" {
  source                    = "./modules/cassandra-servers"
  image_id                  = "${var.cassandra-servers["image_id"]}"
  flavor_id                 = "${var.cassandra-servers["flavor_id"]}"
  server_name               = "${var.cassandra-servers["server_name"]}"
  default_user              = "${var.cassandra-servers["default_user"]}"
  keypair_name              = "${var.cassandra-servers["keypair_name"]}"
  count                     = "${var.cassandra-servers["count"]}"
  network_id                = "${module.network.network_id}"
  #bastion_address           = "${module.bastion-host.public_ip}"
  #bastion_user              = "${var.bastion-host["default_user"]}"
  subnet_id                 = "${module.network.subnet_id}"
  public_pool               = "${var.network["public_pool"]}"

  cluster_name              = "${var.cassandra-config["cluster_name"]}"
  num_tokens                = "${var.cassandra-config["num_tokens"]}"
  seed_provider             = "${var.cassandra-config["seed_provider"]}"
  endpoint_snitch           = "${var.cassandra-config["endpoint_snitch"]}"
  seed_count                = "${var.cassandra-config["seed_count"]}"
  start_rpc                 = "${var.cassandra-config["start_rpc"]}"

}
