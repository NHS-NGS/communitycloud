# Glue Catalog Database
resource "aws_glue_catalog_database" "vcf_database" {
  name        = replace("${local.aws_account_level_id}_vcf_db", "-", "_")
  description = "Database for VCF ETL with S3 Tables"
}

# AWS Glue job for VCF ETL
resource "aws_glue_job" "vcf_etl" {
  name     = "${local.aws_account_level_id}-vcf-etl"
  role_arn = aws_iam_role.glue_execution.arn

  command {
    name            = "glueetl"
    script_location = "s3://${data.terraform_remote_state.account.outputs.functions_code_s3_bucket_name}/glue/vcf-etl-iceberg.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-bookmark-option"                                  = "job-bookmark-enable"
    "--enable-glue-datacatalog"                              = "true"
    "--datalake-formats"                                     = "iceberg"
    "--conf"                                                 = "spark.sql.catalog.s3tablescatalog=org.apache.iceberg.spark.SparkCatalog --conf spark.sql.catalog.s3tablescatalog.catalog-impl=software.amazon.s3tables.iceberg.S3TablesCatalog --conf spark.sql.catalog.s3tablescatalog.warehouse=${aws_s3tables_table_bucket.processed_variants.arn} --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions"
    "--RAW_BUCKET"                                           = module.raw_variants_s3_bucket.s3_bucket_id
    "--S3_TABLE_BUCKET"                                      = aws_s3tables_table_bucket.processed_variants.arn
    "--S3_TABLE_NAMESPACE"                                   = aws_s3tables_namespace.vcf_data.namespace
    "--S3_TABLE_NAME"                                        = aws_s3tables_table.processed_variants.name
  }

  timeout           = var.glue_timeout
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2
  execution_class   = "FLEX"

  tags = {
    Name = "${local.aws_account_level_id}-vcf-etl"
  }
}
