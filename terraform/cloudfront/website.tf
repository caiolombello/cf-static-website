locals {
  mime_types = {
    "css"  = "text/css"
    "html" = "text/html"
    "js"   = "application/javascript"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "gif"  = "image/gif"
    "ico"  = "image/x-icon"
    "svg"  = "image/svg+xml"
    "json" = "application/json"
    "woff" = "font/woff"
    "woff2" = "font/woff2"
    "ttf"  = "font/ttf"
    "otf"  = "font/otf"
    "eot"  = "application/vnd.ms-fontobject"
  }
}

resource "aws_s3_bucket_object" "all_files" {
  for_each = { for f in fileset("website/src/", "**/*") : f => f }

  bucket        = aws_s3_bucket.frontend.bucket
  key           = each.key
  source        = "website/src/${each.key}"
  etag          = filemd5("website/src/${each.key}")
  content_type  = lookup(local.mime_types, regex(".*\\.(.+)$", each.key), "binary/octet-stream")
}

output "all_files" {
  value = [for f in aws_s3_bucket_object.all_files : f.key]
}
