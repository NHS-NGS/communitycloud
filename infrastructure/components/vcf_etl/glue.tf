# # Glue Catalog Database - used for integration with S3 Tables
# resource "aws_glue_catalog_database" "vcf_database" {
#   name        = replace("${local.aws_account_level_id}_vcf_db", "-", "_")
#   description = "Database for VCF ETL - federated with S3 Tables"

#   federated_database {
#     connection_name = aws_glue_connection.s3tables.name
#     identifier      = aws_s3tables_table_bucket.processed_variants.arn
#   }
# }

# # Glue connection for S3 Tables
# resource "aws_glue_connection" "s3tables" {
#   name            = "${local.aws_account_level_id}-s3tables"
#   connection_type = "FEDERATED"

#   connection_properties = {
#     SparkProperties = jsonencode({
#       "spark.sql.catalog.s3tablescatalog"              = "org.apache.iceberg.spark.SparkCatalog"
#       "spark.sql.catalog.s3tablescatalog.catalog-impl" = "software.amazon.s3tables.iceberg.S3TablesCatalog"
#       "spark.sql.catalog.s3tablescatalog.warehouse"    = aws_s3tables_table_bucket.processed_variants.arn
#       "spark.sql.extensions"                           = "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions"
#     })
#   }

#   tags = {
#     Name = "${local.aws_account_level_id}-s3tables"
#   }
# }

# # AWS Glue job for VCF ETL
# resource "aws_glue_job" "vcf_etl" {
#   name     = "${local.aws_account_level_id}-vcf-etl"
#   role_arn = aws_iam_role.glue_execution.arn

#   command {
#     name            = "glueetl"
#     script_location = "s3://${module.raw_variants_s3_bucket.s3_bucket_id}/scripts/vcf_etl.py"
#     python_version  = "3"
#   }

#   default_arguments = {
#     "--job-bookmark-option"     = "job-bookmark-enable"
#     "--enable-glue-datacatalog" = "true"
#     "--enable-iceberg-tables"   = "true"
#     "--RAW_BUCKET"              = module.raw_variants_s3_bucket.s3_bucket_id
#     "--S3_TABLE_BUCKET"         = aws_s3tables_table_bucket.processed_variants.arn
#     "--S3_TABLE_NAMESPACE"      = aws_s3tables_namespace.vcf_data.namespace
#     "--S3_TABLE_NAME"           = aws_s3tables_table.processed_variants.name
#   }

#   timeout           = var.glue_timeout
#   glue_version      = "4.0"
#   worker_type       = "G.1X"
#   number_of_workers = 2
#   execution_class   = "FLEX"

#   tags = {
#     Name = "${local.aws_account_level_id}-vcf-etl"
#   }
# }
