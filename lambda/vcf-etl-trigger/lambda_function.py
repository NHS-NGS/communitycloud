import json
import boto3
import os

glue_client = boto3.client('glue')

VCF_INPUT_PATH = os.environ.get('VCF_INPUT_PATH')
TABLE_BUCKET_ARN = os.environ.get('TABLE_BUCKET_ARN')
GLUE_JOB_NAME = os.environ.get('GLUE_JOB_NAME')


def lambda_handler(event, context):
    """
    Lambda handler triggered by S3 upload of VCF files.
    Starts Glue job to process the file.
    """
    try:
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']
        
        print(f"Processing: s3://{bucket}/{key}")
        
        response = glue_client.start_job_run(
            JobName=GLUE_JOB_NAME,
            Arguments={
                "--VCF_INPUT_PATH": VCF_INPUT_PATH,
                "--TABLE_BUCKET_ARN": TABLE_BUCKET_ARN
            }
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Glue job started',
                'job_run_id': response['JobRunId']
            })
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
