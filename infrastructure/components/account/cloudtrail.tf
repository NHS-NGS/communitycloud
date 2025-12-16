# resource "aws_cloudtrail" "s3_operations" {
#   depends_on = [aws_s3_bucket_policy.s3_operations]
#   count      = var.enable_cloudtrail_cohort_logging ? 1 : 0

#   name                          = "s3_operations"
#   s3_bucket_name                = aws_s3_bucket.s3_operations.id
#   include_global_service_events = false
#   event_selector {
#     read_write_type           = "All"
#     include_management_events = false

#     data_resource {
#       type = "AWS::S3::Object"
#       values = ["arn:aws:s3:::somerset-647582858282-dev-cohort/",
#       "arn:aws:s3:::somerset-647582858282-dev-cohort-upload/"]
#     }
#   }
# }

# resource "aws_s3_bucket" "s3_operations" {
#   bucket        = "somerset-647582858282-dev-trail"
#   force_destroy = true
# }

# data "aws_iam_policy_document" "s3_operations" {
#   statement {
#     sid    = "AWSCloudTrailAclCheck"
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["cloudtrail.amazonaws.com"]
#     }

#     actions   = ["s3:GetBucketAcl"]
#     resources = [aws_s3_bucket.s3_operations.arn]
#     condition {
#       test     = "StringEquals"
#       variable = "aws:SourceArn"
#       values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:trail/s3_operations"]
#     }
#   }

#   statement {
#     sid    = "AWSCloudTrailWrite"
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["cloudtrail.amazonaws.com"]
#     }

#     actions   = ["s3:PutObject"]
#     resources = ["${aws_s3_bucket.s3_operations.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

#     condition {
#       test     = "StringEquals"
#       variable = "s3:x-amz-acl"
#       values   = ["bucket-owner-full-control"]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "aws:SourceArn"
#       values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:trail/s3_operations"]
#     }
#   }
# }

# resource "aws_s3_bucket_policy" "s3_operations" {
#   bucket = aws_s3_bucket.s3_operations.id
#   policy = data.aws_iam_policy_document.s3_operations.json
# }
