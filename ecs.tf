# Create an ECS cluster
resource "aws_ecs_cluster" "this" {
  name = "demo-ecs-cluster"
}

# IAM policy document for ECS task execution
data "aws_iam_policy_document" "ecs_task_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# IAM Role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "demo-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_trust.json
}

# Attach the AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Define ECS Task Definition
resource "aws_ecs_task_definition" "this" {
  family                   = "demo-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name       = "demo-app-container"
      image      = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory
      essential  = true
      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
    #   # Convert the map of environment variables into the ECS env array
    #   environment = [
    #     for k, v in var.container_environment : {
    #       name  = k
    #       value = v
    #     }
    #   ]
    }
  ])
}

# Create ECS Service using Fargate and the ALB
resource "aws_ecs_service" "this" {
  name            = "demo-ecs-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [for subnet in aws_subnet.public : subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "demo-app-container"
    container_port   = 8080
  }

  depends_on = [
    aws_lb_listener.https
  ]
}