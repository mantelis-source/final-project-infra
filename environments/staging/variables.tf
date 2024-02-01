variable "environment_name" {
  type = string
  default = "Staging environment"
}
variable "vpc_cidr_range" {
  type = string
  default = "15.85.0.0/16"
}
variable "public_subnets" {
  type = list(string)
  default = ["15.85.1.0/24", "15.85.2.0/24"]
}
variable "private_subnets" {
  type = list(string)
  default = ["15.85.10.0/24", "15.85.11.0/24"]
}
variable "azs" {
  type = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}
# Local variables
locals {
  vpc_id = module.vpc_subnets.vpc_id
  public_subnets_ids = module.vpc_subnets.public_subnet_ids
  private_subnets_ids = module.vpc_subnets.private_subnet_ids
  alb_sg_id = module.security_groups.alb_sg_id
  ecs_sg_id = module.security_groups.ecs_sg_id
}
output "public_ids" {
  value = local.public_subnets_ids
}
output "private_ids" {
  value = local.private_subnets_ids
}