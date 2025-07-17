provider "aws" {
  region  = var.region
  profile = "management-account"
}

resource "aws_s3_bucket" "tf_state" {
  bucket         = var.bucket_name
  force_destroy  = true

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "landing-zone"
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "landing-zone"
  }
}
