from pyathena import connect
import pandas as pd

# Athena connection
conn = connect(
    s3_staging_dir='s3://your-query-results-bucket/',  # Athena needs a staging location
    region_name='us-east-1'  # your region
)

# Query Iceberg table
query = """
SELECT v.chrom, v.pos, vs.sample_id, vs.genotype
FROM "vcf_data"."variants" v
JOIN "vcf_data"."variant_samples" vs
ON v.variant_id = vs.variant_id
LIMIT 20
"""

df = pd.read_sql(query, conn)

# Show results
df.head()
