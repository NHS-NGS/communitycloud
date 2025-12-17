terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.6"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = local.default_tags
  }
}
