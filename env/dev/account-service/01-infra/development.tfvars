account_service_sql_dump          = "http://reports.legitscript.com/dev_files/account-service-2023.sql.gz"
skip_final_snapshot               = true
deletion_protection               = false
create_cross_region_replica       = false
   instance_type                     = "db.r5.large" # smallest instance that works with Aurora-Global
instance_count                    = 2
auth0_repo_version                = "v0.15.0"
      auth0_enabled                     = true
auth0_password_policy             = "good"
custom_tags                       = { AutoManageState = "False" } # AS is generally needed by other services for login, so making an exception to the rule for the AS RDS.
tld                               = "legitscript.net"
engine_version                    = "8.0.mysql_aurora.3.04.3"
db_cluster_parameter_group_family = "aurora-mysql8.0"
      auto_minor_version_upgrade        = false # we want to stay on LTS version


# app yaml
enable_asset_pipeline             = true
enable_asset_pipeline_debug       = false

  bypass_captcha                    = false
      certification_application_url     = "https://workbench-beta.legitscript.com/certifications"
        clients_application_url           = "https://portal-staging.legitscript.com"
        






cpv2_application_url              = "https://my-beta.legitscript.com"
jwt_expiry                        = 54000
mailcatcher_host                  = "mailcatcher.development.legitscript.net"
        parker_application_url            = "https://parker-staging.legitscript.com"
private_application_url           = "https://secure-staging.legitscript.com"
public_application_url            = "http://dev.legitscript.com/"
risk_application_url              = "https://payments-staging.legitscript.com"
scraper_application_url           = "https://scraper-staging.legitscript.com"
test_transactions_application_url = "https://www.legitscript.com"
unassigned_application_url        = "https://www.legitscript.com"

# db yaml
adapter      = "mysql2"

  
  encoding     = "utf8"
pool         = 5
reconnect    = true

  
  timeout      = 5000
local_infile = true

# blue/green deployment variables
/*
- If you are upgrading infrastrucutre using blue/green deployment, 
  set the source_db_cluster_identifier to the ARN of the source DB cluster and blue_green to true.
*/
source_db_cluster_identifier = "arn:aws:rds:us-west-2:916533587194:cluster:accounts-development-1"
blue_green                   = false
