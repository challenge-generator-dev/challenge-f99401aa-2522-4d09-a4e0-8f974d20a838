# Variables globales para la infraestructura

variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Nombre del proyecto para tagging"
  type        = string
  default     = "order-management"
}

# Variables específicas para DynamoDB
variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB para almacenar órdenes"
  type        = string
  default     = "orders"
}

variable "dynamodb_billing_mode" {
  description = "Modo de facturación para la tabla DynamoDB (PROVISIONED o PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_read_capacity" {
  description = "Capacidad de lectura provisionada (solo aplicable si billing_mode es PROVISIONED)"
  type        = number
  default     = 5
}

variable "dynamodb_write_capacity" {
  description = "Capacidad de escritura provisionada (solo aplicable si billing_mode es PROVISIONED)"
  type        = number
  default     = 5
}

variable "dynamodb_hash_key" {
  description = "Clave hash (partition key) para la tabla DynamoDB"
  type        = string
  default     = "order_id"
}

variable "dynamodb_range_key" {
  description = "Clave de rango (sort key) para la tabla DynamoDB (opcional)"
  type        = string
  default     = "created_at"
}

variable "dynamodb_ttl_attribute" {
  description = "Atributo para habilitar Time To Live (TTL) en DynamoDB"
  type        = string
  default     = "expiry_time"
}

variable "dynamodb_tags" {
  description = "Tags adicionales para la tabla DynamoDB"
  type        = map(string)
  default = {
    Service = "order-management"
    Layer   = "data"
  }
}