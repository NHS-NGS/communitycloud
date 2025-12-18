from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import getResolvedOptions
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, DoubleType
import uuid
import sys


# -------------------------------------------------------------------
# Glue Context
# -------------------------------------------------------------------
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

args = getResolvedOptions(sys.argv, ["VCF_INPUT_PATH", "TABLE_BUCKET_ARN"])
# -------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------
VCF_INPUT_PATH = args["VCF_INPUT_PATH"]
TABLE_BASE = "s3tables.`{args[TABLE_BUCKET_ARN]}`.vcf_data"

VARIANTS_TABLE = f"{TABLE_BASE}.variants"
SAMPLES_TABLE = f"{TABLE_BASE}.samples"
VARIANT_SAMPLES_TABLE = f"{TABLE_BASE}.variant_samples"

# -------------------------------------------------------------------
# Read VCF
# -------------------------------------------------------------------
raw_df = spark.read.text(VCF_INPUT_PATH)

# Header
header_line = raw_df.filter(F.col("value").startswith("#CHROM")).first()[0]
sample_names = header_line.split("\t")[9:]

# Data rows
data_df = raw_df.filter(~F.col("value").startswith("#"))
data_df = raw_df.filter(F.size(F.split(F.col("value"), "\t")) >= 9)

split_col = F.split(F.col("value"), "\t")

vcf_df = data_df.select(
    split_col.getItem(0).alias("chrom"),
    F.expr("try_cast(split(value, '\t')[1] as bigint)").alias("pos"),  # safe cast
    split_col.getItem(2).alias("vcf_id"),
    split_col.getItem(3).alias("ref"),
    split_col.getItem(4).alias("alt"),
    F.expr("try_cast(split(value, '\t')[5] as double)").alias("qual"),
    split_col.getItem(6).alias("filter"),
    split_col.getItem(7).alias("info"),
    split_col.getItem(8).alias("format"),
    F.slice(split_col, 9, F.size(split_col)-9).alias("sample_values")
)

vcf_df = vcf_df.filter(F.col("pos").isNotNull())

# -------------------------------------------------------------------
# Generate deterministic variant_id (important!)
# -------------------------------------------------------------------
vcf_df = vcf_df.withColumn(
    "variant_id",
    F.sha2(
        F.concat_ws(":", "chrom", "pos", "ref", "alt"),
        256
    )
)

# -------------------------------------------------------------------
# VARIANTS TABLE
# -------------------------------------------------------------------
variants_df = vcf_df.select(
    "variant_id",
    "chrom",
    "pos",
    "vcf_id",
    "ref",
    "alt",
    "qual",
    "filter"
)

variants_df.writeTo(VARIANTS_TABLE) \
    .partitionedBy("chrom") \
    .append()

# -------------------------------------------------------------------
# SAMPLES TABLE
# -------------------------------------------------------------------
samples_data = [(str(uuid.uuid4()), name) for name in sample_names]
samples_df = spark.createDataFrame(
    samples_data,
    ["sample_id", "sample_name"]
)

samples_df.writeTo(SAMPLES_TABLE).append()
# Broadcast sample mapping
sample_map = {row.sample_name: row.sample_id for row in samples_df.collect()}
broadcast_samples = spark.sparkContext.broadcast(sample_map)

# -------------------------------------------------------------------
# VARIANT_SAMPLES TABLE
# -------------------------------------------------------------------
exploded_df = vcf_df.select(
    "*",
    F.posexplode("sample_values").alias("sample_pos", "sample_val")
).withColumn(
    "sample_name",
    F.expr(f"array({','.join([repr(s) for s in sample_names])})[sample_pos]")
).withColumn(
    "sample_id",
    F.udf(lambda s: broadcast_samples.value[s], StringType())("sample_name")
)


variant_samples_df = exploded_df.select(
    "variant_id",
    "sample_id",
    F.expr("split(sample_val, ':', -1)[0]").alias("genotype"),
    F.expr("str_to_map(info, ';', '=')").alias("attributes"),
    F.lit(False).alias("is_reference_block")
)

# Bucket partition
variant_samples_df = variant_samples_df.withColumn(
    "variant_id_bucket",
    F.pmod(F.hash("variant_id"), F.lit(32))
)

variant_samples_df.write.mode("overwrite").parquet(VARIANT_SAMPLES_TABLE)
print("VCF → Iceberg ingestion completed successfully")
