resource "aws_s3_bucket_object" "html" {
  for_each     = fileset("../../website/src", "**/*.html")
  bucket       = aws_s3_bucket.frontend.bucket
  key          = each.value
  source       = "../../website/src/${each.value}"
  etag         = filemd5("../../website/src/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "js" {
  for_each     = fileset("../../website/src", "**/*.js")
  bucket       = aws_s3_bucket.frontend.bucket
  key          = each.value
  source       = "../../website/src/${each.value}"
  etag         = filemd5("../../website/src/${each.value}")
  content_type = "application/javascript"
}

resource "aws_s3_bucket_object" "css" {
  for_each     = fileset("../../website/src/assets/css", "**/*.css")
  bucket       = aws_s3_bucket.frontend.bucket
  key          = each.value
  source       = "../../website/src/assets/css/${each.value}"
  etag         = filemd5("../../website/src/assets/css/${each.value}")
  content_type = "text/css"
}

locals {
  image_content_types = {
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    svg  = "image/svg+xml"
    ico  = "image/x-icon"
  }
}

resource "aws_s3_bucket_object" "img" {
  for_each = fileset("../../website/src/assets/images", "**/*.*")

  bucket       = aws_s3_bucket.frontend.bucket
  key          = each.value
  source       = "../../website/src/assets/images/${each.value}"
  etag         = filemd5("../../website/src/assets/images/${each.value}")
  content_type = lookup(local.image_content_types, lower(regex("\\.(.+)$", each.value)[0]), "binary/octet-stream")
}

# en
resource "aws_s3_bucket_object" "html-en" {
  for_each     = toset(["index-en.html"])
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "en.html"
  source       = "../../website/src/index-en.html"
  etag         = filemd5("../../website/src/index-en.html")
  content_type = "text/html"
}
