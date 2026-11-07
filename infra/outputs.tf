# Outputs de la infraestructura de DynamoDB para gestión de órdenes
# Expone los valores necesarios para que otras capas consuman los recursos creados

output "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB de órdenes"
  value       = module.dynamodb.orders_table_name
}

output "dynamodb_table_arn" {
  description = "ARN de la tabla DynamoDB de órdenes"
  value       = module.dynamodb.orders_table_arn
}

output "dynamodb_table_id" {
  description = "ID de la tabla DynamoDB de órdenes"
  value       = module.dynamodb.orders_table_id
}

output "dynamodb_endpoint" {
  description = "Endpoint de la tabla DynamoDB para conexiones directas"
  value       = "https://dynamodb.${var.region}.amazonaws.com"
}

output "orders_table_stream_arn" {
  description = "ARN del stream de la tabla para captura de cambios (CDC)"
  value       = module.dynamodb.orders_table_stream_arn
  depends_on  = [module.dynamodb]
}

output "environment" {
  description = "Entorno donde se desplegó la infraestructura"
  value       = var.environment
}

output "region" {
  description = "Región de AWS donde se desplegó la infraestructura"
  value       = var.region
}

output "tags_applied" {
  description = "Tags aplicados a todos los recursos"
  value       = var.tags
}