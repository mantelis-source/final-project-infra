provider "aws" {
  shared_config_files      = ["/home/mantas/.aws/config"]
  shared_credentials_files = ["/home/mantas/.aws/credentials"]
  profile                  = "default"
  region                   = "eu-central-1"
}
module "vpc_subnets" {
  source = "./network"
  environment_name = var.environment_name
  vpc_cidr_range = var.vpc_cidr_range
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  availability_zones = var.azs
}
module "security_groups" {
  source = "./security_groups"

  vpc_id = local.vpc_id
  environment_name = var.environment_name  
}

module "alb" {
  source = "./instances"
  vpc_id = local.vpc_id
  environment_name = var.environment_name
  lb_security_groups = [ local.alb_sg_id ]
  lb_subnets = [ for subnet in local.public_subnets_ids : subnet ]

}