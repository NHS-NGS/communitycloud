variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., sbx, dev, tst, stg, prd)"
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
  default     = "_template"
}

variable "sbx_iam_permissions_boundary_policy_arn" {
  description = "ARN of the IAM permissions boundary policy for Sandbox environment"
  type        = string
}

variable "sbx_account_level_iam_id" {
  description = "Account level IAM identifier for Sandbox environment"
  type        = string
}
