# _TEMPLATE

## General
This is a template component that should be used to create GMS specific components going forward and updated everytime there are fundamental changes are made that all components should implement.

## Terraform docs
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID where resources will be deployed | `string` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | Component name used for resource naming and tagging | `string` | `"_template"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., sbx, dev, tst, stg, prd) | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name used for resource naming and tagging | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_sbx_account_level_iam_id"></a> [sbx\_account\_level\_iam\_id](#input\_sbx\_account\_level\_iam\_id) | Account level IAM identifier for Sandbox environment | `string` | n/a | yes |
| <a name="input_sbx_iam_permissions_boundary_policy_arn"></a> [sbx\_iam\_permissions\_boundary\_policy\_arn](#input\_sbx\_iam\_permissions\_boundary\_policy\_arn) | ARN of the IAM permissions boundary policy for Sandbox environment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output___AWS_ACCOUNT_LEVEL_IDENTIFIER__"></a> [\_\_AWS\_ACCOUNT\_LEVEL\_IDENTIFIER\_\_](#output\_\_\_AWS\_ACCOUNT\_LEVEL\_IDENTIFIER\_\_) | Variable which contains project-environment-component string to include in resource names. |
<!-- END_TF_DOCS -->
