# projeto
variable "project_name" {
  default     = "caio.lombello.com"
  type        = string
  description = "Projeto de automação da infraestrutura para Portfólio estático."
}

# regiao aws
variable "aws_region" {
  default     = "us-east-1"
  type        = string
  description = "Regiao da AWS."
}

# s3
variable "bucket_frontend" {
  default     = "caio.lombello.com-static-files-prd"
  type        = string
  description = "Bucket de arquivos estáticos."
}

# route 53
variable "zone_name" {
  default     = "lombello.com"
  type        = string
  description = "Zona Route 53."
}

variable "topic_arn" {
  default = "arn:aws:sns:us-east-1:479815389002:Billing_Alarm"
  type = string
  description = "Topic ARN"
}

variable "discord_webhook_url" {
  default = "https://discord.com/api/webhooks/1106987059060678777/ylRbmn_062yUj_GMRVUKkMGQtnyBkcVhxbTV77aCWHOHj7shaMmr7V8kKYGiy5oRVKBr"
  type = string
}