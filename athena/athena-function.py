import boto3
import time
import pandas as pd
import os


QUERY_OUTPUT_BUCKET = 's3://your-athena-query-results/'  
DATABASE_NAME = 'vcf_data'
TABLE_NAME = 'variants'


TABLE_BUCKET_ARN = os.environ.get('TABLE_BUCKET_ARN')
if not TABLE_BUCKET_ARN:
    raise ValueError("Environment variable TABLE_BUCKET_ARN is not set.")

TABLE_LOCATION = f"{TABLE_BUCKET_ARN}/{TABLE_NAME}"


athena_client = boto3.client('athena')


def run_athena_query_to_df(query, database=None):
    response = athena_client.start_query_execution(
        QueryString=query,
        QueryExecutionContext={'Database': database} if database else {},
        ResultConfiguration={'OutputLocation': QUERY_OUTPUT_BUCKET}
    )
    
    query_execution_id = response['QueryExecutionId']
    
   
    while True:
        status = athena_client.get_query_execution(QueryExecutionId=query_execution_id)
        state = status['QueryExecution']['Status']['State']
        if state in ['SUCCEEDED', 'FAILED', 'CANCELLED']:
            break
        time.sleep(2)
    
    if state != 'SUCCEEDED':
        raise Exception(f"Athena query failed: {state}")
    
   
    result_location = status['QueryExecution']['ResultConfiguration']['OutputLocation']
    
   
    df = pd.read_csv(result_location)
    return df


create_db_query = f"CREATE DATABASE IF NOT EXISTS {DATABASE_NAME}"
run_athena_query_to_df(create_db_query)
print(f"Database '{DATABASE_NAME}' created or already exists.")


create_table_query = f"""
CREATE TABLE IF NOT EXISTS {DATABASE_NAME}.{TABLE_NAME} (
    variant_id STRING,
    chrom STRING,
    pos BIGINT,
    vcf_id STRING,
    ref STRING,
    alt STRING,
    qual DOUBLE,
    filter STRING
)
USING ICEBERG
LOCATION '{TABLE_LOCATION}'
"""
run_athena_query_to_df(create_table_query, database=DATABASE_NAME)
print(f"Table '{TABLE_NAME}' created or already exists in database '{DATABASE_NAME}'.")


select_query = f"""
SELECT variant_id, chrom, pos, ref, alt
FROM {TABLE_NAME}
WHERE chrom = '1'
LIMIT 10
"""
df = run_athena_query_to_df(select_query, database=DATABASE_NAME)
print("Query results:")
print(df)
