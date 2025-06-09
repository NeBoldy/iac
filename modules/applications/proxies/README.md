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
| <a name="module_ec2_metrics_and_logging"></a> [ec2\_metrics\_and\_logging](#module\_ec2\_metrics\_and\_logging) | ../../../../modules/aws/iam/role | n/a |
| <a name="module_ec2_self_discovery"></a> [ec2\_self\_discovery](#module\_ec2\_self\_discovery) | ../../../../modules/aws/iam/role | n/a |
| <a name="module_github_repo_access"></a> [github\_repo\_access](#module\_github\_repo\_access) | ../../../../modules/aws/iam/role | n/a |
| <a name="module_slackbot_announce_bot_invoke"></a> [slackbot\_announce\_bot\_invoke](#module\_slackbot\_announce\_bot\_invoke) | ../../../../modules/aws/iam/role | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_resource_policy.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_iam_policy_document.assume_role_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account to deploy to. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy to. | `string` | n/a | yes |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | The cost center for the deployment. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy to. | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | The stage to deploy to. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->