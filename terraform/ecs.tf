# ECS (FARGATE)
# ============================================================

resource "aws_ecs_cluster" "strapi" {
  name = "strapi-cluster-aditya"
  setting {
    name  = "containerInsights" # metrics about your containers
    value = "enabled"
  }

  tags = {
    Name = "strapi-cluster-aditya"
  }
}

resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task-aditya"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "strapi-aditya"
      image     = var.image_uri
      essential = true

      portMappings = [{
        containerPort = 1337
        protocol      = "tcp"
      }]

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:1337/_health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.strapi.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" },
        { name = "DATABASE_CLIENT", value = "postgres" },
        { name = "DATABASE_HOST", value = aws_db_instance.strapi_rds.address },
        { name = "DATABASE_PORT", value = "5432" },
        { name = "DATABASE_NAME", value = var.db_name },
        { name = "DATABASE_USERNAME", value = var.db_username },
        { name = "DATABASE_PASSWORD", value = var.db_password },
        { name = "DATABASE_SSL", value = "true" },
        { name = "DATABASE_SSL__REJECT_UNAUTHORIZED", value = "false" },
        { name = "APP_KEYS", value = var.app_keys },
        { name = "API_TOKEN_SALT", value = var.api_token_salt },
        { name = "ADMIN_JWT_SECRET", value = var.admin_jwt_secret },
        { name = "TRANSFER_TOKEN_SALT", value = var.transfer_token_salt },
        { name = "JWT_SECRET", value = var.jwt_secret }
      ]
    }
  ])
}

resource "aws_ecs_service" "strapi" {
  name            = "strapi-service-aditya"
  cluster         = aws_ecs_cluster.strapi.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = data.aws_subnets.default_subnets.ids
    security_groups  = [aws_security_group.strapi_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg.arn
    container_name   = "strapi-aditya"
    container_port   = 1337
  }

  depends_on = [
    aws_db_instance.strapi_rds,
    aws_lb_listener.strapi_listener
  ]
}
