parameter_group_name = "beauty-bench-db"
parameter_group_family = "postgres14"
aws_region = "your region"
db_username = "your user"
db_password = "your passwd"
db_port = 5432
vpc_cider_block = "10.0.0.0/16"
public_subnets_cider_blocks= ["10.0.1.0/24", "10.0.2.0/24"]

allocated_storage     = 100
max_allocated_storage = 500
storage_type          = "io1"

instance_class= "db.t3.medium"

skip_final_snapshot = false

multi_az = false
enabled_cloudwatch_logs_exports= true
param_log_statement= "none"