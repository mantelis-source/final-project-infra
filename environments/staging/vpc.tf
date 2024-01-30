module "staging_vpc" {
  source = "../../modules/my_vpc"

  vpc_cidr_range = var.vpc_cidr_range
  vpc_name = "Staging environment"
  azs = ["eu-central-1a", "eu-central-1b"]
  public_subnets = ["15.85.1.0/24"]
  private_subnets = ["15.85.10.0/24", "15.85.11.0/24"]
  
  dns_hostnames = true
  map_public_ip = true
}
  output "vpc_id_from" {
    value = module.staging_vpc.vpc_idx
  }
    output "subnetgroup" {
    value = module.staging_vpc.db_subnet_name
  }