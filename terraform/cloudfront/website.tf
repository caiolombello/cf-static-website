resource "aws_s3_bucket_object" "all_files" {
  for_each = fileset("website/src/", "**/*")

  bucket        = aws_s3_bucket.frontend.bucket
  key           = each.value
  source        = "website/src/${each.value}"
  etag          = filemd5("website/src/${each.value}")
  content_type  = lookup(local.mime_types, regex_replace(each.value, ".*\\.(.+)$", "\\1"), "binary/octet-stream")
}