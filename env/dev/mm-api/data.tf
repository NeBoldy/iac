data "local" "this" {
  service_name = "mm-api"
  tags = {
    Region      = var.aws_region
    Environment = var.environment
    Stage       = var.stage
    Service     = "MM API"
    Team        = "DevOps"
    CostCenter  = "Development"
  }
}