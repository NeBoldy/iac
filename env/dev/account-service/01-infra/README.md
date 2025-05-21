# Account Service Infrastructure

## Overview:

- IAM user with key/secret for posting to SNS
- MySQL RDS Global Aurora
  - creation of app-specific user and database
  - import of DB data
  - optional replica (fair warning: a replica will add >30 minutes to initial deploy)
- Secrets Manager
  - application.yml
  - database.yml
  - RDS master password
  - RDS application password
- Manages secrets with SOPs
  - See [root README](../../../../README.md) on how to create SOPs files or modify existing ones

## Blue/Green RDS Upgrade:

This infrastructure now supports the ability to upgrade RDS MySQL versions using Blue/Green deployments.

- If you are updating an Aurora Cluster using blue/green deployment, 
  set the source_db_cluster_identifier to the ARN of the source DB cluster and blue_green to true.

For more information on how to perform a Blue/Green Deployment, please see the DevOps runbook [here](https://legitscript.atlassian.net/wiki/spaces/TT/pages/3644194850/Runbook+Blue-Green+Deployment+for+Amazon+RDS).

## Deployment

SSO to the DevTest account:

For `STAGE`, run the `normalize-github-username.sh` script in `terraform/scripts` against your <GITHUB-USERNAME>. Example :

`./normalize-github-username.sh tjohn11` and you will get the output as `tjohn`. Use `STAGE=tjohn`

```bash
# Stage-specific deploy
# Note: if -var-file is not included, it will use the development one (this is likely fine)
STAGE=${STAGE} terragrunt apply [-var-file=stage-vars/${STAGE}.tfvars]

# Environment deploy
terragrunt apply
```

## Setting Up Personal Stages for Account Service.

Now that Account Service is made stage agnostic, you are able to deploy this with a personal Auth0 Tenant. There is a runbook to follow in order to do that. The runbook will go through everything from creating the Auth0 Tenant by hand, to the order of which directories should be deployed. Click [here](https://legitscript.atlassian.net/wiki/spaces/TT/pages/3917807620/Runbook+Setup+Personal+Account+Service+Auth0+Tenant) for the runbook.


### Notes:

For some reason it will always show this change, even though nothing changed.

```
  # module.account_service_connection.auth0_connection.account_service will be updated in-place
  ~ resource "auth0_connection" "account_service" {
        id                   = "xxxxxxxxxxxxx"
        name                 = "ls-accounts"
        # (5 unchanged attributes hidden)

      ~ options {
          + password_policy                = "none"
```

### Auth0 JS Changes

The Auth0 module will clone the [Auth0 Repository](https://github.com/legitscript/Auth0)
to create the account service connection.  If you need to update to a new version of the cloned code then
run the following command to have terraform re-clone the repository.

```bash
STAGE=${STAGE} terragrunt taint module.account_service_connection.null_resource.git_clone
```

### Warning: Do not ever run `destroy` for Stage==Environment

All applications depend on the `Stage==Environment` Connection created with this service.

Destroying the `Stage==Environment` stage will delete the Connection which all applications depend upon, as well as all application users.

Solution - Do not run `terragrunt destroy` 

If you do run `terragrunt destroy`, please follow the steps below.

Update clients for each application by running `terragrunt apply -var-file=development.tfvars` for the following

* [Merchant Monitoring](../merchant-monitoring/auth0/README.md)
* [Legacy Client Portal](../client-portal/auth0/README.md)
* [Private Site](../private/auth0/README.md)
* [Scraper](../scraper/auth0/README.md)
* [MyLS] (../myls/auth0/README.md)
* [Workbench] (../workbenches/certification/auth0/README.md)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3, < 1.6 |
| <a name="requirement_auth0"></a> [auth0](#requirement\_auth0) | 1.7.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |
| <a name="provider_aws.replica"></a> [aws.replica](#provider\_aws.replica) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_account_service_connection"></a> [account\_service\_connection](#module\_account\_service\_connection) | ../../../../modules/applications/auth0/account-service-connection | n/a |
| <a name="module_acm"></a> [acm](#module\_acm) | ../../../../modules/aws/acm | n/a |
| <a name="module_app_secrets"></a> [app\_secrets](#module\_app\_secrets) | ../../../../modules/applications/account-service/secrets | n/a |
| <a name="module_auth0_client"></a> [auth0\_client](#module\_auth0\_client) | ../../../../modules/applications/auth0/client | n/a |
| <a name="module_auth0_management_client"></a> [auth0\_management\_client](#module\_auth0\_management\_client) | ../../../../modules/applications/auth0/client | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ../../../../modules/applications/account-service/iam | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ../../../../modules/applications/account-service/rds | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | ../../../../modules/applications/account-service/sns | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_export.account_service_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.legitscript_service_subnet_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.legitscript_service_subnet_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.legitscript_service_subnet_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.legitscript_vpc_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.replica_account_service_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.replica_legitscript_service_subnet_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.replica_legitscript_service_subnet_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.replica_legitscript_service_subnet_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_cloudformation_export.replica_legitscript_vpc_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_export) | data source |
| [aws_route53_zone.legitscript_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_ssm_parameter.auth0_audience](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.auth0_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.circleci_self_hosted_runner_security_group_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.legitscript_employee_connection_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_service_sql_dump"></a> [account\_service\_sql\_dump](#input\_account\_service\_sql\_dump) | Location of account service sql dump | `string` | n/a | yes |
| <a name="input_adapter"></a> [adapter](#input\_adapter) | Option to use the dbms rails adapter | `string` | n/a | yes |
| <a name="input_auth0_client_id"></a> [auth0\_client\_id](#input\_auth0\_client\_id) | Client Id of the Application authorized with the Auth0 Management API. | `string` | n/a | yes |
| <a name="input_auth0_client_secret"></a> [auth0\_client\_secret](#input\_auth0\_client\_secret) | Client Secret of the Application authorized with the Auth0 Management API. | `string` | n/a | yes |
| <a name="input_auth0_domain"></a> [auth0\_domain](#input\_auth0\_domain) | Domain of the Auth0 instances. | `string` | n/a | yes |
| <a name="input_auth0_enabled"></a> [auth0\_enabled](#input\_auth0\_enabled) | Set to true to enable Auth0 login to Account Service. | `bool` | `false` | no |
| <a name="input_auth0_password_policy"></a> [auth0\_password\_policy](#input\_auth0\_password\_policy) | Password strength policy | `string` | n/a | yes |
| <a name="input_auth0_repo_version"></a> [auth0\_repo\_version](#input\_auth0\_repo\_version) | Git Ref to the Auth0 repository to use when cloning a specific version of the scripts. | `string` | n/a | yes |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Configure the auto minor version upgrade behavior. This is applied to the cluster instances and indicates if the automatic minor version upgrade of the engine is allowed. Default value is false. | `bool` | `false` | no |
| <a name="input_aws_accounts"></a> [aws\_accounts](#input\_aws\_accounts) | Map of our AWS accounts, loaded automatically from defaults.yml. | <pre>map(object({<br>    id        = string<br>    tier      = string<br>    role_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy to. | `string` | n/a | yes |
| <a name="input_blue_green"></a> [blue\_green](#input\_blue\_green) | Boolean flag if doing a Blue/Green Deployment. | `bool` | `false` | no |
| <a name="input_bypass_captcha"></a> [bypass\_captcha](#input\_bypass\_captcha) | Option to bypass captcha for user password reset | `string` | n/a | yes |
| <a name="input_certification_application_url"></a> [certification\_application\_url](#input\_certification\_application\_url) | Workbench URL for Certifications | `string` | n/a | yes |
| <a name="input_clients_application_url"></a> [clients\_application\_url](#input\_clients\_application\_url) | LCP application url | `string` | n/a | yes |
| <a name="input_cpv2_application_url"></a> [cpv2\_application\_url](#input\_cpv2\_application\_url) | Client Portal V2 application url | `string` | n/a | yes |
| <a name="input_create_cross_region_replica"></a> [create\_cross\_region\_replica](#input\_create\_cross\_region\_replica) | Whether to create an AWS replica | `bool` | n/a | yes |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | A map of custom tags to apply to the RDS Instance and the Security Group created for it. The key is the tag name and the value is the tag value. | `map(string)` | n/a | yes |
| <a name="input_db_cluster_parameter_group_family"></a> [db\_cluster\_parameter\_group\_family](#input\_db\_cluster\_parameter\_group\_family) | The aurora global version for DB Cluster Parameter group family. | `string` | `"aurora-mysql8.0"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Protect cluster from deletion | `bool` | n/a | yes |
| <a name="input_enable_asset_pipeline"></a> [enable\_asset\_pipeline](#input\_enable\_asset\_pipeline) | Config for using precompiled FE assets | `string` | n/a | yes |
| <a name="input_enable_asset_pipeline_debug"></a> [enable\_asset\_pipeline\_debug](#input\_enable\_asset\_pipeline\_debug) | Itemize rails FE assets to view in the browser | `string` | n/a | yes |
| <a name="input_encoding"></a> [encoding](#input\_encoding) | DB character encoding config | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The aurora global version for DB Cluster Parameter group family. | `string` | `"8.0.mysql_aurora.3.04.3"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy to. | `string` | n/a | yes |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number of RDS instances. | `number` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The RDS instance size. | `string` | n/a | yes |
| <a name="input_jwt_expiry"></a> [jwt\_expiry](#input\_jwt\_expiry) | Expiration in (s) for jwt token | `string` | n/a | yes |
| <a name="input_local_infile"></a> [local\_infile](#input\_local\_infile) | Var to deny/allow loading of local files | `string` | n/a | yes |
| <a name="input_mailcatcher_host"></a> [mailcatcher\_host](#input\_mailcatcher\_host) | Mailcatcher url | `string` | n/a | yes |
| <a name="input_parker_application_url"></a> [parker\_application\_url](#input\_parker\_application\_url) | Parker application url | `string` | n/a | yes |
| <a name="input_pool"></a> [pool](#input\_pool) | DB connection pool size | `string` | n/a | yes |
| <a name="input_portal_v2_key_hash"></a> [portal\_v2\_key\_hash](#input\_portal\_v2\_key\_hash) | String hash used for cpv2 integration testing | `string` | n/a | yes |
| <a name="input_private_application_url"></a> [private\_application\_url](#input\_private\_application\_url) | Private Site Application url | `string` | n/a | yes |
| <a name="input_public_application_url"></a> [public\_application\_url](#input\_public\_application\_url) | Public Site Application url | `string` | n/a | yes |
| <a name="input_recaptcha_secret_key"></a> [recaptcha\_secret\_key](#input\_recaptcha\_secret\_key) | Captcha provider client secret key | `string` | n/a | yes |
| <a name="input_recaptcha_site_key"></a> [recaptcha\_site\_key](#input\_recaptcha\_site\_key) | Captcha provider client site key | `string` | n/a | yes |
| <a name="input_reconnect"></a> [reconnect](#input\_reconnect) | DB reconnect on broken connection | `string` | n/a | yes |
| <a name="input_replica_region"></a> [replica\_region](#input\_replica\_region) | Region to place RDS replica | `string` | `"us-east-1"` | no |
| <a name="input_risk_application_url"></a> [risk\_application\_url](#input\_risk\_application\_url) | Risk Application url | `string` | n/a | yes |
| <a name="input_rollbar_access_token"></a> [rollbar\_access\_token](#input\_rollbar\_access\_token) | Access token for posting exceptions to rollbar | `string` | n/a | yes |
| <a name="input_scraper_application_url"></a> [scraper\_application\_url](#input\_scraper\_application\_url) | Scraper Application url | `string` | n/a | yes |
| <a name="input_secret_token"></a> [secret\_token](#input\_secret\_token) | Shared JWT token | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Whether to take a final snapshot on deletion | `bool` | n/a | yes |
| <a name="input_source_db_cluster_identifier"></a> [source\_db\_cluster\_identifier](#input\_source\_db\_cluster\_identifier) | The source DB cluster identifier for the global cluster (primiraly set when upgrading DB engine with blue/green deployment) | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | The stage to deploy to. | `string` | n/a | yes |
| <a name="input_test_transactions_application_url"></a> [test\_transactions\_application\_url](#input\_test\_transactions\_application\_url) | Test Transaction Application url | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | DB query timeout value | `string` | n/a | yes |
| <a name="input_tld"></a> [tld](#input\_tld) | Top Level Domain for the environment | `string` | n/a | yes |
| <a name="input_unassigned_application_url"></a> [unassigned\_application\_url](#input\_unassigned\_application\_url) | The application url to use when for unassigned applications (See LS-23229 for some context) | `string` | n/a | yes |
| <a name="input_vpn_security_groups"></a> [vpn\_security\_groups](#input\_vpn\_security\_groups) | The VPN security group | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_validation_settings"></a> [acm\_certificate\_validation\_settings](#output\_acm\_certificate\_validation\_settings) | Setting required to complete the ACM certificate validation |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_cluster_endpoint_replica"></a> [cluster\_endpoint\_replica](#output\_cluster\_endpoint\_replica) | n/a |
| <a name="output_instance_endpoints"></a> [instance\_endpoints](#output\_instance\_endpoints) | n/a |
| <a name="output_instance_endpoints_replica"></a> [instance\_endpoints\_replica](#output\_instance\_endpoints\_replica) | n/a |
| <a name="output_port"></a> [port](#output\_port) | n/a |
| <a name="output_user_update_sns_topic_name"></a> [user\_update\_sns\_topic\_name](#output\_user\_update\_sns\_topic\_name) | SNS topic name for Merchant Monitoring user update |
<!-- END_TF_DOCS -->
