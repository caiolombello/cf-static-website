# bucket para armazenamento dos arquivos estaticos
resource "aws_s3_bucket" "frontend" {
  bucket        = var.bucket_frontend
  acl           = "private"
  force_destroy = true

  tags = {
    Name      = var.bucket_frontend
    Project   = var.project_name
    Terraform = true
  }
}

resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Suspended"
  }
}

# configuracao de acesso ao bucket
resource "aws_s3_bucket_public_access_block" "frontend_block_acls_public" {
  bucket              = aws_s3_bucket.frontend.id
  block_public_acls   = true # bloqueio de acesso publico por acls
  block_public_policy = true # bloqueio de acesso publico por policy
  depends_on = [
    aws_s3_bucket.frontend
  ]
}

# configuracao da policy para o bucket
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.frontend_policy_document.json
  depends_on = [
    aws_s3_bucket.frontend
  ]
}

# configuracao da policy  de acesso para os documentos do bucket pelo cloud front
data "aws_iam_policy_document" "frontend_policy_document" {
  statement {
    sid       = "CF-Policy-${var.bucket_frontend}"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.frontend.arn}/*"]
    effect    = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.frontend_origin_access_identity.iam_arn
      ]
    }
  }
}