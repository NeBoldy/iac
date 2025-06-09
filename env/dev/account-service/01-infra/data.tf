data "local" "this" {
  service_name = "accounts"
  tags = {
    Region      = var.aws_region
    Environment = var.environment
    Stage       = var.stage
    Service     = "Account Service"
    Team        = "DevOps"
    CostCenter  = "Development"
  }
}