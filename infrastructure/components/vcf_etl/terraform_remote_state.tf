# Remote state from account component
data "terraform_remote_state" "account" {
  backend = "s3"

  config = {
    bucket = "${var.project}-cloudcommunity-terraform"
    key    = "${var.project}/${var.aws_account_id}/${var.region}/${var.environment}/account.tfstate"
    region = var.region
  }
}
