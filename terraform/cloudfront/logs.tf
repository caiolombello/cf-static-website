resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-cloudfront-logs"
  tags = {
    Name      = "cloudfront-logs"
    Project   = var.project_name
    Terraform = true
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.logs.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.logs.arn}",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.frontend_origin_access_identity.iam_arn}"
      }
    },
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.logs.arn}/*",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.frontend_origin_access_identity.iam_arn}"
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "limpeza"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}