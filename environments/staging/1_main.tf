provider "aws" {
#  shared_config_files      = ["/home/mantas/.aws/config"]
#  shared_credentials_files = ["/home/mantas/.aws/credentials"]
#  profile                  = "default"
  region     = "eu-central-1"
}
module "vpc_subnets" {
  source             = "./network"
  environment_name   = var.environment_name
  vpc_cidr_range     = var.vpc_cidr_range
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.azs
}
module "security_groups" {
  source = "./security_groups"

  vpc_id           = local.vpc_id
  environment_name = var.environment_name
}
module "logs" {
  source         = "./logs"
  log_group_name = local.log_group_name
}
module "instances" {
  source               = "./instances"
  vpc_id               = local.vpc_id
  environment_name     = var.environment_name
  lb_security_groups   = [local.alb_sg_id]
  ecs_security_groups  = [local.ecs_sg_id]
  lb_subnets           = [for subnet in local.public_subnets_ids : subnet]
  db_subnet_group_name = local.db_subnet_group_name
  db_security_groups   = [local.db_sq_id]
  region               = "eu-central-1"
  log_group_name       = local.log_group_name
}

module "iam_roles_policies" {
  source             = "./iam"
  secrets_read_roles = ["RoleToReadSecrets", "ecsTaskExecutionRole"]
}