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

provider "aws" {
  region              = var.replica_region
  alias               = "replica"
  allowed_account_ids = [var.aws_accounts.devtest.id]
  default_tags {
    tags = local.tags
  }
}

# ------------------------------------------------------------------------------
# Locals Configuration
# ------------------------------------------------------------------------------

locals {
  db_name = var.db_name != null ? var.db_name : "audit_${var.stage}"

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
# RDS Cluster Definition
# ------------------------------------------------------------------------------

module "audits_rds" {
  source = "../../../../../modules/applications/audit-api/rds"

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
  aws_region          = var.aws_region
  vpn_security_groups = var.vpn_security_groups

  stage                       = var.stage
  db_name                     = local.db_name
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  backup_window               = var.backup_window
  maintenance_window          = var.maintenance_window
  instance_type               = var.instance_type
  engine_version              = var.engine_version
  instance_count              = var.instance_count
  skip_final_snapshot         = var.skip_final_snapshot
  snapshot_src_cluster        = var.snapshot_src_cluster
  deletion_protection         = var.deletion_protection
  custom_tags                 = var.custom_tags


  # R eplica
  create_cross_region_replica = var.create_cross_region_replica
  replica_region              = var.replica_region

  # Autoscaling Configuration
        min_number_replicas = var.min_number_replicas
  max_number_replicas = var.max_number_replicas
        cpu_target_value    = var.cpu_target_value
  scale_in_cooldown   = var.scale_in_cooldown
  scale_out_cooldown  = var.scale_out_cooldown
}

     data "aws_ssm_parameter" "audit_api_db_password" {
  name = "/devops/audit-api/${var.stage}/db_password"
}

data "aws_ssm_parameter" "audit_api_db_username" {
  name = "/devops/audit-api/${var.stage}/db_username"
}