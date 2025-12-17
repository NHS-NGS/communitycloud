# S3 Bucket for raw VCF files
module "raw_variants_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.2"

  bucket                                = "${var.project}-raw-variants"
  attach_deny_insecure_transport_policy = true
  attach_public_policy                  = false

  versioning = {
    status = true
  }

  tags = {
    Name = "${var.project}-raw-variants"
  }
}

