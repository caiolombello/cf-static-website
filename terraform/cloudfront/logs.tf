resource "aws_s3_bucket" "logs" {
  bucket = "cloudfront-logs"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  # Configuração para permitir que o CloudFront escreva logs no bucket
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.logs.bucket}/*",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.frontend_origin_access_identity.cloudfront_access_identity_path}"
      }
    }
  ]
}
POLICY
}
