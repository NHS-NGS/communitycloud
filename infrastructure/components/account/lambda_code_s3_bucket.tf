module "lambda_code_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.2"

  bucket                                   = "${local.aws_global_level_id}-lambda-code"
  attach_deny_incorrect_encryption_headers = true
  attach_deny_insecure_transport_policy    = true
  attach_public_policy                     = false # Public access deny policy enforced on the account level.

  tags = {
    Name = "${local.aws_global_level_id}-lambda-code"
  }
}
