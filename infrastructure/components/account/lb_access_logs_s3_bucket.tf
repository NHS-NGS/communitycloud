# module "lb_access_logs_s3_bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "~> 5.2"

#   bucket = "${local.aws_global_level_id}-lb-access-logs"

#   attach_elb_log_delivery_policy           = true # Required for ALB logs
#   attach_lb_log_delivery_policy            = true # Required for ALB/NLB logs
#   attach_deny_incorrect_encryption_headers = true
#   attach_deny_insecure_transport_policy    = true
#   attach_public_policy                     = false # Not allowed by NHSBSA SCP policy. Public access deny policy enforced on the account level.

#   versioning = {
#     status = true
#   }

#   lifecycle_rule = [
#     {
#       id     = "lb_access_logs_lifecycle"
#       status = "Enabled"

#       abort_incomplete_multipart_upload_days = 7

#       expiration = {
#         days = var.lb_access_logs_retention_days
#       }

#       transition = [
#         {
#           days          = var.lb_access_logs_ia_transition_days
#           storage_class = "STANDARD_IA"
#         }
#       ]

#       noncurrent_version_expiration = {
#         noncurrent_days = var.lb_access_logs_retention_days
#       }
#     },
#   ]

#   logging = {
#     target_bucket = module.s3_access_logs_s3_bucket.s3_bucket_id
#     target_prefix = "${module.lb_access_logs_s3_bucket.s3_bucket_id}/"
#     target_object_key_format = {
#       partitioned_prefix = {
#         partition_date_source = "DeliveryTime"
#       }
#     }
#   }

#   tags = {
#     Name = "${local.aws_global_level_id}-lb-access-logs"
#   }
# }
