variable "vpc_name" {
  type = string
  default = "vpc-from-module"
}
variable "vpc_cidr_range" {
  type = string
  default = "15.85.0.0/16"
}