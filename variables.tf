variable "openstack" {
  type = "map"
  default = {
    auth_url    = "http://192.168.0.101:5000/v2.0"
    user_name   = "admin"
    tenant_name = "admin"
    password    = "admin"
    insecure    = true
  }
}

variable "network" {
  type = "map"
  default = {
    network_name        = "cassandra-network"
    domain_name         = "localdomain"
    dns_nameservers     = "192.168.0.1,8.8.8.8"  #this can't be a list. maps need to have momogeneous types
    cidr                = "192.168.14.0/24"
    public_pool         = "public"
    external_gateway_id = "024f01e5-9844-4d20-a397-ab5b4e7b1cea"
  }
}

variable "bastion-host" {
  type = "map"
  default = {
    image_id     = "eee3fb0c-7ad9-4880-81b7-b69ff507e325"  #ubuntu xenial
    flavor_id    = "cdd31d9a-aa8c-46fd-8b9e-68fcc9a3a836" #m1.small
    server_name  = "bastion-graphite"
    default_user = "ubuntu"
    keypair_name = "adminkeypair"
  }
}

variable "cassandra-servers" {
  type = "map"
  default = {
    image_id     = "44640914-29a0-406c-9b1c-d9613351c750"  #cassandra image
    #flavor_id    = "078c783c-c88e-44f7-9a14-1894657b2c90" #m1.large-ephemeral
    flavor_id    = "5e841740-dabc-4ce5-bca2-f09079cfede2" #m1.large
    server_name  = "cassandra-server"
    default_user = "ubuntu"
    keypair_name = "adminkeypair"
    count        = "3"
  }
}

variable "cassandra-config" {
  type = "map"
  default = {
    cluster_name    = "MyCassandraCluster"
    num_tokens      = "256"
    seed_provider   = "org.apache.cassandra.locator.SimpleSeedProvider"
    endpoint_snitch = "GossipingPropertyFileSnitch"
    seed_count      = "1"
    start_rpc       = "true"
  }
}
