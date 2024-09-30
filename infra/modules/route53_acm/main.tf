# retrieve information from Route 53 DNS zone(e.g. victorluk.com)
data "aws_route53_zone" "dns_zone" {
  name         = var.root_domain
  private_zone = false
}

#create a ssl certificate to manage https of our domain
resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = var.root_domain
  subject_alternative_names = ["*.${var.root_domain}"] //set this to include all subdomains to be included (docs.victorluk.com)
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true // create new certificate before detroying existing one
  }
}

resource "aws_route53_record" "dns_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.dns_zone.zone_id //this is fetched from AWS Route 53 (see first lines of this page)
  ttl             = var.dns_record_ttl
}

resource "aws_acm_certificate_validation" "ssl_validation" {
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [aws_route53_record.dns_validation.fqdn]
}