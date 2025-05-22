# Networking
data "aws_cloudformation_export" "legitscript_vpc_id" {
  name = "PrimaryVPC"
}

data "aws_cloudformation_export" "legitscript_private_subnet_1" {
  name = "PrivateSubnet1"
}

data "aws_cloudformation_export" "legitscript_private_subnet_2" {
  name = "PrivateSubnet2"
}

data "aws_cloudformation_export" "legitscript_private_subnet_3" {
  name = "PrivateSubnet3"
}

data "aws_cloudformation_export" "legitscript_public_subnet_1" {
  name = "PublicSubnet1"
}

data "aws_cloudformation_export" "legitscript_public_subnet_2" {
  name = "PublicSubnet2"
}

data "aws_cloudformation_export" "legitscript_public_subnet_3" {
  name = "PublicSubnet3"
}

# Security
data "aws_cloudformation_export" "account_service_sg" {
  name = "SGAccountsService"
}

data "aws_kms_alias" "applications" {
  name = "alias/applications"
}

data "aws_route53_zone" "legitscript_zone" {
  name         = "${var.tld}."
  vpc_id       = local.is_private_route53_zone ? data.aws_cloudformation_export.legitscript_vpc_id.value : null
  private_zone = local.is_private_route53_zone
}

data "aws_ssm_parameter" "account_service_auth0_api_token" {
  name = "/account-service/${var.stage}/auth0/api-token"
}

data "aws_ssm_parameter" "auth0_custom_database_security_group_id" {
  name = "/auth0/${var.stage}/security_group/auth0_custom_database/id"
}
