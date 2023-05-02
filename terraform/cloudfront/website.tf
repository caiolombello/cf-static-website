resource "aws_s3_bucket_object" "html" {
  for_each = fileset("../../website/src", "**/*.html")
  bucket = aws_s3_bucket.frontend.bucket
  key    = each.value
  source = "../../website/src/${each.value}"
  etag   = filemd5("../../website/src/${each.value}")
  content_type = "text/html"
}
