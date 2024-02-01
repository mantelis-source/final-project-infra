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
  vpc_id = module.staging_vpc.vpc_id
  db_subnets_group = module.staging_vpc.db_subnet_name
  public_subnet_ids = module.staging_vpc.public_subnet_ids
}
output "public_ids" {
  value = module.staging_vpc.public_subnet_ids
}
output "private_ids" {
  value = module.staging_vpc.private_subnet_ids
}