terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.54"
    }
  }
  required_version = ">= 1.8.5"
}

provider "aws" {
  # Specify the AWS region to deploy resources
  region  = "eu-west-1"
  profile = "${terraform.workspace}.lab"
}