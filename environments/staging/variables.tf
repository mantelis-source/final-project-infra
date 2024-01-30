variable "vpc_name" {
  type = string
  default = "Staging environment"
}
variable "vpc_cidr_range" {
  type = string
  default = "15.85.0.0/16"
}
# Local variables
locals {
  vpc_id = module.staging_vpc.vpc_idx
  db_subnets_group = module.staging_vpc.db_subnet_name
}