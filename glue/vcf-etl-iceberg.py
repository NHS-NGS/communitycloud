from pyspark.context import SparkContext
from awsglue.context import GlueContext
from pyspark.sql import functions as F
from pyspark.sql.types import *
import uuid

# -------------------------------------------------------------------
# Glue Context
# -------------------------------------------------------------------
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

# -------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------
VCF_INPUT_PATH = "s3://gms-raw-variants/vcf/"
TABLE_BASE = "s3tables.`TABLE_BUCKET_ARN`.vcf_data"

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

fields = F.split(F.col("value"), "\t")

vcf_df = data_df.select(
    fields[0].alias("chrom"),
    fields[1].cast("long").alias("pos"),
    fields[2].alias("vcf_id"),
    fields[3].alias("ref"),
    fields[4].alias("alt"),
    fields[5].cast("double").alias("qual"),
    fields[6].alias("filter"),
    fields[7].alias("info"),
    fields[8].alias("format"),
    F.expr("slice(fields, 10, size(fields))").alias("sample_values")
)

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
exploded_df = vcf_df \
    .withColumn("sample", F.posexplode("sample_values")) \
    .withColumn("sample_name", F.expr(f"array({','.join([repr(s) for s in sample_names])})[sample.pos]")) \
    .withColumn("sample_id", F.udf(lambda s: broadcast_samples.value[s], StringType())("sample_name"))

variant_samples_df = exploded_df.select(
    "variant_id",
    "sample_id",
    F.split("sample.col", ":")[0].alias("genotype"),
    F.expr("str_to_map(info, ';', '=')").alias("attributes"),
    F.lit(False).alias("is_reference_block")
)

# Bucket partition
variant_samples_df = variant_samples_df.withColumn(
    "variant_id_bucket",
    F.pmod(F.hash("variant_id"), F.lit(32))
)

variant_samples_df.writeTo(VARIANT_SAMPLES_TABLE) \
    .append()

print("VCF → Iceberg ingestion completed successfully")
