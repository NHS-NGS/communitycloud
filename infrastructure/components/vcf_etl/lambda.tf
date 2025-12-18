# Lambda function for VCF processing
resource "aws_lambda_function" "etl_vcf" {
  function_name = "vcf-etl-trigger"
  role          = aws_iam_role.lambda_execution.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory

  s3_bucket = data.terraform_remote_state.account.outputs.functions_code_s3_bucket_name
  s3_key    = "vcf-etl-trigger/lambda_function.zip"

  environment {
    variables = {
      VCF_INPUT_PATH   = "s3://gms-raw-variants/vcf/"
      TABLE_BUCKET_ARN = aws_s3tables_table.processed_variants.arn
      GLUE_JOB_NAME    = aws_glue_job.vcf_etl.name
    }
  }

  tags = {
    Name = "vcf-etl-trigger"
  }
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.etl_vcf.function_name}"
  retention_in_days = 14

  tags = {
    Name = "${local.aws_account_level_id}-lambda-logs"
  }
}

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

resource "aws_lambda_permission" "s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.etl_vcf.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.raw_variants_s3_bucket.s3_bucket_arn
}
