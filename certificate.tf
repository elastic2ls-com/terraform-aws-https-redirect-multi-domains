locals {
  sans = sort(
    flatten([
      for domains in var.source_domains : domains
    ])
  )
}

resource "aws_acm_certificate" "cert" {
  provider                  = aws.certificate_region
  domain_name               = local.sans[0]
  subject_alternative_names = slice(local.sans, 1, length(local.sans))
  validation_method         = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
      zone   = element([ for key, zone in var.source_domains : key if contains(zone, dvo.domain_name) ], 0)
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.this[each.value.zone].id
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.certificate_region
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
