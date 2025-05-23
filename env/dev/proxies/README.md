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
3. `ENVIRONMENT=development STAGE=development terragrunt apply`