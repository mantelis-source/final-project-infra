resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"

  tags = {
    Name = join(" ", [var.environment_name, "ECS cluster"])
  }
}
resource "aws_ecs_task_definition" "ecs_task_def" {
  depends_on               = [aws_ecs_cluster.ecs_cluster]
  family                   = "staging_ecs"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048
  execution_role_arn       = "arn:aws:iam::744445457753:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name : "final-project-container",
      image : "mantelis900726/final-project-image:latest",
      repositoryCredentials : {
        "credentialsParameter" : "arn:aws:secretsmanager:eu-central-1:744445457753:secret:github_creds-2GliDQ"
      }
      cpu : 256,
      memory : 1024,
      essential : true,
      portMappings : [
        {
          containerPort : 80,
          hostPort : 80,
          protocol : "tcp"
        }
      ],
      secrets : [
        {
          valueFrom : "arn:aws:secretsmanager:eu-central-1:744445457753:secret:db_creds-5aPXeO:db_username::"
          name : "db_username"
        },
        {
          valueFrom : "arn:aws:secretsmanager:eu-central-1:744445457753:secret:db_creds-5aPXeO:db_password::"
          name : "db_password"
        },
        {
          valueFrom : "arn:aws:secretsmanager:eu-central-1:744445457753:secret:db_creds-5aPXeO:db_host::"
          name : "db_host"
        },
        {
          valueFrom : "arn:aws:secretsmanager:eu-central-1:744445457753:secret:db_creds-5aPXeO:db_name::"
          name : "db_name"
        },
        {
          valueFrom : "arn:aws:secretsmanager:eu-central-1:744445457753:secret:db_creds-5aPXeO:flask_secret_key::"
          name : "flask_secret_key"
        }
      ],
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          //awslogs-create-group: "true",
          awslogs-group : var.log_group_name,
          awslogs-region : var.region,
          awslogs-stream-prefix : var.environment_name
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  depends_on = [aws_ecs_task_definition.ecs_task_def,
  aws_lb_target_group.app_lb_target_group]
  name             = "final-project-service"
  cluster          = aws_ecs_cluster.ecs_cluster.id
  task_definition  = aws_ecs_task_definition.ecs_task_def.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  load_balancer {
    container_name   = "final-project-container"
    container_port   = 80
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }
  network_configuration {
    assign_public_ip = true
    security_groups  = var.ecs_security_groups
    subnets          = var.lb_subnets
  }
}