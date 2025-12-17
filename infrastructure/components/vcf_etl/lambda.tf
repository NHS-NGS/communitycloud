# # Lambda function for VCF processing
# resource "aws_lambda_function" "etl_vcf" {
#   function_name = "${local.aws_account_level_id}-etl-vcf"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = "python3.11"
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory

#   filename         = "${path.module}/files/lambda_function.zip"
#   source_code_hash = filebase64sha256("${path.module}/files/lambda_function.zip")

#   environment {
#     variables = {
#       RAW_BUCKET         = module.raw_variants_s3_bucket.s3_bucket_id
#       S3_TABLE_BUCKET    = aws_s3tables_table_bucket.processed_variants.name
#       S3_TABLE_NAMESPACE = aws_s3tables_namespace.vcf_data.namespace
#       S3_TABLE_NAME      = aws_s3tables_table.processed_variants.name
#       GLUE_JOB_NAME      = aws_glue_job.vcf_etl.name
#     }
#   }

#   tags = {
#     Name = "${local.aws_account_level_id}-vcf-processor"
#   }
# }

# # CloudWatch Log Group for Lambda
# resource "aws_cloudwatch_log_group" "lambda_logs" {
#   name              = "/aws/lambda/${aws_lambda_function.etl_vcf.function_name}"
#   retention_in_days = 14

#   tags = {
#     Name = "${local.aws_account_level_id}-lambda-logs"
#   }
# }

# # S3 event trigger
# resource "aws_s3_bucket_notification" "raw_variants_trigger" {
#   bucket = module.raw_variants_s3_bucket.s3_bucket_id

#   lambda_function {
#     lambda_function_arn = aws_lambda_function.vcf_processor.arn
#     events              = ["s3:ObjectCreated:*"]
#     filter_prefix       = "uploads/"
#     filter_suffix       = ".vcf"
#   }

#   depends_on = [aws_lambda_permission.s3_invoke]
# }

# resource "aws_lambda_permission" "s3_invoke" {
#   statement_id  = "AllowS3Invoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.etl_vcf.function_name
#   principal     = "s3.amazonaws.com"
#   source_arn    = module.raw_variants_s3_bucket.s3_bucket_arn
# }
