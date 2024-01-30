# Create VPC resource
resource "aws_vpc" "own_vpc" {

  cidr_block = var.vpc_cidr_range
  enable_dns_hostnames = var.dns_hostnames
  tags = {
    Name = join(" ", [var.vpc_name, " VPC"])
  }
}
# Create gateway resource
resource "aws_internet_gateway" "own-gw" {
  vpc_id = aws_vpc.own_vpc.id

  tags = {
    Name = join(" ", [var.vpc_name, " internet gateway"])
  }
}
# Create public subnets
resource "aws_subnet" "public-subnets" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.own_vpc.id
  map_public_ip_on_launch = var.map_public_ip
  cidr_block = var.public_subnets[count.index]

  tags = {
    Name = join(" ", [var.vpc_name, " public subnet ", count.index])
  }
}
# Create private subnets
resource "aws_subnet" "private-subnets" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.own_vpc.id
  availability_zone = var.azs[count.index]
  cidr_block = var.private_subnets[count.index]

  tags = {
    Name = join(" ", [var.vpc_name, " private subnet ", count.index])
  }
}
# Create route table
resource "aws_route_table" "own_route_table" {
  vpc_id = aws_vpc.own_vpc.id

  route {
    gateway_id = aws_internet_gateway.own-gw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = join(" ", [var.vpc_name, " route table "])
  }
}
# Create route table association
resource "aws_route_table_association" "own_route_table_association" {
  count = length(aws_subnet.public-subnets)
  route_table_id = aws_route_table.own_route_table.id
  subnet_id = aws_subnet.public-subnets[count.index].id
}
# Create private subnets group for
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet_group"
  subnet_ids = [aws_subnet.private-subnets[0].id, aws_subnet.private-subnets[1].id]
}