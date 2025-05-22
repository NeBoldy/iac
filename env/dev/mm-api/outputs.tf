output "record_table_arn" {
  value       = aws_dynamodb_table.record_table.arn
  description = "Arn of DynamoDB table contaning request history."
}

output "products_throttle_table_arn" {
  value       = aws_dynamodb_table.products_throttle_table.arn
  description = "Arn of DynamoDB table tracking request for throttling purposes."
}

output "websites_throttle_table_arn" {
  value       = aws_dynamodb_table.websites_throttle_table.arn
  description = "Arn of DynamoDB table tracking request for throttling purposes."
}
