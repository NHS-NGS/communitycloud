output "__AWS_ACCOUNT_LEVEL_IDENTIFIER__" {
  value       = upper(local.aws_account_level_id)
  description = "Variable which contains project-environment-component string to include in resource names."
}

# output "s3_access_logs_s3_bucket_id" {
#   value       = module.s3_access_logs_s3_bucket.s3_bucket_id
#   description = "ID of the S3 bucket for S3 access logs"
# }

# output "lb_access_logs_s3_bucket_id" {
#   value       = module.lb_access_logs_s3_bucket.s3_bucket_id
#   description = "ID of the S3 bucket for ELB/NLB access logs"
# }

# output "ecr_repository_url" {
#   value       = aws_ecr_repository.ecr.repository_url
#   description = "URL of ECR repository in account"
# }
