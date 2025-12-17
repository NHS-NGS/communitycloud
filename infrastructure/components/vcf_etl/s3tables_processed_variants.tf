# S3 Table Bucket for processed variants (Iceberg native)
resource "aws_s3tables_table_bucket" "processed_variants" {
  name = "${var.project}-processed-variants"
}

# S3 Table Namespace
resource "aws_s3tables_namespace" "vcf_data" {
  table_bucket_arn = aws_s3tables_table_bucket.processed_variants.arn
  namespace        = "vcf_data"
}

# S3 Table for processed variants (Iceberg)
resource "aws_s3tables_table" "processed_variants" {
  table_bucket_arn = aws_s3tables_table_bucket.processed_variants.arn
  namespace        = aws_s3tables_namespace.vcf_data.namespace
  name             = "processed_variants"
  format           = "ICEBERG"
}
