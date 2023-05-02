# configuracao de certificados
resource "aws_acm_certificate" "cert" {
  domain_name               = "${var.zone_name}"
  subject_alternative_names = ["*.${var.zone_name}"]
  validation_method         = "DNS"
  provider                  = aws.ACM

  tags = {
    Project = var.project_name
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# validacao do dominio
resource "aws_acm_certificate_validation" "domain" {
  certificate_arn         = aws_acm_certificate.cert-develop.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate : record.fqdn]
  provider                  = aws.ACM

  depends_on = [data.aws_route53_zone.domain]
}
