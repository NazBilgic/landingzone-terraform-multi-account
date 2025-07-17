provider "aws" {
  alias   = "management"
  region  = "eu-west-2"
  profile = "management-account"
}

provider "aws" {
  alias   = "log_archive"
  region  = "eu-west-2"
  profile = "log-archive-account"
}

provider "aws" {
  alias   = "security"
  region  = "eu-west-2"
  profile = "security-account"
}

provider "aws" {
  alias   = "workload"
  region  = "eu-west-2"
  profile = "workload-account"
}
