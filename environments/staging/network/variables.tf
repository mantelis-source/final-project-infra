variable "vpc_cidr_range" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "availability_zones" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}