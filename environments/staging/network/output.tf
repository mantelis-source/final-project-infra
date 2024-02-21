output "vpc_id" {
  value = module.staging_vpc.vpc_id
}
output "public_subnet_ids" {
  value = module.staging_vpc.public_subnet_ids
}
output "private_subnet_ids" {
  value = module.staging_vpc.private_subnet_ids
}
output "db_subnets_group_name" {
  value = module.staging_vpc.db_subnet_name
}