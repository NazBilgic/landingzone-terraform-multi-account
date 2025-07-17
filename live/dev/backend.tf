terraform {
  backend "s3" {
    bucket         = "naz-landingzone-tfstate"
    key            = "global/landingzone.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
