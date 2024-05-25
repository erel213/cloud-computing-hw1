resource "aws_ecs_cluster" "parking_lot_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecr_repository" "parking_lot_app" {
  name = "parking_lot_app"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}

resource "aws_security_group" "ecs_security_group" {
  name        = "ecs_security_group"
  description = "Allow inbound traffic to ECS instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    security_groups          = [var.alb_security_group_Id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_security_group"
  }
}


resource "aws_ecs_task_definition" "app" {
  family                   = var.task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
  container_definitions    = jsonencode([
    {
      name      = var.container_name
      image     = "${aws_ecr_repository.parking_lot_app.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      environment = [
        {
          name  = "ENV_VAR"
          value = "production"
        },
        {
          name =  "AWS_CONTAINER_CREDENTIALS_RELATIVE_URI"
          value =  "/aws/credentials/"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.cloudwatch_log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
    }
  }
  ])
}

resource "aws_ecs_service" "app" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.parking_lot_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_task_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.ecs_security_group.id]
  }
  

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = 8080
  }
}