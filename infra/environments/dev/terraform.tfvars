# Variables específicas para el entorno de desarrollo
# Estas variables personalizan la infraestructura para el ambiente dev

environment = "dev"

# Configuración de la tabla DynamoDB para órdenes
table_name         = "orders-dev"
table_description  = "Tabla de órdenes para entorno de desarrollo"

# Configuración de capacidad bajo demanda (On-Demand) para desarrollo
# On-Demand es ideal para desarrollo ya que solo paga por lo que usa
billing_mode = "PAY_PER_REQUEST"

# Capacidad de lectura/escritura solo aplica si billing_mode es PROVISIONED
# Descomentar si se usa capacidad provisionada:
# read_capacity  = 5
# write_capacity = 5

# Configuración de claves de la tabla
partition_key_name = "pk"
partition_key_type = "S"  # S = String, N = Number, B = Binary

sort_key_name      = "sk"
sort_key_type      = "S"

# Habilitar streaming para captura de cambios (CDC)
enable_stream = true
stream_view_type = "NEW_AND_OLD_IMAGES"

# Habilitar Point-in-Time Recovery (PITR) para protección de datos
enable_pitr = true

# Configuración de Time To Live (TTL) para limpieza automática de datos
enable_ttl = true
ttl_attribute_name = "expires_at"

# Configuración de región
region = "us-east-1"

# Tags para gestión de costos y organización
tags = {
  Environment     = "dev"
  Project         = "orders-management"
  ManagedBy       = "terraform"
  CostCenter      = "engineering"
  Owner           = "platform-team"
  DataClassification = "internal"
}

# Configuración de acceso (solo para desarrollo)
# En producción, usar roles IAM específicos
enable_dynamodb_access = true