module "staging_vpc" {
  source = "../../../modules/my_vpc"

  vpc_cidr_range = var.vpc_cidr_range
  vpc_name = var.environment_name
  azs = var.availability_zones
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  
  dns_hostnames = true
  map_public_ip = true
}