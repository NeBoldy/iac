locals {
  tags = {
    Region      = var.aws_region
    Environment = var.environment
    Stage       = var.stage
    Service     = "Account Service"
    Team        = "DevOps"
    CostCenter  = "Development"
  }
  service_name        = "accounts"
  services_account_id = var.aws_accounts.services.id
  domain_name         = "${local.service_name}.${var.stage}.${data.aws_route53_zone.legitscript_zone.name}"

  is_private_route53_zone = var.environment != "development"
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_accounts.devtest.id]

  default_tags {
    tags = local.tags
  }
}

module "ecs" {
  source      = "../../../../modules/applications/account-service/ecs"
  name        = local.service_name
  stage       = var.stage
  environment = var.environment

  image_uri = "${local.services_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/account-service"
  image_tag = var.image_tag

  ecs_subnet_ids = [
    data.aws_cloudformation_export.legitscript_private_subnet_1.value,
    data.aws_cloudformation_export.legitscript_private_subnet_2.value,
    data.aws_cloudformation_export.legitscript_private_subnet_3.value,
  ]
  # Account Service is an internal service, but requires ingress from external Auth0 ips
  load_balancer_subnet_ids = [
    data.aws_cloudformation_export.legitscript_public_subnet_1.value,
    data.aws_cloudformation_export.legitscript_public_subnet_2.value,
    data.aws_cloudformation_export.legitscript_public_subnet_3.value,
  ]
  vpc_id                         = data.aws_cloudformation_export.legitscript_vpc_id.value
  account_service_security_group = data.aws_cloudformation_export.account_service_sg.value
  acm_cert_domain_name           = local.domain_name

  kms_key_arn                   = data.aws_kms_alias.applications.target_key_arn
  additional_security_group_ids = [data.aws_ssm_parameter.auth0_custom_database_security_group_id.value]

  account_service_auth0_api_token = data.aws_ssm_parameter.account_service_auth0_api_token.value

  vpn_ips                = var.vpn_ips
  public_ips_for_ingress = var.public_ips_for_ingress

  # TEMP for auth0 mfa testing
  min_num_tasks = 1
  max_num_tasks = 1

  # vCPU and Memory for the ECS Task
  cpu_units  = var.cpu_units
  memory_mbs = var.memory_mbs
}

resource "aws_route53_record" "load_balancer_cname" {
  zone_id = data.aws_route53_zone.legitscript_zone.zone_id

  name = local.domain_name
  type = "A"

  alias {
    name                   = module.ecs.load_balancer_dns_name
    zone_id                = module.ecs.load_balancer_hosted_zone_id
    evaluate_target_health = true
  }
}
