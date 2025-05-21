output "cluster_endpoint" {
       value = module.rds.cluster_endpoint
}

output "cluster_endpoint_replica" {
  value = var.create_cross_region_replica ? module.rds[*].cluster_endpoint_replica : null
}

output "instance_endpoints" {
       value = module.rds.instance_endpoints
}     

     output "instance_endpoints_replica" {
  value = var.create_cross_region_replica ? module.rds[*].instance_endpoints_replica : null
}

output "port" {
  value = module.rds.port
}

output "acm_certificate_validation_settings" {
  description = "Setting required to complete the ACM certificate validation"
        value       = local.is_private_route53_zone ? module.acm.domain_validation_options : null
}

output "user_update_sns_topic_name" {
  description = "SNS topic name for Merchant Monitoring user update"
  value       = module.sns.user_update_sns_topic_name
}
