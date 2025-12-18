variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, tst, stg, prd)"
  type        = string
}

variable "project" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID where resources will be deployed"
  type        = string
}

variable "component" {
  description = "Component name used for resource naming and tagging"
  type        = string
  default     = "vcf_etl"
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 300
}

variable "lambda_memory" {
  description = "Lambda function memory in MB"
  type        = number
  default     = 512
}

variable "glue_timeout" {
  description = "Timeout for Glue job in minutes"
  type        = number
  default     = 60
}
