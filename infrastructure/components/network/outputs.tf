output "__AWS_ACCOUNT_LEVEL_IDENTIFIER__" {
  value       = upper(local.aws_account_level_id)
  description = "Variable which contains project-environment-component string to include in resource names."
}

output "vpc_id" {
  value = {
    vpc = {
      id   = data.aws_vpc.vpc.id
      cidr = data.aws_vpc.vpc.cidr_block
    }
  }
  description = "ID and CIDR of the environment VPC"
}

output "subnets" {
  value = {
    public   = data.aws_subnets.public.ids
    private  = data.aws_subnets.private.ids
    database = data.aws_subnets.database.ids
  }
  description = "IDs of Public, private and database subnets"
}

output "common_sg_id" {
  value       = aws_security_group.common.id
  description = "ID of the common security group"
}

output "database_sg_id" {
  value       = aws_security_group.rds_postgres_sg.id
  description = "ID of the database security group"
}
