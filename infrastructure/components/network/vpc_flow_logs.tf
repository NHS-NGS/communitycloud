resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "${local.aws_account_level_id}-vpc-flow-logs"
  retention_in_days = var.vpc_flow_logs_retention_days
  tags = {
    Name = "${local.aws_account_level_id}-vpc-flow-logs"
  }
}

resource "aws_flow_log" "vpc" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = var.vpc_flow_logs_traffic_type
  vpc_id          = data.aws_vpc.vpc.id
  log_format      = chomp(trimspace(file("${path.module}/files/vpc-flow-log-format")))
}

data "aws_iam_policy_document" "vpc_flow_logs_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_flow_logs" {
  name               = "${local.aws_account_level_iam_id}-vpc-flow-logs"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_assume_role.json
  tags = {
    Name = "${local.aws_account_level_id}-vpc-flow-logs"
  }
}

data "aws_iam_policy_document" "vpc_flow_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs" {
  name   = "${local.aws_account_level_id}-vpc-flow-logs"
  role   = aws_iam_role.vpc_flow_logs.id
  policy = data.aws_iam_policy_document.vpc_flow_logs.json
}
