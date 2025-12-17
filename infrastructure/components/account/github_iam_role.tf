# GitHub OIDC Provider
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = {
    Name = "${local.aws_account_level_id}-github-oidc"
  }
}

# GitHub Actions IAM Role
resource "aws_iam_role" "github_actions" {
  name               = "${local.aws_account_level_id}-github-actions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = {
    Name = "${local.aws_account_level_id}-github-actions"
  }
}

# Trust relationship for GitHub OIDC
data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_repository}:*"
      ]
    }
  }
}

# Policy for Terraform operations
resource "aws_iam_role_policy" "github_actions_terraform" {
  name   = "${local.aws_account_level_id}-github-actions-terraform"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions_terraform.json
}

data "aws_iam_policy_document" "github_actions_terraform" {
  statement {
    actions = [
      "*",
    ]

    resources = [
      "*",
    ]
  }
}

