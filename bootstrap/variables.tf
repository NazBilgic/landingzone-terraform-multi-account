variable "bucket_name" {
  type        = string
  description = "S3 bucket name to store Terraform state"
}

variable "dynamodb_table_name" {
  type        = string
  description = "DynamoDB table name for state locking"
}

variable "region" {
  type        = string
  default     = "eu-west-2"
}
