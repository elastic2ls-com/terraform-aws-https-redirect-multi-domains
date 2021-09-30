terraform {
  backend "s3" {
  }

  required_providers {
    archive = {
      source = "hashicorp/archive"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}


locals {
  source_domains = yamldecode(file("${path.module}/setting.yaml")).source_domains
}
