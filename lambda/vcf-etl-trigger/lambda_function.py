import json
import boto3
import os

glue_client = boto3.client('glue')

VCF_INPUT_FILE = os.environ.get('VCF_INPUT_FILE')
TABLE_BUCKET_ARN = os.environ.get('TABLE_BUCKET_ARN')
GLUE_JOB_NAME = os.environ.get('GLUE_JOB_NAME')


def lambda_handler(event, context):
    """
    Lambda handler that starts Glue job to process VCF file.
    Uses VCF_INPUT_FILE environment variable for input file path.
    """
    try:
        print(f"Processing: {VCF_INPUT_FILE}")
        
        response = glue_client.start_job_run(
            JobName=GLUE_JOB_NAME,
            Arguments={
                "--VCF_INPUT_FILE": VCF_INPUT_FILE,
                "--TABLE_BUCKET_ARN": TABLE_BUCKET_ARN
            }
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Glue job started',
                'input_file': VCF_INPUT_FILE,
                'job_run_id': response['JobRunId']
            })
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
