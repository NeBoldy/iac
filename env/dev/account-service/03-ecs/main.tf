provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_accounts.devtest.id]
  default_tags {
    tags = local.tags
  }
}

provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_client_id
  client_secret = var.auth0_client_secret
}

locals {
  tags = {
    Region      = var.aws_region
    Environment = var.environment
    Stage       = var.stage
    Service     = "Account Service"
    Team        = "DevOps"
    CostCenter  = "Development"
  }
}

module "account_service_connection" {
  source = "../../../../modules/applications/auth0/account-service-connection"

  environment         = var.environment
  stage               = var.stage
  vpc_id              = data.aws_cloudformation_export.legitscript_vpc_id.value
  account_service_url = var.account_service_url
  auth0_repo_version  = var.auth0_repo_version
  auth_token          = var.auth_token
  password_policy     = var.auth0_password_policy
}

module "auth0_client" {
  source = "../../../../modules/applications/auth0/client"

  name        = "${var.stage}: Account Service"
  description = "Client to use for local environment for the Account Service."

  callbacks           = ["${var.account_service_url}/auth/auth0/callback"]
  allowed_origins     = [var.account_service_url]
  allowed_logout_urls = [var.account_service_url]
  web_origins         = [var.account_service_url]

  grant_types = [
    "authorization_code",
    "refresh_token",
  ]

  connections = {
    "${var.stage}_account_service" = module.account_service_connection.account_service_connection_id
  }
}

module "auth0_management_client" {
  source = "../../../../modules/applications/auth0/client"

  name        = "${var.stage}: Account Service: Management API Access"
  description = "Client to use for local environment to grant access to the Auth0 Management APIs."

  audience = "https://${var.auth0_domain}/api/v2/"
  app_type = "non_interactive"
  grant_types = [
    "client_credentials"
  ]

  scopes = [
    "read:users",
    "update:users",
    "read:users_app_metadata",
    "update:users_app_metadata",
    "create:users_app_metadata",
    "read:connections"
  ]

  connections = {
    "${var.stage}_account_service" = module.account_service_connection.account_service_connection_id
  }
}

data "aws_ssm_parameter" "auth0_custom_database_security_group_id" {
  name = "/devops/auth0/custom-database/security-group-id"
}