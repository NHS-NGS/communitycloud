output "__AWS_ACCOUNT_LEVEL_IDENTIFIER__" {
  value       = upper(local.aws_account_level_id)
  description = "Variable which contains project-environment-component string to include in resource names."
}

output "raw_variants_bucket_name" {
  value       = module.raw_variants_s3_bucket.s3_bucket_id
  description = "Name of the raw variants S3 bucket"
}

output "raw_variants_bucket_arn" {
  value       = module.raw_variants_s3_bucket.s3_bucket_arn
  description = "ARN of the raw variants S3 bucket"
}

output "s3_table_bucket_name" {
  value       = aws_s3tables_table_bucket.processed_variants.name
  description = "Name of the S3 Table Bucket for processed variants"
}

output "s3_table_bucket_arn" {
  value       = aws_s3tables_table_bucket.processed_variants.arn
  description = "ARN of the S3 Table Bucket for processed variants"
}

output "s3_table_name" {
  value       = aws_s3tables_table.processed_variants.name
  description = "Name of the S3 Table for processed variants"
}

output "s3_table_namespace" {
  value       = aws_s3tables_namespace.vcf_data.namespace
  description = "Namespace for the S3 Table"
}

# output "lambda_function_name" {
#   value       = aws_lambda_function.vcf_processor.function_name
#   description = "Name of the VCF processor Lambda function"
# }

# output "lambda_function_arn" {
#   value       = aws_lambda_function.vcf_processor.arn
#   description = "ARN of the VCF processor Lambda function"
# }

# output "lambda_execution_role_arn" {
#   value       = aws_iam_role.lambda_execution.arn
#   description = "ARN of the Lambda execution role"
# }

# output "glue_job_name" {
#   value       = aws_glue_job.vcf_etl.name
#   description = "Name of the Glue ETL job"
# }

# output "glue_database_name" {
#   value       = aws_glue_catalog_database.vcf_database.name
#   description = "Name of the Glue catalog database"
# }
