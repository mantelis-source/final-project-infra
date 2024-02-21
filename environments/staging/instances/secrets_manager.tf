resource "random_password" "db_random_password" {
  length = 20
  special = false
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "final_project_db_password"
}
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_random_password.result
}