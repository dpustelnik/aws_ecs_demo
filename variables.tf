variable "region" {
  type = string
  default = "eu-west-1"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate ARN used by ALB for HTTPS"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the main VPC"
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "CIDR blocks for the public subnets"
}

variable "db_username" {
  type        = string
  default     = "postgres_admin"
  description = "Username for the PostgreSQL database"
}

variable "db_password" {
  type        = string
  default     = "YourSuperSecretPassword123"
  description = "Password for the PostgreSQL database"
}

###################################
# Container vars
###################################

variable "container_port" {
  default = 8080
  description = "What port number the application inside the docker container is binding to"
}

variable "container_image" {
  type = string
  default = "nginx:latest"
  description = "Docker image used by the ECS container" 
}

variable "container_cpu" {
  description = "How much CPU to give the container. 1024 is 1 CPU"
  default     = 256
}
variable "container_memory" {
  description = "How much memory in megabytes to give the container"
  default     = 512
}

# variable "container_environment" {
#   type        = map(string)
#   default     = {
#     EXAMPLE_VAR = "default_value"
#     FOO         = "bar"
#   }
#   description = "Key-value pairs of environment variables for the container"
# }