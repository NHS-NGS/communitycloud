import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import col, split, current_timestamp

args = getResolvedOptions(sys.argv, [
    'JOB_NAME',
    'RAW_BUCKET',
    'S3_TABLE_BUCKET',
    'S3_TABLE_NAMESPACE',
    'S3_TABLE_NAME'
])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Configure S3 Tables catalog
spark.conf.set("spark.sql.catalog.s3tablescatalog", "org.apache.iceberg.spark.SparkCatalog")
spark.conf.set("spark.sql.catalog.s3tablescatalog.catalog-impl", "software.amazon.s3tables.iceberg.S3TablesCatalog")
spark.conf.set("spark.sql.catalog.s3tablescatalog.warehouse", args['S3_TABLE_BUCKET'])

# Read VCF files
df = spark.read.text(f"s3://{args['RAW_BUCKET']}/uploads/")

# Filter headers
df_data = df.filter(~col("value").startswith("#"))

# Parse VCF columns
parsed_df = df_data.select(
    split(col("value"), "\t")[0].alias("chrom"),
    split(col("value"), "\t")[1].cast("long").alias("pos"),
    split(col("value"), "\t")[2].alias("id"),
    split(col("value"), "\t")[3].alias("ref"),
    split(col("value"), "\t")[4].alias("alt"),
    split(col("value"), "\t")[5].alias("qual"),
    split(col("value"), "\t")[6].alias("filter"),
    split(col("value"), "\t")[7].alias("info"),
    current_timestamp().alias("processed_at")
)

# Write to S3 Table (Iceberg)
table_identifier = f"s3tablescatalog.{args['S3_TABLE_NAMESPACE']}.{args['S3_TABLE_NAME']}"
parsed_df.writeTo(table_identifier).append()

job.commit()
