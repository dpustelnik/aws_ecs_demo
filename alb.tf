# Application Load Balancer
resource "aws_lb" "this" {
  name               = "demo-alb"
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "demo-alb"
  }
}

# Target group for ECS on port 8080 (HTTP)
resource "aws_lb_target_group" "this" {
  name        = "demo-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "ip"

  health_check {
    path = "/"
    port = "8080"
  }
}

# HTTPS listener for the ALB
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
