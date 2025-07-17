terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  profile = "management-account"
  region  = "eu-west-2"
}

module "scp" {
  source             = "../../modules/scp"
  policy_name        = "DenyUnapprovedRegions"
  description        = "Denies access to all regions except eu-west-2"
  policy_file        = "policies/deny-unapproved-regions.json"
  target_account_ids = [
    "430118817587", # management
    "795289711031", # log-archive
    "194264601131"  # workload
  ]
}

module "guardduty" {
  source             = "../../modules/guardduty"
  enable_guardduty   = true
  member_account_ids = [
    "795289711031", # log-archive
    "194264601131"  # workload
  ]
  master_account_id  = "430118817587"
}

module "cloudtrail" {
  source       = "../../modules/cloudtrail"
  bucket_name  = "naz-landingzone-cloudtrail"
  trail_name   = "naz-landingzone-trail"
  project_name = "landingzone"

  common_tags = {
    Owner       = "Naz"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  project_name    = var.project_name
  common_tags     = var.common_tags
}
