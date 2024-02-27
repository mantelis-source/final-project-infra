data "aws_secretsmanager_secret" "db_creds" {
  name = "db_creds"
}

data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = data.aws_secretsmanager_secret.db_creds.id
}

resource "aws_db_instance" "final-project-db" {
  engine                 = "mysql"
  engine_version         = "8.0"
  identifier             = "final-project-db-instance"
  db_name                = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["db_name"]
  allocated_storage      = 10
  instance_class         = "db.t2.micro"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.db_security_groups
  username               = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["db_username"]
  password               = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["db_password"]
}