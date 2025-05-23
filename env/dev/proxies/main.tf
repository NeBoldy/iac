provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]

  default_tags {
    tags = local.tags
  }
}

locals {
  subscription_email = "dev_skeletor@legitscript.com"
  tags = {
    "Team" : "Skeletor",
    "Region" : "us-west-2",
    "Environment" : var.environment,
    "CostCenter" : "Development",
    "Service" : "Blackridge",
    "Stage" : var.stage
  }
}

module "blackridge_monitoring" {
  source             = "../../../../modules/aws/blackridge/monitoring"
  stage              = var.stage
  aws_region         = var.aws_region
  aws_account_id     = var.aws_account_id
  topic_arn          = data.aws_ssm_parameter.skeletor_topic_arn.value
  subscription_email = local.subscription_email
}