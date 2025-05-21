# General environment information
variable "stage" {
  type        = string
  description = "The stage to deploy to."
}

variable "environment" {
  type        = string
  description = "The environment to deploy to."
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy to."
}

variable "aws_accounts" {
  type = map(object({
    id        = string
    tier      = string
    role_name = string
  }))
  description = "Map of our AWS accounts, loaded automatically from defaults.yml."
}

variable "vpn_security_groups" {
  type        = map(string)
  description = "The VPN security group"
}

variable "tld" {
  type        = string
  description = "Top Level Domain for the environment"
}

# RDS
variable "instance_type" {
  type        = string
  description = "The RDS instance size."
}

variable "instance_count" {
  type        = number
  description = "The number of RDS instances."
}

variable "deletion_protection" {
  type        = bool
  description = "Protect cluster from deletion"
}

variable "source_db_cluster_identifier" {
  type        = string
  description = "The source DB cluster identifier for the global cluster (primiraly set when upgrading DB engine with blue/green deployment)"
  default     = null
}

variable "blue_green" {
  description = "Boolean flag if doing a Blue/Green Deployment."
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Configure the auto minor version upgrade behavior. This is applied to the cluster instances and indicates if the automatic minor version upgrade of the engine is allowed. Default value is false."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Whether to take a final snapshot on deletion"
}

variable "account_service_sql_dump" {
  type        = string
  description = "Location of account service sql dump"
}

variable "db_cluster_parameter_group_family" {
  type        = string
  description = "The aurora global version for DB Cluster Parameter group family."
  default     = "aurora-mysql8.0"
}

variable "engine_version" {
  type        = string
  description = "The aurora global version for DB Cluster Parameter group family."
  default     = "8.0.mysql_aurora.3.04.3"
}

variable "custom_tags" {
  description = "A map of custom tags to apply to the RDS Instance and the Security Group created for it. The key is the tag name and the value is the tag value."
  type        = map(string)
}

# RDS Replica
variable "replica_region" {
  # Note: Even if we don't create a replica, it is not possible to define a provider conditionally, or without a region.
  type        = string
  description = "Region to place RDS replica"
  default     = "us-east-1"
}

variable "create_cross_region_replica" {
  type        = bool
  description = "Whether to create an AWS replica"
}

# application.yml SECRETS
variable "enable_asset_pipeline" {
  type        = string
  description = "Config for using precompiled FE assets"
}

variable "enable_asset_pipeline_debug" {
  type        = string
  description = "Itemize rails FE assets to view in the browser"
}

variable "bypass_captcha" {
  type        = string
  description = "Option to bypass captcha for user password reset"
}

variable "certification_application_url" {
  type        = string
  description = "Workbench URL for Certifications"
}

variable "clients_application_url" {
  type        = string
  description = "LCP application url"
}

variable "cpv2_application_url" {
  type        = string
  description = "Client Portal V2 application url"
}

variable "jwt_expiry" {
  type        = string
  description = "Expiration in (s) for jwt token"
}

variable "mailcatcher_host" {
  type        = string
  description = "Mailcatcher url"
}

variable "parker_application_url" {
  type        = string
  description = "Parker application url"
}

variable "portal_v2_key_hash" {
  type        = string
  description = "String hash used for cpv2 integration testing"
}

variable "secret_token" {
  type        = string
  description = "Shared JWT token"
}

variable "rollbar_access_token" {
  type        = string
  description = "Access token for posting exceptions to rollbar"
}

variable "private_application_url" {
  type        = string
  description = "Private Site Application url"
}

variable "public_application_url" {
  type        = string
  description = "Public Site Application url"
}

variable "risk_application_url" {
  type        = string
  description = "Risk Application url"

}
variable "test_transactions_application_url" {
  type        = string
  description = "Test Transaction Application url"
}

variable "recaptcha_secret_key" {
  type        = string
  description = "Captcha provider client secret key"
}

variable "recaptcha_site_key" {
  type        = string
  description = "Captcha provider client site key"
}

variable "scraper_application_url" {
  type        = string
  description = "Scraper Application url"
}

# database.yml SECRETS
variable "local_infile" {
  type        = string
  description = "Var to deny/allow loading of local files"
}

variable "adapter" {
  type        = string
  description = "Option to use the dbms rails adapter"
}

variable "encoding" {
  type        = string
  description = "DB character encoding config"
}

variable "pool" {
  type        = string
  description = "DB connection pool size"
}

variable "reconnect" {
  type        = string
  description = "DB reconnect on broken connection"
}

variable "timeout" {
  type        = string
  description = "DB query timeout value"
}

# Auth0 Access
variable "auth0_domain" {
  type        = string
  description = "Domain of the Auth0 instances."
}

variable "auth0_client_id" {
  type        = string
  description = "Client Id of the Application authorized with the Auth0 Management API."
}

variable "auth0_client_secret" {
  type        = string
  description = "Client Secret of the Application authorized with the Auth0 Management API."
}

# Auth0 Module Configuration
variable "auth0_enabled" {
  type        = bool
  description = "Set to true to enable Auth0 login to Account Service."
  default     = false
}

variable "auth0_repo_version" {
  type        = string
  description = "Git Ref to the Auth0 repository to use when cloning a specific version of the scripts."
}

variable "unassigned_application_url" {
  type        = string
  description = "The application url to use when for unassigned applications (See LS-23229 for some context)"
}

variable "auth0_password_policy" {
  type        = string
  description = "Password strength policy"

  validation {
    condition     = contains(["none", "low", "fair", "good", "excellent"], var.auth0_password_policy)
    error_message = "Allowed values for auth0_password_policy are none, low, fair, good, excellent."
  }
}
