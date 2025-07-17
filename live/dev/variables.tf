variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "project_name" {
  default = "landing-zone"
}

variable "common_tags" {
  default = {
    Environment = "workload"
    Owner       = "Naz"
    Project     = "AWS Landing Zone"
  }
}
variable "target_account_ids" {
  type        = list(string)
  description = "List of AWS Account IDs for SCP policy target"
}
