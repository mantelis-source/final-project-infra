resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"

  tags = {
    Name = join(" ", [var.environment_name, "ECS cluster"])
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
        name: "final-project",
        image: "mantelis900726/final-project-image:latest",
        cpu: 256,
        memory: 1024,
        essential: true,
        portMappings: [
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
  name = "final-project-service"
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"

  load_balancer {
    container_name = "final-project"
    container_port = 80
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }
  network_configuration {
    assign_public_ip = true
    security_groups = var.ecs_security_groups
    subnets = var.lb_subnets
  }
}