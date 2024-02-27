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
  depends_on = [ aws_vpc.own_vpc ]
  vpc_id = aws_vpc.own_vpc.id

  tags = {
    Name = join(" ", [var.vpc_name, " internet gateway"])
  }
}
# Create public subnets
resource "aws_subnet" "public-subnets" {
  depends_on = [ aws_vpc.own_vpc ]

  count = length(var.public_subnets)
  vpc_id = aws_vpc.own_vpc.id
  map_public_ip_on_launch = var.map_public_ip
  availability_zone = var.azs[count.index]
  cidr_block = var.public_subnets[count.index]

  tags = {
    Name = join(" ", [var.vpc_name, " public subnet ", count.index])
    filter_id = "Public_Subnet"
  }
}
# Create private subnets
resource "aws_subnet" "private-subnets" {
  depends_on = [ aws_vpc.own_vpc ]
  count = length(var.private_subnets)
  vpc_id = aws_vpc.own_vpc.id
  availability_zone = var.azs[count.index]
  cidr_block = var.private_subnets[count.index]

  tags = {
    Name = join(" ", [var.vpc_name, " private subnet ", count.index])
    filter_id = "Private_Subnet"
  }
}
# Create route table
resource "aws_route_table" "own_route_table" {
  depends_on = [ aws_vpc.own_vpc ]
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
  depends_on = [ aws_subnet.public-subnets, aws_subnet.private-subnets ]
  count = length(aws_subnet.public-subnets)
  route_table_id = aws_route_table.own_route_table.id
  subnet_id = aws_subnet.public-subnets[count.index].id
}
# Create private subnets group for db
resource "aws_db_subnet_group" "db_subnet_group" {
  depends_on = [ aws_subnet.private-subnets, data.aws_subnets.private_subnets ]
  name = "db_subnet_group"
  subnet_ids = [ for item in data.aws_subnets.private_subnets.ids : item ]
#  subnet_ids = [ aws_subnet.private-subnets[0].id, aws_subnet.private-subnets[1].id ]
}
data "aws_subnets" "public_subnets" {
  depends_on = [ aws_subnet.public-subnets, aws_subnet.private-subnets, aws_vpc.own_vpc ]
  filter {
    name = "vpc-id"
    values = [ aws_vpc.own_vpc.id ]
  }
  tags = {
    filter_id = "Public_Subnet"
  }
}
data "aws_subnets" "private_subnets" {
  depends_on = [ aws_subnet.public-subnets, aws_subnet.private-subnets, aws_vpc.own_vpc ]
  filter {
    name = "vpc-id"
    values = [ aws_vpc.own_vpc.id ]
  }
  tags = {
    filter_id = "Private_Subnet"
  }
}