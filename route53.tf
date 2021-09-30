locals {
  zone_records = flatten([
    for zone, domains in var.source_domains : [
      for record in domains : {
        record = record
        zone   = zone
      }
    ]
  ])
}

resource "aws_route53_zone" "this" {
  for_each = toset(keys(var.source_domains))

  name = each.value
}

resource "aws_route53_record" "this" {
  for_each = { for entry in local.zone_records : entry.record => entry }

  zone_id = aws_route53_zone.this[each.value.zone].zone_id
  name    = each.value.record
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}
