resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"

  tags = {
    Name = join(" ", [var.vpc_name, "ECS cluster"])
  }
}
resource "aws_ecs_task_definition" "ecs_task_def" {
  depends_on = [ aws_ecs_cluster.ecs_cluster ]
  family = "staging_ecs"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = 512
  memory = 2048
 
  container_definitions = jsonencode([
    {
        name: "nginx-container",
        image: "nginx:1.23.1",
        cpu: 256,
        memory: 1024,
        essential: true,
        portMapping: [
            {
                containerPort: 80,
                hostPort: 80,
                protocol: "tcp"
            }
       ],
    },
  ])
}
resource "aws_ecs_service" "ecs_service" {
  depends_on = [ aws_ecs_task_definition.ecs_task_def ]
  name = "my-nginx-service"
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  desired_count = 2
  launch_type = "FARGATE"
  platform_version = "1.4.0"

  load_balancer {
    container_name = "nginx-container"
    container_port = 80
    target_group_arn = aws_lb_target_group.ecs_publi_subnets.arn
  }
  network_configuration {
    assign_public_ip = true
    security_groups = [ aws_security_group.staging-sq.id ]
    subnets = [ for item in local.public_subnet_ids : item ]
  }

 #lifecycle {
 #   ignore_changes = [ task_definition ]
 # }
}