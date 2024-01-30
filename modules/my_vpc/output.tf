output "vpc_idx" {
  value = aws_vpc.own_vpc.id
}
output "db_subnet_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}