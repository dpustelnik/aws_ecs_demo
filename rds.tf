resource "aws_db_subnet_group" "this" {
  name       = "demo-rds-subnet-group"
  subnet_ids = [for subnet in aws_subnet.public : subnet.id]
  # In production, you would typically use private subnets for the database

  tags = {
    Name = "demo-rds-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "demo-rds-postgres"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  db_name                = "demo_db"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
}