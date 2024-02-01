resource "aws_lb" "load_labancer_ecs" {
  load_balancer_type = "application"
  security_groups = [ aws_security_group.staging-sq.id ]
  subnets = [ for item in local.public_subnet_ids : item ]
}
resource "aws_lb_target_group" "ecs_publi_subnets" {
  port = 80
  protocol = "HTTP"
  vpc_id = local.vpc_id
  target_type = "instance"
}
resource "aws_lb_listener" "ecs_lb_listener" {
  depends_on = [ 
    aws_lb.load_labancer_ecs, 
    aws_lb_target_group.ecs_publi_subnets 
  ]

  port = 80
  protocol = "HTTP"
  load_balancer_arn = aws_lb.load_labancer_ecs.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ecs_publi_subnets.arn
  }
}