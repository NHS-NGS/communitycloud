resource "aws_security_group" "common" {
  name        = "${local.aws_account_level_id}-common"
  description = "Security group for egress rules to common services"
  vpc_id      = data.aws_vpc.vpc.id

  tags = {
    Name = "${local.aws_account_level_id}-common"
  }
}

resource "aws_vpc_security_group_egress_rule" "common_to_interface_endpoints" {
  security_group_id = aws_security_group.common.id

  referenced_security_group_id = aws_security_group.interface_endpoints.id
  from_port                    = 443
  ip_protocol                  = "tcp"
  to_port                      = 443
}
