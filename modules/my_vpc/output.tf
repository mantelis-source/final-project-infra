output "vpc_id" {
  value = aws_vpc.own_vpc.id
}
output "db_subnet_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}
output "public_subnet_ids" {
  value = [ for item in data.aws_subnets.public_subnets.ids : item ]
}
output "private_subnet_ids" {
  value = [ for item in  data.aws_subnets.private_subnets.ids : item ]
}