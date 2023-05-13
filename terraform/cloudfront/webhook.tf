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

resource "aws_lambda_function" "lambda_discord_webhook" {
  function_name = "lambda_discord_webhook"
  handler       = "${aws_lambda_function.lambda_discord_webhook.function_name}.lambda_handler"
  role          = aws_iam_role.lambda_discord_webhook.arn
  runtime       = "python3.9"

  inline_code = <<EOF
import json
import os
import requests

def lambda_handler(event, context):
    discord_webhook_url = os.getenv('DISCORD_WEBHOOK_URL')
    sns_message = event['Records'][0]['Sns']['Message']
    message_dict = json.loads(sns_message)

    if 'AlarmName' in message_dict and 'NewStateValue' in message_dict:
        alarm_name = message_dict['AlarmName']
        alarm_state = message_dict['NewStateValue']

        if 'faturamento' in alarm_name.lower():
            message = f"O Alarme de Faturamento foi acionado. Novo Estado: {alarm_state}"
        elif 'acessos' in alarm_name.lower():
            message = f"O Alarme de Acessos de Usuários foi acionado. Novo Estado: {alarm_state}"
        elif 'disponibilidade' in alarm_name.lower():
            message = f"O Alarme de Disponibilidade do Site foi acionado. Novo Estado: {alarm_state}"
        else:
            message = f"O Alarme {alarm_name} foi acionado. Novo Estado: {alarm_state}"
    else:
        message = "Uma notificação desconhecida foi recebida."

    data = {
        "content": message
    }

    requests.post(discord_webhook_url, data=json.dumps(data), headers={"Content-Type": "application/json"})
EOF

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
