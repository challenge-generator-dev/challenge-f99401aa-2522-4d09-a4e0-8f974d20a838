terraform {
  # Bloque de backend configurado en paralelo en otro lote
  # El bloque terraform aquí es solo para configuración de providers
}

# Módulo principal de DynamoDB para gestión de órdenes
module "dynamodb_orders" {
  source = "./modules/dynamodb"

  environment      = var.environment
  table_name       = var.table_name
  billing_mode     = var.billing_mode
  read_capacity    = var.read_capacity
  write_capacity   = var.write_capacity
  enable_ttl       = var.enable_ttl
  ttl_attribute_name = var.ttl_attribute_name

  # Configuración de clave primaria
  partition_key_name = var.partition_key_name
  partition_key_type = var.partition_key_type
  sort_key_name      = var.sort_key_name
  sort_key_type      = var.sort_key_type

  # Configuración de índices secundarios
  gsi_config = var.gsi_config

  # Tags heredados del provider
  tags = var.tags
}

# Bucket S3 para almacenamiento de logs y auditoría
resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-${var.environment}-logs-${data.aws_caller_identity.current.account_id}"

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-logs"
    Description = "Bucket para logs y auditoría del sistema de órdenes"
  })
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Grupo de CloudWatch Logs para la aplicación
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/${var.project_name}/${var.environment}/application"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.logs.arn

  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "app" {
  name           = "application"
  log_group_name = aws_cloudwatch_log_group.app.name
}

# Clave KMS para cifrado de logs
resource "aws_kms_key" "logs" {
  description             = "Clave KMS para cifrado de logs de la aplicación"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_kms_alias" "logs" {
  name          = "alias/${var.project_name}-${var.environment}-logs"
  target_key_id = aws_kms_key.logs.key_id
}

# Rol IAM para la aplicación
resource "aws_iam_role" "app" {
  name = "${var.project_name}-${var.environment}-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Política IAM para acceso completo a DynamoDB
resource "aws_iam_policy" "dynamodb_full_access" {
  name        = "${var.project_name}-${var.environment}-dynamodb-access"
  description = "Política para acceso completo a la tabla de órdenes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:DescribeTable"
        ]
        Resource = [
          module.dynamodb_orders.table_arn,
          "${module.dynamodb_orders.table_arn}/index/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:ListTables",
          "dynamodb:DescribeLimits"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.dynamodb_full_access.arn
}

# Política IAM para escritura de logs
resource "aws_iam_policy" "logs_write" {
  name        = "${var.project_name}-${var.environment}-logs-write"
  description = "Política para escritura de logs en CloudWatch y S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = aws_cloudwatch_log_group.app.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.logs.arn,
          "${aws_s3_bucket.logs.arn}/*"
        ]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "logs_write" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.logs_write.arn
}

# Obtener información de la cuenta actual
data "aws_caller_identity" "current" {}

# Variables con valores por defecto para el módulo principal
variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "orders-management"
}

variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
  default     = "orders"
}

variable "billing_mode" {
  description = "Modo de facturación de DynamoDB (PAY_PER_REQUEST o PROVISIONED)"
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "El modo de facturación debe ser PAY_PER_REQUEST o PROVISIONED"
  }
}

variable "read_capacity" {
  description = "Capacidad de lectura para modo PROVISIONED"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Capacidad de escritura para modo PROVISIONED"
  type        = number
  default     = 5
}

variable "partition_key_name" {
  description = "Nombre de la clave de partición"
  type        = string
  default     = "orderId"
}

variable "partition_key_type" {
  description = "Tipo de dato de la clave de partición"
  type        = string
  default     = "S"
  validation {
    condition     = contains(["S", "N", "B"], var.partition_key_type)
    error_message = "El tipo de clave debe ser S (String), N (Number) o B (Binary)"
  }
}

variable "sort_key_name" {
  description = "Nombre de la clave de ordenamiento"
  type        = string
  default     = "createdAt"
}

variable "sort_key_type" {
  description = "Tipo de dato de la clave de ordenamiento"
  type        = string
  default     = "S"
  validation {
    condition     = contains(["S", "N", "B"], var.sort_key_type)
    error_message = "El tipo de clave debe ser S (String), N (Number) o B (Binary)"
  }
}

variable "enable_ttl" {
  description = "Habilitar TTL para limpieza automática"
  type        = bool
  default     = true
}

variable "ttl_attribute_name" {
  description = "Nombre del atributo TTL"
  type        = string
  default     = "expiresAt"
}

variable "gsi_config" {
  description = "Configuración de índices secundarios globales"
  type = list(object({
    name            = string
    partition_key   = string
    partition_type  = string
    sort_key        = optional(string)
    sort_key_type   = optional(string)
    projection_type = string
    read_capacity   = optional(number)
    write_capacity  = optional(number)
  }))
  default = [
    {
      name            = "statusIndex"
      partition_key   = "status"
      partition_type  = "S"
      sort_key        = "createdAt"
      sort_key_type   = "S"
      projection_type = "ALL"
    },
    {
      name            = "customerIndex"
      partition_key   = "customerId"
      partition_type  = "S"
      sort_key        = "createdAt"
      sort_key_type   = "S"
      projection_type = "ALL"
    }
  ]
}

variable "log_retention_days" {
  description = "Días de retención de logs en CloudWatch"
  type        = number
  default     = 7
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 2192, 2555, 2922, 3653], var.log_retention_days)
    error_message = "Días de retención inválidos para CloudWatch Logs"
  }
}

variable "tags" {
  description = "Tags adicionales para todos los recursos"
  type        = map(string)
  default     = {}
}