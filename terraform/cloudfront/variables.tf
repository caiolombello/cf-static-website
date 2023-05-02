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
  default     = "caio.lombello.com"
  type        = string
  description = "Zona Route 53."
}
