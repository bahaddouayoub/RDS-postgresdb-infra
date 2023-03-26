provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "beauty-bench-db-vpc"
  cidr                 = var.vpc_cider_block
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = var.public_subnets_cider_blocks
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "beauty-bench-db" {
  name       = "beauty-bench-db"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "beauty-bench-db"
  }
}

resource "aws_security_group" "rds" {
  name   = "beauty-bench-db_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "beauty-bench-db_rds"
  }
}

resource "aws_db_parameter_group" "beauty-bench-db" {
  name        = var.parameter_group_name
  family      = var.parameter_group_family

  parameter {
    name  = "log_statement"
    value = var.param_log_statement
  }
}

resource "aws_db_instance" "beauty-bench-db" {
  identifier             = "beauty-bench-db"

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = true
  iops = 3000

  instance_class         = var.instance_class
  engine                 = "postgres"
  engine_version         = "14.1"
  publicly_accessible    = true

  username               = var.db_username
  password               = var.db_password
  port                   = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.beauty-bench-db.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.beauty-bench-db.name
  multi_az               = var.multi_az

  skip_final_snapshot    = var.skip_final_snapshot
  backup_retention_period= var.backup_retention_period 

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports ? ["postgresql", "upgrade"] : []

}
