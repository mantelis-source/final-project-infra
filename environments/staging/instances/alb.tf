resource "aws_lb" "app_alb" {
  load_balancer_type = local.load_balancer_type
  security_groups    = var.lb_security_groups
  subnets            = var.lb_subnets

  tags = {
    Name = join(" ", [var.environment_name, " application load balancer"])
  }
}
resource "aws_lb_target_group" "app_lb_target_group" {
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "alb_listener" {
  depends_on = [
    aws_lb.app_alb,
    aws_lb_target_group.app_lb_target_group
  ]

  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.app_alb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }
}