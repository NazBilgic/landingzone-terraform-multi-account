
Project Overview : 

This project provisions a secure and scalable AWS Landing Zone using Terraform, following AWS best practices.

It includes:

AWS GuardDuty configured centrally in the management account, with automatic member account enrollment via AWS Organizations.

A Service Control Policy (SCP) that denies actions outside the approved region (eu-west-2). The SCP was temporarily updated during GuardDuty troubleshooting to allow necessary access.


## Folder Structure

```
.
├── live/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── prod/ (optional)
│       └── ...
├── modules/
│   ├── cloudtrail/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── guardduty/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── scp/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── policies/
│   │       └── deny-unapproved-regions.json
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── infra/
│   └── backend/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars (optional)
├── providers.tf
└── .gitignore
```

## How to Deploy

### 1. Bootstrap the Backend
This creates the S3 bucket and DynamoDB table for remote state.

```bash
cd infra/backend
terraform init
terraform apply
```

### 2. Deploy the Dev Environment

```bash
cd live/dev
terraform init
terraform apply
```

## Module Summary

### cloudtrail
- Creates an S3 bucket for CloudTrail logs
- Applies bucket policy for CloudTrail service
- Creates a multi-region CloudTrail

### guardduty
- Enables GuardDuty in the management account
- Invites and enables it on member accounts

### scp
- Creates Service Control Policies (SCPs)
- Attaches SCPs to target accounts in AWS Organizations

### vpc
- Provisions a basic VPC
- Includes public and private subnets
- Adds internet gateway

## Required AWS Profiles

Make sure these named profiles are set in your `~/.aws/credentials` or AWS Vault:
- `management-account`
- `log-archive`
- `workload`

## Variables Example (`terraform.tfvars` in live/dev)

```hcl
target_account_ids = [
  "111111111111", # management
  "222222222222", # log archive
  "333333333333"  # workload
]

enable_guardduty = true
master_account_id = "111111111111"
member_account_ids = [
  "222222222222",
  "333333333333"
]

vpc_cidr = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
azs = ["eu-west-2a", "eu-west-2b"]
project_name = "landingzone"
common_tags = {
  Owner      = "Naz"
  ManagedBy  = "Terraform"
  Environment = "dev"
}

bucket_name = "naz-landingzone-cloudtrail"
trail_name  = "naz-landingzone-trail"
```

## .gitignore Example

```
# Terraform
*.tfstate
*.tfstate.backup
.terraform/
.terraform.lock.hcl
crash.log
override.tf
override.tf.json
terraform.tfvars
terraform.tfvars.json

# macOS
.DS_Store

# IDEs
.vscode/
.idea/
```

## Tips

- Keep `main.tf` in `live/dev` clean - only call modules and set provider/backend.
- Use `terraform.tfvars` for environment-specific values.
- Modules must be tested through an environment folder like `live/dev`, not directly.
- Outputs must match what's declared in modules.

## Next Steps

- Add `live/prod/` if needed
- Configure more fine-grained IAM roles
- Add budget alerts or config rules
- Push the repo to GitHub for sharing or CI/CD

---

This setup gives you a secure, multi-account foundation that’s modular, scalable, and production-ready.

