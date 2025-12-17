# resource "aws_ecr_repository" "ecr" {
#   name                 = "${local.aws_global_level_id}-ecr"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
#   tags = {
#     Name = "${local.aws_global_level_id}-ecr"
#   }
#   encryption_configuration {
#     encryption_type = "KMS"
#   }
# }
