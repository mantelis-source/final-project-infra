resource "aws_cloudwatch_log_group" "final-project" {
  name = var.log_group_name
  skip_destroy = false
  retention_in_days = 3
}
resource "aws_cloudwatch_log_stream" "final-project" {
  name = var.log_group_name
  log_group_name = aws_cloudwatch_log_group.final-project.name
}