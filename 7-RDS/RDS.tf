# Define a parameter group for the RDS instance
resource "aws_db_parameter_group" "postgres_private" {
  name        = "postgres-parameter-group"
  family      = "postgres15"  # Specify your DB engine family
  description = "Parameter group for PostgreSQL RDS instance"

  # parameter {
  #   name = "rds.force_ssl"
  #   value = 0
  # }

  parameter {
    name = "log_connections"
    value = 1
  }

  parameter {
    name = "log_disconnections"
    value = 1
  }

  # Add other required parameters here
}

output "sadsad" {
  value = data.aws_subnets.private.ids
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name = "postgres-rds-subnet"
  description = "DB subnet group for PostgreSQL Database"

  subnet_ids = data.aws_subnets.private.ids
  # subnet_ids = [for subnet in aws_subnet.private : subnet.id data.aws_subnets.private.ids]
  # subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = {
    Name        = "PostgreSQL_Database"
    Environment = "Prod"
  }
}

resource "aws_db_instance" "postgresql" {
  depends_on = [
    aws_db_subnet_group.postgres_subnet_group,
    # data.aws_security_group.database_security_group
    aws_security_group.database_security_group
  ]

  identifier            = "example-db-instance" # Replace with your desired identifier for the DB instance
  allocated_storage     = 10                    # Storage allocated for the DB instance (in gigabytes)
  max_allocated_storage = 100                   # Storage Auto Scale to 100 Gb
  engine                = "postgres"            # Specify PostgreSQL as the database engine
  engine_version        = "15.2"                # Specify the PostgreSQL version

  instance_class = var.db_instance_type # "db.t2.micro" # Specify the instance type

  # Database settings
  db_name  = var.db_name     # Name of the database to create
  username = var.db_username # Master username for the DB instance
  password = var.db_password # Master password for the DB instance (replace with your own secure password)

  # parameter_group_name = ""
  skip_final_snapshot = true
  # availability_zone   = var.db_availability_zone   # "us-east-1c"
  multi_az            = var.db_multi_az_deployment # Multi region, doubles cost

  vpc_security_group_ids = [
    # data.aws_security_group.database_security_group.id
    aws_security_group.database_security_group.id
  ]

  # publicly_accessible = true

  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.id
  parameter_group_name   = aws_db_parameter_group.postgres_private.name  # Associate parameter group with the instance

  # Replace the following with your preferred settings
  # backup_retention_period    = 7
  # maintenance_window         = "Mon:00:00-Mon:01:00"
  # backup_window              = "03:00-04:00"

  tags = var.aws_tags
}

# resource "aws_db_instance" "example" {
#   allocated_storage           = 500
#   auto_minor_version_upgrade  = false                                  # Custom for SQL Server does not support minor version upgrades
#   custom_iam_instance_profile = "AWSRDSCustomSQLServerInstanceProfile" # Instance profile is required for Custom for SQL Server. See: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-setup-sqlserver.html#custom-setup-sqlserver.iam
#   backup_retention_period     = 7
#   db_subnet_group_name        = local.db_subnet_group_name # Copy the subnet group from the RDS Console
#   engine                      = data.aws_rds_orderable_db_instance.custom-sqlserver.engine
#   engine_version              = data.aws_rds_orderable_db_instance.custom-sqlserver.engine_version
#   identifier                  = "sql-instance-demo"
#   instance_class              = data.aws_rds_orderable_db_instance.custom-sqlserver.instance_class
#   kms_key_id                  = data.aws_kms_key.by_id.arn
#   multi_az                    = false # Custom for SQL Server does support multi-az
#   password                    = "avoid-plaintext-passwords"
#   storage_encrypted           = true
#   username                    = "test"

#   timeouts {
#     create = "3h"
#     delete = "3h"
#     update = "3h"
#   }
# }

# Lookup the available instance classes for the custom engine for the region being operated in
# data "aws_rds_orderable_db_instance" "custom-sqlserver" {
#   engine                     = "custom-sqlserver-se" # CEV engine to be used
#   engine_version             = "15.00.4249.2.v1"     # CEV engine version to be used
#   storage_type               = "gp3"
#   preferred_instance_classes = ["db.r5.xlarge", "db.r5.2xlarge", "db.r5.4xlarge"]
# }

# # The RDS instance resource requires an ARN. Look up the ARN of the KMS key.
# data "aws_kms_key" "by_id" {
#   key_id = "example-ef278353ceba4a5a97de6784565b9f78" # KMS key
# }
