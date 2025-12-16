resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_logs.arn
}

resource "aws_iam_role" "api_gateway_logs" {
  name               = "${local.aws_account_level_iam_id}-api-gateway-logs"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_logs_trust.json

  tags = {
    Name = "${local.aws_account_level_id}-api-gateway-logs"
  }
}

data "aws_iam_policy_document" "api_gateway_logs_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "api_gateway_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "api_gateway_logs" {
  name   = "${local.aws_account_level_iam_id}-api-gateway-logs"
  policy = data.aws_iam_policy_document.api_gateway_logs.json

  tags = {
    Name = "${local.aws_account_level_id}-api-gateway-logs"
  }
}

resource "aws_iam_role_policy_attachment" "api_gateway_logs" {
  role       = aws_iam_role.api_gateway_logs.name
  policy_arn = aws_iam_policy.api_gateway_logs.arn
}
