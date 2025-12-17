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
  default     = "network"
}

variable "vpc_id" {
  description = "ID of the environment VPC"
  type        = string
}

variable "vpc_flow_logs_retention_days" {
  description = "Retention of the VPC flow logs cloudwatch log group. Defaults to 7."
  type        = number
  default     = 7
}

variable "vpc_flow_logs_traffic_type" {
  description = "Traffic type to be captured in VPC Flow logs. Defaults to REJECT."
  type        = string
  default     = "REJECT"
}
