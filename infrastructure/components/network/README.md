# NETWORK

## General

The network component is a top-level module that manages shared network infrastructure. It provides VPC-related configuration and resources that are required by components dependent on networking.

Since BSA accounts are provisioned with a VPC, multiple subnets, and integration with a Transit Gateway (supporting centralised egress and optional east-west inter-service traffic), this component is responsible for sourcing and exposing that configuration in a structured, consumable format.

## Terraform docs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.9.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_flow_logs_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route_tables.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_subnets.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID where resources will be deployed | `string` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | Component name used for resource naming and tagging | `string` | `"network"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., sbx, dev, tst, stg, prd) | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name used for resource naming and tagging | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_sbx_account_level_iam_id"></a> [sbx\_account\_level\_iam\_id](#input\_sbx\_account\_level\_iam\_id) | Account level IAM identifier for Sandbox environment | `string` | n/a | yes |
| <a name="input_sbx_iam_permissions_boundary_policy_arn"></a> [sbx\_iam\_permissions\_boundary\_policy\_arn](#input\_sbx\_iam\_permissions\_boundary\_policy\_arn) | ARN of the IAM permissions boundary policy for Sandbox environment | `string` | n/a | yes |
| <a name="input_vpc_flow_logs_retention_days"></a> [vpc\_flow\_logs\_retention\_days](#input\_vpc\_flow\_logs\_retention\_days) | Retention of the VPC flow logs cloudwatch log group. Defaults to 7. | `number` | `7` | no |
| <a name="input_vpc_flow_logs_traffic_type"></a> [vpc\_flow\_logs\_traffic\_type](#input\_vpc\_flow\_logs\_traffic\_type) | Traffic type to be captured in VPC Flow logs. Defaults to REJECT. | `string` | `"REJECT"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the environment VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output___AWS_ACCOUNT_LEVEL_IDENTIFIER__"></a> [\_\_AWS\_ACCOUNT\_LEVEL\_IDENTIFIER\_\_](#output\_\_\_AWS\_ACCOUNT\_LEVEL\_IDENTIFIER\_\_) | Variable which contains project-environment-component string to include in resource names. |
| <a name="output_common_sg_id"></a> [common\_sg\_id](#output\_common\_sg\_id) | ID of the common security group |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | IDs of Public, private and database subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID and CIDR of the environment VPC |
<!-- END_TF_DOCS -->
