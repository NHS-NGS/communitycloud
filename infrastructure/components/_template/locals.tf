locals {
  aws_account_level_id = format(
    "%s-%s-%s",
    var.project,
    var.environment,
    var.component,
  )

  aws_global_level_id = format(
    "%s-%s-%s-%s",
    var.project,
    data.aws_caller_identity.current.account_id,
    var.environment,
    var.component,
  )

  default_tags = {
    Project            = var.project
    Environment        = var.environment
    Component          = var.component
    Department         = "digital-data-and-technology"
    "Service Line"     = "gms"
    "Business Service" = "community-cloud"
  }

  # NOTE: Ensures Sandbox Environment compatibility
  aws_account_level_iam_id = var.environment != "sbx" ? local.aws_account_level_id : "${var.sbx_account_level_iam_id}-${var.component}"
  iam_permissions_boundary = var.environment != "sbx" ? null : var.sbx_iam_permissions_boundary_policy_arn
}
