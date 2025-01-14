output "endpoint_id" {
  description = "Resolver endpoint ID"
  value       = aws_route53_resolver_endpoint.resolver_endpoint.id
}

output "security_group_id" {
  description = "Resolver endpoint security group ID"
  value       = local.security_group_id
}

output "ip_addresses" {
  description = "Resolver IP addresses"
  value       = [for obj in aws_route53_resolver_endpoint.resolver_endpoint.ip_address : obj.ip]
}
