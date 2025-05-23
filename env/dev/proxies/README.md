# Blackridge Monitoring

This module sets up blackridge monitoring dashboard and alarms.

## Pre-requisites

In order to use this service, there are some resources that should first exist.

- SSM Parameter `/infrastructure/monitoring/skeletor/topic/arn` defined
  in `terraform/modules/aws/infrastructure_monitoring`. If the parameter does not exist, first deploy the
  module `terraform/modules/aws/infrastructure_monitoring`.

## Setup

1. Make sure you have at least Terraform `1.1.2` installed
2. SSO as Development Admin account
3. `ENVIRONMENT=development STAGE=development terragrunt apply`test

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_blackridge_monitoring"></a> [blackridge\_monitoring](#module\_blackridge\_monitoring) | ../../../../modules/aws/blackridge/monitoring | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.skeletor_topic_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account to deploy to. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy to. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment being deployed to | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | The stage being deployed to. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->