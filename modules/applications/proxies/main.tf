locals {
  tags = {
    Region      = var.aws_region
    Environment = var.environment
    Stage       = var.stage
    Service     = "AccessControls"
    Team        = "DevOps"
    CostCenter  = "Development"
  }
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
}

data "aws_iam_policy_document" "assume_role_ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Generic EC2 Metric and Logging Role
module "ec2_metrics_and_logging" {
  source = "../../../../modules/aws/iam/role"

  name                    = "ec2-metrics-and-logging"
  policy_json             = templatefile("../../../../modules/aws/iam-boilerplate/policies/ec2/metrics-and-logs.tmpl", {})
  assume_role_policy_json = data.aws_iam_policy_document.assume_role_ec2.json
  create_instance_profile = true
  ssm_parameter_namespace = "/devops/iam/ec2_metrics_and_logging"
  tags                    = local.tags
}

# EC2 role for self discovery
module "ec2_self_discovery" {
  source = "../../../../modules/aws/iam/role"

  name                    = "ec2-self-discovery"
  policy_json             = templatefile("../../../../modules/aws/iam-boilerplate/policies/ec2/self-discovery.tmpl", {})
  assume_role_policy_json = data.aws_iam_policy_document.assume_role_ec2.json
  create_instance_profile = true
  ssm_parameter_namespace = "/devops/iam/ec2_self_discovery"
  tags                    = local.tags
}

# EC2 role for accessing our GitHub repos
module "github_repo_access" {
  source = "../../../../modules/aws/iam/role"

  name                    = "github-repo-access"
  policy_json             = templatefile("../../../../modules/aws/iam-boilerplate/policies/ec2/github-read-access.tmpl", {
    kms_key_arn = data.aws_kms_key.ssm.arn
  })
  assume_role_policy_json = data.aws_iam_policy_document.assume_role_ec2.json
  create_instance_profile = true
  ssm_parameter_namespace = "/devops/iam/github_repo_access"
  tags                    = local.tags
}

# Instance profile to invoke slackbot lambda
module "slackbot_announce_bot_invoke" {
  source = "../../../../modules/aws/iam/role"

  name                    = "slackbot_announce_bot_invoke"
  policy_json             = templatefile("../../../../modules/aws/iam-boilerplate/policies/ec2/slackbot_announce_bot_access.tmpl", {})
  assume_role_policy_json = data.aws_iam_policy_document.assume_role_ec2.json
  create_instance_profile = true
  tags                    = local.tags
}


data "aws_iam_policy_document" "cloudwatch_log_policy" {
  statement {
    sid = "AllowCloudWatchToStoreLogEvents"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/events/*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
    }
  }
}

# Resource based policy for Cloudwatch to store events 
resource "aws_cloudwatch_log_resource_policy" "cloudwatch" {
           policy_document = data.aws_iam_policy_document.cloudwatch_log_policy.json
            policy_name     = "TrustEventsToStoreLogEvents"
}