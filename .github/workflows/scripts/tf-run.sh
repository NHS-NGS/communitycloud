#!/usr/bin/env bash
set -e

COMPONENT="${TF_COMPONENT:-$COMPONENT}"
ENVIRONMENT="${TF_ENVIRONMENT:-$ENVIRONMENT}"

echo "🚀 Running Terraform ${TF_ACTION} for ${COMPONENT} in ${ENVIRONMENT} ..."
bin/terraform.sh -t -r ${AWS_REGION} -p ${PROJECT} -e ${ENVIRONMENT} -c ${COMPONENT} -a ${TF_ACTION}

echo "✅ Terraform ${TF_ACTION} for ${ENVIRONMENT}/${COMPONENT} completed."
