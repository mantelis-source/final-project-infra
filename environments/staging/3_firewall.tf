resource "aws_security_group" "staging-sq" {
  depends_on = [ module.staging_vpc ]
  vpc_id = local.vpc_id
  
  # Inbound rules
  ingress {
    description = "open 80 to 80 port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = join(" ", [var.vpc_name, "security group"])
  }
}