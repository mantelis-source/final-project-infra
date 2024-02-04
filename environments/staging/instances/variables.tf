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
variable "lb_subnets" {
  type = set(string)
}

locals {
  load_balancer_type = "application"
}