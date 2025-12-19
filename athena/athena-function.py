import boto3
import time
import pandas as pd

REGION = 'eu-west-2'  # AWS region
QUERY_OUTPUT_BUCKET = 's3://your-athena-query-results/'  # must exist
DATABASE_NAME = 'vcf_data'
TABLE_NAME = 'variants'
TABLE_LOCATION = 's3://gms-processed-variants/variants'

athena_client = boto3.client('athena', region_name=REGION)

def run_athena_query(query, database=None):
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
    
   
    results = athena_client.get_query_results(QueryExecutionId=query_execution_id)
    return results


create_db_query = f"""
CREATE DATABASE IF NOT EXISTS {DATABASE_NAME}
"""
run_athena_query(create_db_query)
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
run_athena_query(create_table_query, database=DATABASE_NAME)
print(f"Table '{TABLE_NAME}' created or already exists in database '{DATABASE_NAME}'.")


select_query = f"""
SELECT variant_id, chrom, pos, ref, alt
FROM {TABLE_NAME}
WHERE chrom = '1'
LIMIT 10
"""
results = run_athena_query(select_query, database=DATABASE_NAME)


columns = [col['VarCharValue'] for col in results['ResultSet']['Rows'][0]['Data']]

# Extract rows
rows = []
for row in results['ResultSet']['Rows'][1:]:
    rows.append([col.get('VarCharValue', None) for col in row['Data']])

# Create DataFrame
df = pd.DataFrame(rows, columns=columns)
print("Query results:")
print(df)
