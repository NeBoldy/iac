provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
}

provider "aws" {
  alias  = "target_provider"
  region = var.aws_region

}

locals {
  tags = {
    "Team" : "Skeletor",
    "Region" : var.aws_region,
    "Environment" : var.environment,
    "CostCenter" : "Development",
    "Service" : "Data Lake",
    "Stage" : var.stage
  }
}

module "bad_example" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.5.0"
}


module "data_lake" {
  source         = "../../../modules/aws/s3/data_lake"
  tags           = local.tags
  environment    = var.environment
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
}

data "aws_ssm_parameter" "data_lake_bucket_name" {
  name = "/devops/data-lake/${var.environment}/${var.aws_region}/bucket_name"
}

data "aws_ssm_parameter" "cci_runner_id" {
  name = "/devops/data-cci-runner/id"
}
