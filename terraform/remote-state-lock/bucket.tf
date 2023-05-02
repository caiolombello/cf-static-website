# Create a bucket for storage the terraform remote-state
resource "aws_s3_bucket" "remote-state" {
  bucket = "${var.resource_tags["Name"]}-${var.resource_tags["Environment"]}"
  tags   = var.resource_tags
}

# Block whole  public acess possibilities
resource "aws_s3_bucket_public_access_block" "remote-state" {
  bucket = aws_s3_bucket.remote-state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# Encrypt bucket With SSE-S3
resource "aws_s3_bucket_server_side_encryption_configuration" "remote-state" {
  bucket = aws_s3_bucket.remote-state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Active versioning on bucket
resource "aws_s3_bucket_versioning" "remote-state" {
  bucket = aws_s3_bucket.remote-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle for version archives 
resource "aws_s3_bucket_lifecycle_configuration" "remote-state" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.remote-state]
  bucket     = aws_s3_bucket.remote-state.bucket
  rule {
    id = "config"
    noncurrent_version_expiration {
      newer_noncurrent_versions = 7
      noncurrent_days           = 30
    }
    status = "Enabled"
  }
}

# Output bucket remote state
output "remote_state_bucket" {
  value = aws_s3_bucket.remote-state.bucket
}

# Output bucket arn 
output "remote_state_bucket_arn" {
  value = aws_s3_bucket.remote-state.arn
}
