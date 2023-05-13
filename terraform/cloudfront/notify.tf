resource "aws_route53_health_check" "cloudfront" {
  fqdn              = aws_route53_record.cf_distribution.name
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = "2"
  request_interval  = "30"
}

resource "aws_cloudwatch_metric_alarm" "health_check" {
  alarm_name          = "${aws_route53_record.cf_distribution.name}_health_check_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = "Este alarme é disparado quando o status do Health Check muda"
  alarm_actions       = [var.topic_arn]
  dimensions = {
    HealthCheckId = aws_route53_health_check.cloudfront.id
  }
}

resource "aws_sns_topic_subscription" "lambda_discord_webhook" {
  topic_arn = var.topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_discord_webhook.arn
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_discord_webhook.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_discord_webhook" {
  function_name    = "lambda_discord_webhook"
  handler          = "lambda_discord_webhook.lambda_handler"
  role             = aws_iam_role.lambda_discord_webhook.arn
  runtime          = "python3.8"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  environment {
    variables = {
      DISCORD_WEBHOOK_URL = var.discord_webhook_url
    }
  }
}

resource "aws_iam_role" "lambda_discord_webhook" {
  name = "role_lambda_discord_webhook"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_discord_webhook" {
  name = "policy"
  role = aws_iam_role.lambda_discord_webhook.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
