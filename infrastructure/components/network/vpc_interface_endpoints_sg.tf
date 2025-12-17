resource "aws_security_group" "interface_endpoints" {
  name        = "${local.aws_account_level_id}-vpc-interface-endpoints"
  description = "Security group for ingress rules to VPC Interface endpoints"
  vpc_id      = data.aws_vpc.vpc.id

  tags = {
    Name = "${local.aws_account_level_id}-vpc-interface-endpoints"
  }
}

resource "aws_vpc_security_group_ingress_rule" "common_to_interface_endpoints" {
  security_group_id = aws_security_group.interface_endpoints.id

  referenced_security_group_id = aws_security_group.common.id
  from_port                    = 443
  ip_protocol                  = "tcp"
  to_port                      = 443
}
