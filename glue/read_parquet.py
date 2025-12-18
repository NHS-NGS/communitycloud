import pandas as pd

# Replace with your Parquet folder path
parquet_path = "output/variants/part-00000-a4ab5050-631e-4fa4-a0f1-b1f6e3671b0e-c000.snappy.parquet"

# Read the Parquet files
df = pd.read_parquet(parquet_path)

# Show first 5 rows
print(df.head())
