resource "aws_acm_certificate" "teleport" {
  domain_name       = "teleport.${data.aws_route53_zone.selected.name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(
    local.default_module_tags,
    {
      VantaContainsUserData : false
      VantaContainsEPHI : false
    }
  )
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.teleport.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [
    each.value.record
  ]
  ttl = 60
}

resource "aws_acm_certificate_validation" "teleport" {
  certificate_arn = aws_acm_certificate.teleport.arn
  validation_record_fqdns = [
    for d in aws_route53_record.cert_validation : d.fqdn
  ]
}
