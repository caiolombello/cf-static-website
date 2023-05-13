resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-cloudfront-logs"
  acl    = "private"
  tags = {
    Name      = "cloudfront-logs"
    Project   = var.project_name
    Terraform = true
  }
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  statement {
    sid    = "Allow Cloudfront Logging"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
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