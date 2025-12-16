resource "aws_accessanalyzer_analyzer" "external_access" {
  analyzer_name = "${local.aws_account_level_id}-external-access"
  tags = {
    Name = "${local.aws_account_level_id}-external-access"
  }
}
