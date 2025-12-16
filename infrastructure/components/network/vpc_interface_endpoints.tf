resource "aws_vpc_endpoint" "interface" {
  for_each          = toset(local.interface_endpoints)
  vpc_id            = data.aws_vpc.vpc.id
  service_name      = each.value
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.interface_endpoints.id,
  ]

  private_dns_enabled = true
}
