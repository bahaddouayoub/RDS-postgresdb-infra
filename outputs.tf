output "rds_postgres_pg_id" {
  value       = aws_db_parameter_group.beauty-bench-db.id
  description = "ID of the RDS postgres parameter group"
}

output "rds_postgres_id" {
  value       = aws_db_instance.beauty-bench-db.id
  description = "ID of the of the RDS instance"
}


output "rds_hostname" {
  value = aws_db_instance.beauty-bench-db.address
}

output "rds_db_port" {
  value = aws_db_instance.beauty-bench-db.port
}

output "rds_username" {
  value = aws_db_instance.beauty-bench-db.username
}

output "rds_dbname" {
  value = aws_db_instance.beauty-bench-db.name
}

output "cloudwatch_logs_path" {
  value = (
    var.enabled_cloudwatch_logs_exports ?
    format("/aws/rds/instance/%s/postgresql", aws_db_instance.beauty-bench-db.id)
    : ""
  )
}