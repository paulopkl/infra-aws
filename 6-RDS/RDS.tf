resource "aws_db_instance" "postgresql" {
  identifier        = "example-db-instance" # Replace with your desired identifier for the DB instance
  allocated_storage = 10                    # Storage allocated for the DB instance (in gigabytes)
  engine            = "postgres"            # Specify PostgreSQL as the database engine
  engine_version    = "13.4"                # Specify the PostgreSQL version

  instance_class = "db.t2.micro" # Specify the instance type

  # Database settings
  db_name  = var.db_name     # Name of the database to create
  username = var.db_username # Master username for the DB instance
  password = var.db_password # Master password for the DB instance (replace with your own secure password)

  parameter_group_name = ""
  skip_final_snapshot  = true
  # availability_zone = "us-east-1b"
  multi_az = var.db_multi_az_deployment

  # vpc_security_group_ids = [aws_security_group.database_security_group.id]

  tags = var.aws_tags
}
