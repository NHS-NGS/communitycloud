# ACCOUNT

## General

The account component is a top-level module that defines AWS account-level configuration which must be established before other components can be deployed. It does not contain GMS environment-specific settings, but instead manages prerequisites and shared resources required prior to provisioning environment-related infrastructure.

## Terraform docs
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.api_gateway_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.api_gateway_logs_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID where resources will be deployed | `string` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | Component name used for resource naming and tagging | `string` | `"account"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., sbx, dev, tst, stg, prd) | `string` | n/a | yes |
| <a name="input_lb_access_logs_ia_transition_days"></a> [lb\_access\_logs\_ia\_transition\_days](#input\_lb\_access\_logs\_ia\_transition\_days) | Number of days after which load balancer access logs transition to IA storage class | `number` | `30` | no |
| <a name="input_lb_access_logs_retention_days"></a> [lb\_access\_logs\_retention\_days](#input\_lb\_access\_logs\_retention\_days) | Number of days to retain load balancer access logs | `number` | `60` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name used for resource naming and tagging | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_s3_access_logs_ia_transition_days"></a> [s3\_access\_logs\_ia\_transition\_days](#input\_s3\_access\_logs\_ia\_transition\_days) | Number of days after which S3 access logs transition to IA storage class | `number` | `30` | no |
| <a name="input_s3_access_logs_retention_days"></a> [s3\_access\_logs\_retention\_days](#input\_s3\_access\_logs\_retention\_days) | Number of days to retain S3 access logs | `number` | `60` | no |
| <a name="input_sbx_account_level_iam_id"></a> [sbx\_account\_level\_iam\_id](#input\_sbx\_account\_level\_iam\_id) | Account level IAM identifier for Sandbox environment | `string` | n/a | yes |
| <a name="input_sbx_iam_permissions_boundary_policy_arn"></a> [sbx\_iam\_permissions\_boundary\_policy\_arn](#input\_sbx\_iam\_permissions\_boundary\_policy\_arn) | ARN of the IAM permissions boundary policy for Sandbox environment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output___AWS_ACCOUNT_LEVEL_IDENTIFIER__"></a> [\_\_AWS\_ACCOUNT\_LEVEL\_IDENTIFIER\_\_](#output\_\_\_AWS\_ACCOUNT\_LEVEL\_IDENTIFIER\_\_) | Variable which contains project-environment-component string to include in resource names. |
| <a name="output_lb_access_logs_s3_bucket_id"></a> [lb\_access\_logs\_s3\_bucket\_id](#output\_lb\_access\_logs\_s3\_bucket\_id) | ID of the S3 bucket for ELB/NLB access logs |
| <a name="output_s3_access_logs_s3_bucket_id"></a> [s3\_access\_logs\_s3\_bucket\_id](#output\_s3\_access\_logs\_s3\_bucket\_id) | ID of the S3 bucket for S3 access logs |
<!-- END_TF_DOCS -->
