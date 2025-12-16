
resource "aws_security_group" "rds_postgres_sg" {
  name        = "${local.aws_account_level_id}-database-sg"
  description = "Database Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.aws_account_level_id}-database-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_common" {
  security_group_id = aws_security_group.common.id

  referenced_security_group_id = aws_security_group.rds_postgres_sg.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}
