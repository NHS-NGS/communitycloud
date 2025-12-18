# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_execution" {
  name               = "${local.aws_account_level_id}-lambda-exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = {
    Name = "${local.aws_account_level_id}-lambda-exec"
  }
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Attach basic Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# # Policy for S3 read access
# resource "aws_iam_role_policy" "lambda_s3_access" {
#   name   = "${local.aws_account_level_id}-lambda-s3"
#   role   = aws_iam_role.lambda_execution.id
#   policy = data.aws_iam_policy_document.lambda_s3_access.json
# }

# data "aws_iam_policy_document" "lambda_s3_access" {
#   statement {
#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]

#     resources = [
#       module.raw_variants_s3_bucket.s3_bucket_arn,
#       "${module.raw_variants_s3_bucket.s3_bucket_arn}/*",
#     ]
#   }
# }

# Policy for Glue job execution
resource "aws_iam_role_policy" "lambda_glue_access" {
  name   = "${local.aws_account_level_id}-lambda-glue"
  role   = aws_iam_role.lambda_execution.id
  policy = data.aws_iam_policy_document.lambda_glue_access.json
}

data "aws_iam_policy_document" "lambda_glue_access" {
  statement {
    actions = [
      "glue:StartJobRun",
      "glue:GetJobRun",
      "glue:GetJob",
    ]

    resources = [
      aws_glue_job.vcf_etl.arn,
    ]
  }
}

# IAM Role for Glue job
resource "aws_iam_role" "glue_execution" {
  name               = "${local.aws_account_level_id}-glue-exec"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json

  tags = {
    Name = "${local.aws_account_level_id}-glue-exec"
  }
}

data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.glue_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# resource "aws_iam_role_policy" "glue_s3_access" {
#   name   = "${local.aws_account_level_id}-glue-s3"
#   role   = aws_iam_role.glue_execution.id
#   policy = data.aws_iam_policy_document.glue_s3_access.json
# }

# data "aws_iam_policy_document" "glue_s3_access" {
#   statement {
#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]

#     resources = [
#       module.raw_variants_s3_bucket.s3_bucket_arn,
#       "${module.raw_variants_s3_bucket.s3_bucket_arn}/*",
#     ]
#   }
# }

# Policy for S3 Tables access
resource "aws_iam_role_policy" "glue_s3tables_access" {
  name   = "${local.aws_account_level_id}-glue-s3tables"
  role   = aws_iam_role.glue_execution.id
  policy = data.aws_iam_policy_document.glue_s3tables_access.json
}

data "aws_iam_policy_document" "glue_s3tables_access" {
  statement {
    actions = [
      "s3tables:GetTable",
      "s3tables:GetTableBucket",
      "s3tables:GetNamespace",
      "s3tables:PutTableData",
      "s3tables:GetTableData",
    ]

    resources = [
      aws_s3tables_table_bucket.processed_variants.arn,
      "${aws_s3tables_table_bucket.processed_variants.arn}/*",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3tables_table_bucket.processed_variants.name}--table-*",
      "arn:aws:s3:::${aws_s3tables_table_bucket.processed_variants.name}--table-*/*",
    ]
  }
}
