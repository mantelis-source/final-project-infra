module "staging_vpc" {
  source = "../../modules/my_vpc"

  vpc_cidr_range = var.vpc_cidr_range
  vpc_name = var.vpc_name
  azs = ["eu-central-1a", "eu-central-1b"]
  public_subnets = ["15.85.1.0/24", "15.85.2.0/24"]
  private_subnets = ["15.85.10.0/24", "15.85.11.0/24"]
  
  dns_hostnames = true
  map_public_ip = true
}