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
  default     = "account"
}

variable "lb_access_logs_retention_days" {
  description = "Number of days to retain load balancer access logs"
  type        = number
  default     = 60
}

variable "s3_access_logs_retention_days" {
  description = "Number of days to retain S3 access logs"
  type        = number
  default     = 60
}

variable "lb_access_logs_ia_transition_days" {
  description = "Number of days after which load balancer access logs transition to IA storage class"
  type        = number
  default     = 30
}

variable "s3_access_logs_ia_transition_days" {
  description = "Number of days after which S3 access logs transition to IA storage class"
  type        = number
  default     = 30
}

variable "enable_cloudtrail_cohort_logging" {
  description = "Flag to enable auditing of cohort processing S3 bucket actions. Enabled by default."
  type        = bool
  default     = true
}
