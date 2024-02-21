variable "environment_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "lb_security_groups" {
  type = set(string)
}
variable "ecs_security_groups" {
  type = set(string)
}
variable "db_security_groups" {
  type = set(string)
}
variable "lb_subnets" {
  type = set(string)
}
variable "db_subnet_group_name" {
  type = string
}

locals {
  load_balancer_type = "application"
}