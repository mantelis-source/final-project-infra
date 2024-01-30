variable "vpc_name" {
  type = string
  default = "vpc-from-module"
}
variable "vpc_cidr_range" {
  type = string
}
variable "dns_hostnames" {
  type = bool
  default = false
}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "azs" {
  type = list(string)
}
variable "map_public_ip" {
  type = bool
  default = false
}