terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "orders-management"
      ManagedBy   = "terraform"
      CostCenter  = var.cost_center
    }
  }

  skip_credentials_validation = var.skip_credentials_validation
  skip_requesting_account_id  = var.skip_requesting_account_id
  skip_metadata_api_check     = var.skip_metadata_api_check

  endpoints {
    dynamodb = var.dynamodb_endpoint
  }
}

provider "aws" {
  alias  = "dynamodb_local"
  region = var.aws_region

  endpoints {
    dynamodb = var.dynamodb_endpoint
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Nombre del entorno (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "cost_center" {
  description = "Centro de costos para tag de facturación"
  type        = string
  default     = "engineering"
}

variable "skip_credentials_validation" {
  description = "Omitir validación de credenciales (usar para desarrollo local)"
  type        = bool
  default     = false
}

variable "skip_requesting_account_id" {
  description = "Omitir solicitud de account ID"
  type        = bool
  default     = false
}

variable "skip_metadata_api_check" {
  description = "Omitir verificación de API de metadatos"
  type        = bool
  default     = false
}

variable "dynamodb_endpoint" {
  description = "Endpoint de DynamoDB (para desarrollo local)"
  type        = string
  default     = null
}