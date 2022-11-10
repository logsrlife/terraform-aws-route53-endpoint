locals {
  security_group_id = var.create_security_group ? aws_security_group.r53_endpoint_sg.id : var.security_group_id
}

resource "aws_security_group" "r53_endpoint_sg" {
  count = var.create_security_group == true ? 1 : 0

  name_prefix = "r53-endpoint-"
  tags        = var.tags
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "endpoint_dns_udp" {
  count             = var.create_security_group == true ? 1 : 0
  type              = var.direction == "inbound" ? "ingress" : "egress"
  from_port         = var.dns_port
  to_port           = var.dns_port
  protocol          = "udp"
  cidr_blocks       = var.allowed_resolvers
  security_group_id = aws_security_group.r53_endpoint_sg.id
}

resource "aws_security_group_rule" "endpoint_dns_tcp" {
  count             = var.create_security_group == true ? 1 : 0
  type              = var.direction == "inbound" ? "ingress" : "egress"
  from_port         = var.dns_port
  to_port           = var.dns_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_resolvers
  security_group_id = aws_security_group.r53_endpoint_sg.id
}

resource "aws_route53_resolver_endpoint" "resolver_endpoint" {
  direction          = upper(var.direction)
  security_group_ids = [local.security_group_id]
  name               = var.name
  tags               = var.tags

  dynamic "ip_address" {
    for_each = var.ip_addresses

    content {
      ip        = lookup(ip_address.value, "ip", null)
      subnet_id = ip_address.value.subnet_id
    }
  }

}
