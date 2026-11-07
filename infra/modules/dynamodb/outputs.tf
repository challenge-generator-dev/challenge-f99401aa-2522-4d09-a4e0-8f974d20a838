output "table_name" {
  description = "The name of the DynamoDB table"
  value       = aws_dynamodb_table.orders.name
}

output "table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = aws_dynamodb_table.orders.arn
}

output "table_id" {
  description = "The ID of the DynamoDB table"
  value       = aws_dynamodb_table.orders.id
}

output "table_status" {
  description = "The current status of the table"
  value       = aws_dynamodb_table.orders.status
}

output "table_size_bytes" {
  description = "The size of the table in bytes"
  value       = aws_dynamodb_table.orders.size_bytes
}

output "item_count" {
  description = "The number of items in the table"
  value       = aws_dynamodb_table.orders.item_count
}

output "table_stream_arn" {
  description = "The ARN of the DynamoDB stream if stream is enabled"
  value       = try(aws_dynamodb_table.orders.stream_arn, null)
}

output "table_stream_label" {
  description = "A timestamp, in ISO 8601 format, when there was a stream last update"
  value       = try(aws_dynamodb_table.orders.stream_label, null)
}

output "global_secondary_indexes" {
  description = "List of global secondary indexes and their configuration"
  value       = { for gsi in aws_dynamodb_table.orders.global_secondary_index : gsi.name => {
    index_name       = gsi.index_name
    key_schema       = gsi.key_schema
    projection_type  = gsi.projection_type
    read_capacity    = gsi.read_capacity
    write_capacity   = gsi.write_capacity
    item_count       = try(gsi.item_count, 0)
    index_size_bytes = try(gsi.index_size_bytes, 0)
    index_status     = try(gsi.index_status, null)
  }}
}

output "local_secondary_indexes" {
  description = "List of local secondary indexes and their configuration"
  value       = { for lsi in aws_dynamodb_table.orders.local_secondary_index : lsi.name => {
    index_name       = lsi.index_name
    key_schema       = lsi.key_schema
    projection_type  = lsi.projection_type
    index_size_bytes = try(lsi.index_size_bytes, 0)
    item_count       = try(lsi.item_count, 0)
  }}
}

output "replica_table_arns" {
  description = "List of replica table ARNs if cross-region replication is enabled"
  value       = [for replica in aws_dynamodb_table.orders.replica : replica.arn]
}

output "replica_table_region" {
  description = "Region of replica table if cross-region replication is enabled"
  value       = [for replica in aws_dynamodb_table.orders.replica : replica.region_name]
}

output "table_endpoint" {
  description = "The DynamoDB table endpoint for SDK connections"
  value       = "https://dynamodb.${var.region}.amazonaws.com"
}

output "table_partition_key" {
  description = "The partition key name of the table"
  value       = var.partition_key_name
}

output "table_sort_key" {
  description = "The sort key name of the table"
  value       = var.sort_key_name
}

output "service_role_arn" {
  description = "The ARN of the service role for DynamoDB access if created"
  value       = var.create_service_role ? aws_iam_role.dynamodb_access_role[0].arn : null
}

output "read_policy_arn" {
  description = "The ARN of the read access policy if created"
  value       = var.create_service_role ? aws_iam_policy.dynamodb_read_policy[0].arn : null
}

output "write_policy_arn" {
  description = "The ARN of the write access policy if created"
  value       = var.create_service_role ? aws_iam_policy.dynamodb_write_policy[0].arn : null
}

output "backup_plan_id" {
  description = "The ID of the backup plan if backups are enabled"
  value       = var.enable_backup ? aws_backup_plan.dynamodb_backup[0].id : null
}

output "backup_selection_id" {
  description = "The ID of the backup selection if backups are enabled"
  value       = var.enable_backup ? aws_backup_selection.dynamodb_backup_selection[0].id : null
}

output "ssm_parameter_name" {
  description = "The SSM parameter name storing the table name if enabled"
  value       = var.store_table_name_in_ssm ? aws_ssm_parameter.table_name_parameter[0].name : null
}

output "log_group_name" {
  description = "The CloudWatch log group name for DynamoDB logs if detailed metrics enabled"
  value       = var.enable_detailed_metrics ? aws_cloudwatch_log_group.dynamodb_logs[0].name : null
}

output "tags" {
  description = "Tags applied to the DynamoDB table"
  value       = aws_dynamodb_table.orders.tags
}