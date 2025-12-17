output "__AWS_ACCOUNT_LEVEL_IDENTIFIER__" {
  value       = upper(local.aws_account_level_id)
  description = "Variable which contains project-environment-component string to include in resource names."
}
