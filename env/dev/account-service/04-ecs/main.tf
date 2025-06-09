# ------------------------------------------------------------------------------
# Provider Configuration
# ------------------------------------------------------------------------------

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_accounts.devtest.id]
  default_tags {
    tags = local.tags
  }
}

# ------------------------------------------------------------------------------
# Locals Configuration
# ------------------------------------------------------------------------------

locals {
  tags = {
    Region      = var.aws_region
    Environment = var.environment
    Stage       = var.stage
    Domain      = "Audit API"
    Team        = "Voltron"
    CostCenter  = var.cost_center
  }
}

# ------------------------------------------------------------------------------
# SQS Queues and DLQs Defintion
# ------------------------------------------------------------------------------

module "audits_sqs" {
  source = "../../../../../modules/applications/audit-api/messaging"

  stage = var.stage
}

data "aws_ssm_parameter" "audits_sqs_queue_url" {
  name = "/devops/audit-api/${var.environment}/${var.aws_region}/sqs/queue_url"
} 