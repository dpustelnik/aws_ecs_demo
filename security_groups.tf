# SG for the ALB: allow inbound HTTPS (443) only from 75.2.60.0/24
resource "aws_security_group" "alb_sg" {
  name        = "demo-alb-sg"
  description = "Allow inbound HTTPS from 75.2.60.0/24"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS inbound from 75.2.60.0/24"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["75.2.60.0/24"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-alb-sg"
  }
}

# SG for ECS: allow inbound port 8080 only from the ALB
resource "aws_security_group" "ecs_sg" {
  name        = "demo-ecs-sg"
  description = "Allow inbound from ALB on 8080"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "Allow inbound from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-ecs-sg"
  }
}

# SG for RDS: allow inbound port 5432 only from ECS
resource "aws_security_group" "rds_sg" {
  name        = "demo-rds-sg"
  description = "Allow inbound from ECS tasks on port 5432"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "Allow PostgreSQL inbound from ECS tasks"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-rds-sg"
  }
}
