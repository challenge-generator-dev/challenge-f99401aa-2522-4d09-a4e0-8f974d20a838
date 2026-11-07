# Módulo de Infraestructura - CRUD de Órdenes en DynamoDB

Este módulo de Terraform provisiona la infraestructura necesaria para el sistema de gestión de órdenes sobre DynamoDB.

## Recursos Creados

### Tabla DynamoDB
- **Nombre**: Tabla de órdenes con clave primaria compuesta
- **Partition Key**: `orderId` (String) - Identificador único de la orden
- **Sort Key**: `createdAt` (String) - Fecha de creación para ordenamiento
- **Modo de facturación**: PAY_PER_REQUEST para desarrollo, PROVISIONED para producción
- **TTL habilitado**: Campo `expiresAt` para limpieza automática de registros
- **Índices secundarios**: GSI para consultas por estado y cliente

### Recursos Adicionales
- **S3 Bucket**: Almacenamiento de logs y auditoría
- **CloudWatch Log Group**: Grupo de logs para la aplicación
- **IAM Roles**: Roles con permisos específicos para DynamoDB

## Uso del Módulo

```hcl
module "infra" {
  source = "./infra"

  environment      = "dev"
  aws_region       = "us-east-1"
  cost_center      = "engineering"
  table_name       = "orders"
  billing_mode     = "PAY_PER_REQUEST"
  dynamodb_endpoint = "http://localhost:8000"
}
```

## Variables Requeridas

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `environment` | string | Entorno de despliegue |
| `table_name` | string | Nombre de la tabla DynamoDB |

## Variables Opcionales

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `aws_region` | string | "us-east-1" | Región de AWS |
| `billing_mode` | string | "PAY_PER_REQUEST" | Modo de facturación |
| `read_capacity` | number | 5 | Capacidad de lectura (PROVISIONED) |
| `write_capacity` | number | 5 | Capacidad de escritura (PROVISIONED) |
| `enable_dynamodb_endpoint` | bool | false | Habilitar endpoint local |
| `enable_ttl` | bool | true | Habilitar TTL automático |
| `tags` | map(string) | {} | Tags adicionales |

## Outputs

| Output | Tipo | Descripción |
|--------|------|-------------|
| `table_name` | string | Nombre de la tabla DynamoDB |
| `table_arn` | string | ARN de la tabla |
| `table_endpoint` | string | Endpoint de la tabla |
| `dynamodb_bucket_name` | string | Nombre del bucket de logs |
| `log_group_name` | string | Nombre del grupo de logs |
| `iam_role_arn` | string | ARN del rol IAM |

## Validación Local

### Prerrequisitos
- Terraform >= 1.9.0
- AWS CLI configurado o Docker para DynamoDB local
- Docker (opcional) para DynamoDB local

### Pasos de Validación

1. **Inicializar Terraform**:
```bash
cd infra
terraform init
```

2. **Validar sintaxis**:
```bash
terraform validate
```

3. **Planificar cambios**:
```bash
terraform plan -var-file=../environments/dev/terraform.tfvars
```

4. **Aplicar infraestructura (desarrollo local)**:
```bash
docker run -d -p 8000:8000 amazon/dynamodb-local
terraform apply -var-file=../environments/dev/terraform.tfvars
```

5. **Verificar recursos creados**:
```bash
aws dynamodb list-tables --endpoint-url http://localhost:8000
aws dynamodb describe-table --table-name orders --endpoint-url http://localhost:8000
```

## Estructura del Módulo

```
infra/
├── versions.tf          # Configuración de versiones de Terraform y providers
├── main.tf              # Definición principal de recursos
├── variables.tf         # Declaraciones de variables
├── outputs.tf           # Outputs del módulo
├── README.md            # Este archivo
└── modules/
    └── dynamodb/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Consideraciones de Seguridad

- Los roles IAM usan principio de mínimo privilegio
- Las tablas DynamoDB tienen encryption at-rest habilitado
- El acceso a la tabla se controla via IAM policies
- Los logs se almacenan en S3 con versioning habilitado
- TTL automático limpia datos vencidos para reducir costos

## Notas de Costos

- DynamoDB: Costo basado en modo de facturación (PAY_PER_REQUEST o PROVISIONED)
- S3: Costo por almacenamiento de logs (típicamente muy bajo)
- CloudWatch: Costo por ingesta de logs
- Data Transfer: costos por acceso cross-region si aplica