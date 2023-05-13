resource "aws_s3_bucket" "logs" {
  bucket = "cloudfront-logs"
  acl    = "log-delivery-write"

  lifecycle_rule {
    id      = "limpeza"
    status  = "Enabled"

    noncurrent_version_expiration {
      days = 30
    }
  }

  tags = {
    Project   = var.project_name
    Terraform = true
  }

  # Configuração para permitir que o CloudFront escreva logs no bucket
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::cloudfront-logs/*",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.frontend_origin_access_identity.cloudfront_access_identity_path}"
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.logs.id

  status = "Enabled"
}