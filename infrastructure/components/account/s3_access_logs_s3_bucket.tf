# module "s3_access_logs_s3_bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "~> 5.2"

#   bucket = "${local.aws_global_level_id}-s3-access-logs"

#   attach_deny_incorrect_encryption_headers = true
#   attach_deny_insecure_transport_policy    = true
#   attach_public_policy                     = false # Public access deny policy enforced on the account level.

#   versioning = {
#     status = true
#   }

#   lifecycle_rule = [
#     {
#       id     = "s3_access_logs_lifecycle"
#       status = "Enabled"

#       abort_incomplete_multipart_upload_days = 7

#       expiration = {
#         days = var.s3_access_logs_retention_days
#       }

#       transition = [
#         {
#           days          = var.s3_access_logs_ia_transition_days
#           storage_class = "STANDARD_IA"
#         }
#       ]

#       noncurrent_version_expiration = {
#         noncurrent_days = var.s3_access_logs_retention_days
#       }
#     },
#   ]

#   tags = {
#     Name = "${local.aws_global_level_id}-s3-access-logs"
#   }

# }
