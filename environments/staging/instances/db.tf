data "aws_secretsmanager_secret" "db_password" {
  depends_on = [ aws_secretsmanager_secret_version.db_password ]
  name = "final_project_db_password"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

resource "aws_db_instance" "final-project-db" {
  engine = "mysql"
  engine_version = "5.7"
  identifier = "final-project-db-instance"
  db_name = "FinalProject"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = var.db_security_groups
  username = "test"
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
}