resource "aws_cloudfront_origin_access_identity" "frontend_origin_access_identity" {
  comment = "access-identity-${aws_s3_bucket.frontend.bucket_domain_name}"
}

# distribuição no cloudfront
resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = aws_s3_bucket.frontend.bucket_domain_name
  default_root_object = "index.html"
  aliases             = ["${var.zone_name}","*.${var.zone_name}"]  # zona  da route 53
                        

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["BR", "US"]
    }
  }



  # bucket S3
  origin {
    origin_id   = aws_s3_bucket.frontend.id
    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_origin_access_identity.cloudfront_access_identity_path
    }
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 400
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  # comportamento padrao
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.frontend.id
    compress         = false

    forwarded_values {
      cookies {
        forward           = "none"
        whitelisted_names = []
      }

      headers                 = []
      query_string            = false
      query_string_cache_keys = []
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    smooth_streaming       = false

  }

  tags = {
    Project = var.project_name
    Terraform = true
  }

  depends_on = [aws_acm_certificate_validation.domain]
}
