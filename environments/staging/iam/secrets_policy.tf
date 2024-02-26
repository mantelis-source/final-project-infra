resource "aws_iam_role_policy" "secretsmanager_read_logs_on" {
  name = "ReadSecrets"
  count = length(var.secrets_read_roles)
  role = var.secrets_read_roles[count.index]

  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"secretsmanager:GetSecretValue",
				"logs:CreateLogStream",
				"logs:PutLogEvents"
			],
			"Resource": [
				"arn:aws:secretsmanager:eu-central-1:744445457753:secret:db_creds-5aPXeO",
				"arn:aws:secretsmanager:eu-central-1:744445457753:secret:github_creds-2GliDQ"
			]
		}
	]
  })
}