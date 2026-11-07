# Prompt para Mejorar el Codigo Base

Copia y pega el contenido del bloque de abajo en un asistente de IA (Claude, ChatGPT)
para obtener el proyecto completo y arrancable. Guarda los archivos que te devuelva en la
carpeta del repo, respetando exactamente las rutas.

Si preferis trabajar en tu editor con un agente local (Claude Code, Cursor, Copilot), usa `AGENTS.md` en vez de este archivo: dice lo mismo pero para que escriba los archivos en disco.

## Las dos reglas que no se negocian

1. **Completa el boilerplate.** Todo lo que el proyecto necesita para compilar y arrancar: manifiesto de dependencias, punto de entrada, configuracion, capa de interfaz, y las capas del patron arquitectonico declarado. Eso es andamiaje y es tu trabajo.
2. **NO resuelvas el reto.** Los entregables de las fases son el trabajo de la persona. El hueco pedagogico se deja como esta: el proyecto arranca, pero lo que el reto pide implementar NO esta implementado.

Dicho de otra forma: si algo impide compilar, arreglalo. Si algo es logica de negocio incompleta, validaciones ausentes, un secreto hardcodeado o un patron mejorable, dejalo exactamente como esta — es lo que la persona tiene que encontrar.

## Mapa de componentes

El repo tiene una carpeta por componente. Cada uno se instala y verifica dentro de la suya.

| Componente | Carpeta | Rol | Capa | Track | Tecnologias |
|---|---|---|---|---|---|
| `app` | `app/` | practice, chapter | server | Node | Express, DynamoDB |
| `infra` | `infra/` | support | infra | Terraform (AWS) | Terraform |
| `infra-local` | (raiz) | support | infra | Compose local | DynamoDB |

## Orden de arranque

1. `docker compose up -d` (en la raiz) — levanta la infraestructura local.
2. `cd infra && terraform fmt -check -recursive && terraform init -backend=false && terraform validate` — componente `infra` (support).
3. `cd app && npm install && npm run build` — componente `app` (practice, chapter).

### Contratos entre componentes

- `app` expone http (api: http://localhost:3000):
  - `POST /orders`
  - `GET /orders/:id`
  - `PUT /orders/:id`
  - `DELETE /orders/:id`
  - `GET /orders`

## Herramientas

- **Terraform**: Herramienta de trabajo del candidato: usala en la fase donde se depura o se prueba la solucion (no es una dependencia del proyecto).

## Lo que le falta a este proyecto

Esto NO lo tenes que adivinar: salio de comparar el proyecto contra la arquitectura declarada del reto y de un analisis estatico del codigo. Completalo TODO.

### Boilerplate del stack que falta

Sin esto no compila ni arranca. Es andamiaje, no toca nada de lo pedagogico:

- **app/src/app.module.ts** — Sin el modulo raiz, Nest no tiene arbol de dependencias que resolver y el bootstrap falla.

## Como saber que terminaste

```bash
(cd app && npm install && npm run build) && (cd infra && terraform fmt -check -recursive && terraform init -backend=false && terraform validate) && docker compose config -q
```

Ese comando corriendo sin errores es la definicion de "listo".

---

```
## Briefing del reto (autoridad)
Este bloque manda sobre los archivos adjuntos. El stack y el rol salen de AQUÍ, no de un topic genérico ni de markdown placeholder.

### Perfil
Chapter Backend, Especialidad Desarrollador, Tecnología Node, Advanced L2

### Brecha de conocimiento
CRUD de ordenes en DynamoDB expuesto por una API REST (corrida e2e 20261106194239047), Implementa operaciones CRUD de ordenes sobre una tabla DynamoDB expuestas por una API REST

### Misión / candidato
Persistir y consultar ordenes

### Reto
- Tema: CRUD de ordenes sobre DynamoDB
- Seniority: advanced-l2
- Tipo: practical
- Título: Implementación de CRUD de ordenes en DynamoDB
- Tiempo estimado: 8 horas

### Fases (trabajo del HUMANO — PROHIBIDO completarlas)
No implementes estos entregables. Dejalos como hueco pedagógico. El asistente solo materializa el proyecto arrancable para que el participante pueda trabajar.
- Fase 1: Configuración inicial y creación de la tabla DynamoDB — objetivo: Configurar el entorno de desarrollo y crear la tabla DynamoDB para almacenar las ordenes. — entregable (NO resolver): Tabla DynamoDB creada y configurada para almacenar ordenes.
- Fase 2: Implementación de la operación Crear — objetivo: Implementar la funcionalidad para crear nuevas ordenes en la tabla DynamoDB. — entregable (NO resolver): Funcionalidad para crear nuevas ordenes en DynamoDB, con manejo de errores y validación.
- Fase 3: Implementación de las operaciones Leer, Actualizar y Eliminar — objetivo: Implementar las funcionalidades para leer, actualizar y eliminar ordenes en la tabla DynamoDB. — entregable (NO resolver): Funcionalidades para leer, actualizar y eliminar ordenes en DynamoDB, con manejo de errores y validación.

Eres un asistente experto en análisis, corrección y generación de archivos de cualquier tipo:
código fuente, documentación, hojas de cálculo, documentos Word, configuraciones, entre otros.
Voy a enviarte una cadena de texto que contiene uno o más archivos. Cada archivo está delimitado por un marcador con el siguiente formato:
// === ARCHIVO: ruta/del/archivo.extension ===
o también puede aparecer como:
## === ARCHIVO: ruta/del/archivo.extension ===
Lo que sigue al marcador puede ser:

El contenido real del archivo (código, texto, YAML, etc.)
Una descripción en lenguaje natural de lo que debe contener el archivo


TU TAREA
PASO 0 — ¿Esto es un proyecto o una carcasa?
Antes de extraer archivos, leé el Briefing (si está) y diagnosticá el adjunto.

Es CARCASA si ocurre CUALQUIERA de estas:
- No hay manifiesto de dependencias del stack del briefing (manifest.json de VTEX IO / package.json / pom.xml / build.gradle / requirements.txt / go.mod / *.tf / *.csproj, según corresponda)
- Hay un "binario" que en realidad es un comentario ("no puede ser mostrado como texto plano", placeholder .fig/.docx vacío)
- Los markdowns ya completan entregables de fases posteriores ("se implementó fade-in", lista de áreas ya resuelta)

Si es CARCASA:
- MATERIALIZÁ un proyecto que arranca en el stack del briefing (VTEX IO Store Framework, Angular, Terraform, pytest, Nest, etc.). Incluí manifiesto, punto de entrada y capa de interfaz reales.
- NO copies los markdowns de "solución" como si fueran el producto. Son ruido de generación.
- NO resuelvas las fases del briefing (están marcadas PROHIBIDO). Dejá el hueco pedagógico: el flujo existe, las microinteracciones/calidad/infra que el reto pide NO están hechas.
- Después seguí al PASO 5 (entrega de archivos).

Si es un proyecto REAL (manifiesto + código que compila o arranca):
- Seguí PASO 1 en adelante. 🔴 compilación sí. 🟡 pedagógico no.

PASO 1 — Detección y extracción
Identifica todos los archivos presentes en la cadena. Para cada archivo extrae:

Su ruta completa (ej: src/main/java/com/pragma/Service.java)
Su contenido o descripción

PASO 2 — Clasificación por tipo
Clasifica cada archivo en una de estas categorías:
A) Código fuente (Java, Python, TypeScript, JavaScript, Kotlin, etc.)
B) Configuración / documentación (YAML, properties, Markdown, JSON, txt, etc.)
C) Excel (.xlsx, .xls, .csv)
D) Word (.docx, .doc)
E) Otro tipo de archivo binario o especial
PASO 3 — Clasificación de errores en código fuente

Objetivo prioritario: que el proyecto compile. No corrijas flujo de negocio ni lógica funcional.

Antes de modificar cualquier archivo de código fuente, clasifica cada problema encontrado en una de estas dos categorías:
🔴 ERROR DE COMPILACIÓN — corregir siempre
Son errores que impiden que el proyecto arranque, sin valor pedagógico:

Import faltante o incorrecto
Clase, método o variable referenciada que no existe en ningún archivo del proyecto
Error de sintaxis
Anotación con atributos inválidos
Dependencia ausente en pom.xml, package.json, etc.
Archivo referenciado que no existe y debe ser creado con implementación mínima

→ CORREGIR estos errores.
🟡 PROBLEMA FUNCIONAL O DE CALIDAD — preservar siempre
Son problemas que no impiden compilar. Pueden ser intencionales para el aprendizaje:

Clave secreta hardcodeada ("secret", "password123")
API deprecada que funciona pero tiene reemplazo moderno
Lógica de negocio incorrecta o incompleta
Código redundante o de baja legibilidad
Falta de validaciones en flujo de negocio
Patrones de diseño incorrectos pero funcionales
Concurrencia no segura
Configuración funcional pero no óptima

→ PRESERVAR tal cual. No corregir, no mejorar, no comentar.
PASO 4 — Procesamiento según tipo de archivo
Tipo A — Código fuente
Aplica únicamente las correcciones clasificadas como 🔴 ERROR DE COMPILACIÓN.
No alteres ningún elemento clasificado como 🟡 PROBLEMA FUNCIONAL O DE CALIDAD.
Si falta un archivo referenciado, créalo con la implementación mínima necesaria para compilar.
Tipo B — Configuración / documentación
Extrae el contenido tal cual, sin modificaciones salvo errores evidentes de sintaxis
(ej: YAML mal indentado).
Tipo C — Excel (.xlsx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un archivo Excel funcional con:

Fila de encabezados en negrita con color de fondo distintivo
Columnas con ancho ajustado al contenido
Tipos de dato correctos por columna
Validaciones si la descripción lo indica
Hojas nombradas descriptivamente si hay más de una
Filas de ejemplo si no hay datos reales

Tipo D — Word (.docx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un documento Word funcional con:

Estilos de título (Título 1, Título 2) para jerarquía de secciones
Fuente legible (Calibri o equivalente), tamaño 11-12pt para cuerpo
Márgenes estándar
Tabla de contenido si tiene múltiples secciones
Tablas con encabezados en negrita si aplica

Tipo E — Otro
Genera el archivo con el contenido o estructura más apropiada según la descripción.
PASO 5 — Entrega de archivos
Entregá cada archivo con su ruta completa, respetando exactamente la estructura de rutas
indicada por los marcadores: un bloque por archivo, precedido por su ruta. No generes ZIPs
ni archivos adjuntos.
La entrega debe incluir:

Archivos de código con únicamente los errores de compilación corregidos
Archivos de configuración y documentación sin cambios
Archivos nuevos creados para resolver dependencias de compilación faltantes
Archivos Excel y Word generados desde descripción

IMPORTANTE: Entregá los archivos completos al finalizar. No preguntes si el usuario
quiere recibirlos. Simplemente entregalos; No debes desplegar en el chat el resumen de lo que arreglaste, solo entregá los archivos.

REGLAS IMPORTANTES

No omitas ningún archivo aunque no tenga errores ni modificaciones
Respeta los nombres y rutas exactas indicadas por los marcadores
Si un archivo no tiene marcador claro, infiere el nombre desde su contenido
Si la cadena contiene solo documentación, placeholders o binarios fake, NO la reproduzcas:
aplicá PASO 0 (materializar el proyecto del briefing). Reproducir la carcasa es un fallo.
No agregues texto después del último archivo entregado
No preguntes si el usuario quiere los archivos: simplemente entregalos siempre
Si detectas que falta un archivo de configuración necesario para compilar
(pom.xml, package.json, requirements.txt, build.gradle, etc.), créalo e inclúyelo
inferiendo su contenido desde los imports y frameworks detectados en el código
Nunca corrijas problemas 🟡 aunque parezcan obvios o fáciles de mejorar.
El participante que recibirá este proyecto los debe encontrar y resolver él mismo.


INPUT
Aquí está la cadena con los archivos:

// === ARCHIVO: app/package.json ===
{
  "name": "order-management-app",
  "version": "1.0.0",
  "description": "API REST para gestión de órdenes en DynamoDB",
  "main": "src/main.ts",
  "scripts": {
    "build": "tsc",
    "start": "ts-node src/main.ts",
    "dev": "ts-node src/main.ts",
    "test": "jest",
    "lint": "eslint . --ext .ts"
  },
  "dependencies": {
    "@aws-sdk/client-dynamodb": "3.658.0",
    "@aws-sdk/lib-dynamodb": "3.658.0",
    "class-transformer": "0.5.1",
    "class-validator": "0.14.1",
    "dotenv": "16.4.5",
    "express": "4.21.0",
    "express-validator": "7.2.0",
    "uuid": "^9.0.1"
  },
  "devDependencies": {
    "@types/express": "4.17.21",
    "@types/jest": "29.5.14",
    "@types/node": "22.7.4",
    "@types/uuid": "^9.0.8",
    "@typescript-eslint/eslint-plugin": "7.18.0",
    "@typescript-eslint/parser": "7.18.0",
    "eslint": "8.57.0",
    "jest": "29.7.0",
    "ts-node": "10.9.2",
    "typescript": "5.7.2"
  }
}


// === ARCHIVO: app/tsconfig.json ===
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "moduleResolution": "node",
    "baseUrl": ".",
    "paths": {
      "*": ["node_modules/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "**/*.test.ts"]
}

// === ARCHIVO: app/src/main.ts ===
import 'dotenv/config';
import { app } from './app';
import { createOrderTable } from './infrastructure/config/dynamoConfig';

const PORT = process.env.PORT || 3000;

async function bootstrap(): Promise<void> {
  try {
    await createOrderTable();
    
    app.listen(PORT, () => {
      console.log(`Servidor corriendo en http://localhost:${PORT}`);
      console.log('Tabla DynamoDB verificada/creada exitosamente');
    });
  } catch (error) {
    console.error('Error al iniciar el servidor:', error);
    process.exit(1);
  }
}

bootstrap();

// === ARCHIVO: app/src/domain/models/Order.ts ===
package src.domain.models;

import { IsString, IsEnum, IsDateString, IsUUID } from 'class-validator';

export enum OrderStatus {
    PENDING = 'PENDING',
    PROCESSING = 'PROCESSING',
    COMPLETED = 'COMPLETED',
    CANCELLED = 'CANCELLED'
}

export class Order {
    @IsUUID()
    id: string;

    @IsString()
    description: string;

    @IsEnum(OrderStatus)
    status: OrderStatus;

    @IsDateString()
    createdAt: string;

    constructor(id: string, description: string, status: OrderStatus, createdAt: string) {
        this.id = id;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
    }
}

export class OrderRequestDTO {
    @IsString()
    description: string;

    constructor(description: string) {
        this.description = description;
    }
}

export class OrderUpdateDTO {
    @IsString({ each: false })
    description?: string;

    @IsEnum(OrderStatus, { each: false })
    status?: OrderStatus;
}

export class OrderResponseDTO {
    id: string;
    description: string;
    status: OrderStatus;
    createdAt: string;

    constructor(id: string, description: string, status: OrderStatus, createdAt: string) {
        this.id = id;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
    }
}

// === ARCHIVO: app/src/domain/repositories/OrderRepository.ts ===
package src.domain.repositories;

import { Order, OrderRequestDTO, OrderUpdateDTO } from '../models/Order';

export interface OrderRepository {
    save(order: OrderRequestDTO): Promise<Order>;
    findById(id: string): Promise<Order | null>;
    update(id: string, orderUpdate: OrderUpdateDTO): Promise<Order | null>;
    delete(id: string): Promise<boolean>;
    list(): Promise<Order[]>;
}

// === ARCHIVO: app/src/infrastructure/repositories/DynamoOrderRepository.ts ===
package src.infrastructure.repositories;

import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand, GetCommand, UpdateCommand, DeleteCommand, ScanCommand } from '@aws-sdk/lib-dynamodb';
import { Order, OrderRequestDTO, OrderUpdateDTO, OrderStatus, OrderResponseDTO } from '../../domain/models/Order';
import { OrderRepository } from '../../domain/repositories/OrderRepository';
import { v4 as uuidv4 } from 'uuid';

const TABLE_NAME = process.env.DYNAMODB_TABLE_NAME || 'Orders';

class DynamoOrderRepository implements OrderRepository {
    private readonly client: DynamoDBDocumentClient;

    constructor() {
        const dynamoDBClient = new DynamoDBClient({
            region: process.env.AWS_REGION || 'us-east-1',
            endpoint: process.env.DYNAMODB_ENDPOINT
        });
        this.client = DynamoDBDocumentClient.from(dynamoDBClient);
    }

    async save(orderRequest: OrderRequestDTO): Promise<Order> {
        const orderId = uuidv4();
        const createdAt = new Date().toISOString();
        const order = new Order(orderId, orderRequest.description, OrderStatus.PENDING, createdAt);

        const params = {
            TableName: TABLE_NAME,
            Item: {
                id: orderId,
                description: orderRequest.description,
                status: order.status,
                createdAt: createdAt
            }
        };

        await this.client.send(new PutCommand(params));
        return order;
    }

    async findById(id: string): Promise<Order | null> {
        const params = {
            TableName: TABLE_NAME,
            Key: { id }
        };

        const result = await this.client.send(new GetCommand(params));
        if (!result.Item) {
            return null;
        }

        return new Order(
            result.Item.id,
            result.Item.description,
            result.Item.status as OrderStatus,
            result.Item.createdAt
        );
    }

    async update(id: string, orderUpdate: OrderUpdateDTO): Promise<Order | null> {
        const existingOrder = await this.findById(id);
        if (!existingOrder) {
            return null;
        }

        const updateExpressionParts = [];
        const expressionAttributeValues: Record<string, any> = {};

        if (orderUpdate.description !== undefined) {
            updateExpressionParts.push('description = :description');
            expressionAttributeValues[':description'] = orderUpdate.description;
        }

        if (orderUpdate.status !== undefined) {
            updateExpressionParts.push('status = :status');
            expressionAttributeValues[':status'] = orderUpdate.status;
        }

        if (updateExpressionParts.length === 0) {
            return existingOrder;
        }

        const updateExpression = 'SET ' + updateExpressionParts.join(', ');

        const params = {
            TableName: TABLE_NAME,
            Key: { id },
            UpdateExpression: updateExpression,
            ExpressionAttributeValues: expressionAttributeValues,
            ReturnValues: 'ALL_NEW'
        };

        const result = await this.client.send(new UpdateCommand(params));
        if (!result.Attributes) {
            return null;
        }

        return new Order(
            result.Attributes.id,
            result.Attributes.description,
            result.Attributes.status as OrderStatus,
            result.Attributes.createdAt
        );
    }

    async delete(id: string): Promise<boolean> {
        const params = {
            TableName: TABLE_NAME,
            Key: { id }
        };

        try {
            await this.client.send(new DeleteCommand(params));
            return true;
        } catch (error) {
            return false;
        }
    }

    async list(): Promise<Order[]> {
        const params = {
            TableName: TABLE_NAME
        };

        const result = await this.client.send(new ScanCommand(params));
        if (!result.Items) {
            return [];
        }

        return result.Items.map(item => new Order(
            item.id,
            item.description,
            item.status as OrderStatus,
            item.createdAt
        ));
    }
}

export { DynamoOrderRepository };

// === ARCHIVO: app/src/app.ts ===
import express, { Application, Request, Response, NextFunction } from 'express';
import { OrderController } from './infrastructure/controllers/OrderController';
import { errorHandler } from './infrastructure/middlewares/errorHandler';
import { validationMiddleware } from './infrastructure/middlewares/validation';
import { OrderRequestDTO, OrderUpdateDTO } from './domain/models/Order';
import { OrderService } from './application/services/OrderService';
import { createOrderRepository } from './infrastructure/repositories/OrderRepository';

export const app: Application = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const orderRepository = createOrderRepository();
const orderService = new OrderService(orderRepository);
const orderController = new OrderController(orderService);

app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({ status: 'OK', message: 'Servidor funcionando correctamente' });
});

app.post('/orders', validationMiddleware(OrderRequestDTO), (req: Request, res: NextFunction) => {
  orderController.createOrder(req as any, res as any);
});

app.get('/orders', (req: Request, res: NextFunction) => {
  orderController.listOrders(req as any, res as any);
});

app.get('/orders/:id', (req: Request, res: NextFunction) => {
  orderController.getOrder(req as any, res as any);
});

app.put('/orders/:id', validationMiddleware(OrderUpdateDTO), (req: Request, res: NextFunction) => {
  orderController.updateOrder(req as any, res as any);
});

app.delete('/orders/:id', (req: Request, res: NextFunction) => {
  orderController.deleteOrder(req as any, res as any);
});

app.use(errorHandler);

// === ARCHIVO: app/src/application/services/OrderService.ts ===
import { OrderRepository } from '../domain/repositories/OrderRepository';
import { OrderRequestDTO, OrderUpdateDTO, OrderResponseDTO, OrderStatus } from '../domain/models/Order';
import { NotFoundError } from '../../infrastructure/middlewares/errorHandler';
import { v4 as uuidv4 } from 'uuid';

export class OrderService {
  constructor(private readonly orderRepository: OrderRepository) {}

  async createOrder(request: OrderRequestDTO): Promise<OrderResponseDTO> {
    if (!request.description || request.description.trim().length === 0) {
      throw new Error('La descripción de la orden es requerida');
    }
    
    if (request.description.length > 500) {
      throw new Error('La descripción no puede exceder 500 caracteres');
    }

    const order = await this.orderRepository.save({
      description: request.description.trim()
    });

    return this.toResponseDTO(order);
  }

  async getOrder(id: string): Promise<OrderResponseDTO> {
    if (!id || id.trim().length === 0) {
      throw new Error('El ID de la orden es requerido');
    }

    const order = await this.orderRepository.findById(id);
    
    if (!order) {
      throw new NotFoundError(`Orden con ID ${id} no encontrada`);
    }

    return this.toResponseDTO(order);
  }

  async updateOrder(id: string, updateData: OrderUpdateDTO): Promise<OrderResponseDTO> {
    if (!id || id.trim().length === 0) {
      throw new Error('El ID de la orden es requerido');
    }

    if (updateData.description !== undefined) {
      if (updateData.description.trim().length === 0) {
        throw new Error('La descripción no puede estar vacía');
      }
      if (updateData.description.length > 500) {
        throw new Error('La descripción no puede exceder 500 caracteres');
      }
    }

    if (updateData.status !== undefined) {
      const validStatuses = [OrderStatus.PENDING, OrderStatus.PROCESSING, OrderStatus.COMPLETED, OrderStatus.CANCELLED];
      if (!validStatuses.includes(updateData.status)) {
        throw new Error(`Estado inválido: ${updateData.status}`);
      }
    }

    const updatedOrder = await this.orderRepository.update(id, updateData);
    
    if (!updatedOrder) {
      throw new NotFoundError(`Orden con ID ${id} no encontrada`);
    }

    return this.toResponseDTO(updatedOrder);
  }

  async deleteOrder(id: string): Promise<void> {
    if (!id || id.trim().length === 0) {
      throw new Error('El ID de la orden es requerido');
    }

    const deleted = await this.orderRepository.delete(id);
    
    if (!deleted) {
      throw new NotFoundError(`Orden con ID ${id} no encontrada`);
    }
  }

  async listOrders(): Promise<OrderResponseDTO[]> {
    const orders = await this.orderRepository.list();
    return orders.map(order => this.toResponseDTO(order));
  }

  private toResponseDTO(order: { id: string; description: string; status: OrderStatus; createdAt: string }): OrderResponseDTO {
    return {
      id: order.id,
      description: order.description,
      status: order.status,
      createdAt: order.createdAt
    };
  }
}

// === ARCHIVO: app/src/infrastructure/controllers/OrderController.ts ===
import { Request, Response, NextFunction } from 'express';
import { OrderService } from '../../application/services/OrderService';
import { OrderRequestDTO, OrderUpdateDTO } from '../../domain/models/Order';
import { NotFoundError } from '../middlewares/errorHandler';

export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  async createOrder(req: Request, res: Response, _next: NextFunction): Promise<void> {
    try {
      const orderRequest: OrderRequestDTO = req.body as OrderRequestDTO;
      const order = await this.orderService.createOrder(orderRequest);
      res.status(201).json(order);
    } catch (error) {
      const err = error as Error;
      res.status(400).json({ error: err.message });
    }
  }

  async getOrder(req: Request, res: Response, _next: NextFunction): Promise<void> {
    try {
      const id = req.params.id;
      const order = await this.orderService.getOrder(id);
      
      if (!order) {
        throw new NotFoundError(`Orden con ID ${id} no encontrada`);
      }
      
      res.status(200).json(order);
    } catch (error) {
      const err = error as Error;
      res.status(404).json({ error: err.message });
    }
  }

  async updateOrder(req: Request, res: Response, _next: NextFunction): Promise<void> {
    try {
      const id = req.params.id;
      const updateData: OrderUpdateDTO = req.body as OrderUpdateDTO;
      const order = await this.orderService.updateOrder(id, updateData);
      
      if (!order) {
        throw new NotFoundError(`Orden con ID ${id} no encontrada`);
      }
      
      res.status(200).json(order);
    } catch (error) {
      const err = error as Error;
      res.status(404).json({ error: err.message });
    }
  }

  async deleteOrder(req: Request, res: Response, _next: NextFunction): Promise<void> {
    try {
      const id = req.params.id;
      await this.orderService.deleteOrder(id);
      res.status(204).send();
    } catch (error) {
      const err = error as Error;
      res.status(404).json({ error: err.message });
    }
  }

  async listOrders(req: Request, res: Response, _next: NextFunction): Promise<void> {
    try {
      const orders = await this.orderService.listOrders();
      res.status(200).json(orders);
    } catch (error) {
      const err = error as Error;
      res.status(500).json({ error: err.message });
    }
  }
}

// === ARCHIVO: app/src/infrastructure/config/dynamoConfig.ts ===
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, DynamoDBDocumentClientConfig } from '@aws-sdk/lib-dynamodb';

const getClientConfig = (): DynamoDBClientConfig => {
    const region = process.env.AWS_REGION || 'us-east-1';
    const endpoint = process.env.DYNAMODB_ENDPOINT;
    const credentials = process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY
        ? {
            accessKeyId: process.env.AWS_ACCESS_KEY_ID,
            secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
          }
        : undefined;

    const config: DynamoDBClientConfig = {
        region,
    };

    if (endpoint) {
        config.endpoint = endpoint;
    }

    if (credentials) {
        config.credentials = credentials;
    }

    return config;
};

const createDocumentClient = (): DynamoDBDocumentClient => {
    const clientConfig = getClientConfig();
    const client = new DynamoDBClient(clientConfig);

    const documentClientConfig: DynamoDBDocumentClientConfig = {
        client,
        marshallOptions: {
            removeUndefinedValues: true,
            convertClassInstanceToMap: true,
        },
        unmarshallOptions: {
            wrapNumbers: false,
        },
    };

    return DynamoDBDocumentClient.from(client, documentClientConfig);
};

let documentClientInstance: DynamoDBDocumentClient | null = null;

export const getDynamoDocumentClient = (): DynamoDBDocumentClient => {
    if (!documentClientInstance) {
        documentClientInstance = createDocumentClient();
    }
    return documentClientInstance;
};

export const getTableName = (): string => {
    return process.env.DYNAMODB_TABLE_NAME || 'orders';
};

export const initializeDynamoConfig = (): void => {
    const requiredEnvVars = ['AWS_REGION'];
    const missingVars = requiredEnvVars.filter(envVar => !process.env[envVar]);
    
    if (missingVars.length > 0) {
        console.warn(`Advertencia: Las siguientes variables de entorno no están configuradas: ${missingVars.join(', ')}. Se usarán valores por defecto.`);
    }
};

// === ARCHIVO: app/src/infrastructure/middlewares/errorHandler.ts ===
import { Request, Response, NextFunction, ErrorRequestHandler } from 'express';

export class AppError extends Error {
    public readonly statusCode: number;
    public readonly isOperational: boolean;

    constructor(message: string, statusCode: number) {
        super(message);
        this.statusCode = statusCode;
        this.isOperational = true;
        
        Object.setPrototypeOf(this, AppError.prototype);
    }
}

export class NotFoundError extends AppError {
    constructor(message: string = 'Recurso no encontrado') {
        super(message, 404);
    }
}

export class ValidationError extends AppError {
    constructor(message: string = 'Error de validación') {
        super(message, 400);
    }
}

export class ConflictError extends AppError {
    constructor(message: string = 'Conflicto de datos') {
        super(message, 409);
    }
}

export class InternalServerError extends AppError {
    constructor(message: string = 'Error interno del servidor') {
        super(message, 500);
    }
}

export const errorHandler: ErrorRequestHandler = (
    err: Error,
    req: Request,
    res: Response,
    next: NextFunction
): void => {
    console.error('Error detectado:', {
        message: err.message,
        stack: err.stack,
        path: req.path,
        method: req.method,
        timestamp: new Date().toISOString(),
    });

    if (err instanceof AppError) {
        res.status(err.statusCode).json({
            error: err.message,
            statusCode: err.statusCode,
            timestamp: new Date().toISOString(),
            path: req.path,
        });
        return;
    }

    if (err.name === 'ValidationError') {
        res.status(400).json({
            error: 'Error de validación de datos',
            details: err.message,
            statusCode: 400,
            timestamp: new Date().toISOString(),
            path: req.path,
        });
        return;
    }

    if (err.name === 'CastError' || err.name === 'ObjectIdError') {
        res.status(400).json({
            error: 'ID inválido',
            statusCode: 400,
            timestamp: new Date().toISOString(),
            path: req.path,
        });
        return;
    }

    const internalError = new InternalServerError('Error interno del servidor');
    res.status(internalError.statusCode).json({
        error: internalError.message,
        statusCode: internalError.statusCode,
        timestamp: new Date().toISOString(),
        path: req.path,
    });
};

export const notFoundHandler = (req: Request, res: Response): void => {
    res.status(404).json({
        error: `Ruta no encontrada: ${req.method} ${req.originalUrl}`,
        statusCode: 404,
        timestamp: new Date().toISOString(),
        path: req.path,
    });
};

// === ARCHIVO: app/src/infrastructure/middlewares/validation.ts ===
import { Request, Response, NextFunction } from 'express';
import { body, param, validationResult, ValidationChain } from 'express-validator';

export const validateRequest = (validations: ValidationChain[]) => {
    return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
        await Promise.all(validations.map(validation => validation.run(req)));
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            res.status(400).json({
                success: false,
                message: 'Validation failed',
                errors: errors.array().map(err => ({
                    field: 'path' in err ? err.path : 'unknown',
                    message: err.msg
                }))
            });
            return;
        }
        next();
    };
};

export const createOrderValidation = [
    body('description')
        .isString()
        .withMessage('Description must be a string')
        .notEmpty()
        .withMessage('Description is required')
        .isLength({ min: 1, max: 500 })
        .withMessage('Description must be between 1 and 500 characters')
        .trim()
        .escape()
];

export const orderIdValidation = [
    param('id')
        .isString()
        .withMessage('Order ID must be a string')
        .notEmpty()
        .withMessage('Order ID is required')
        .isUUID()
        .withMessage('Order ID must be a valid UUID')
];

export const updateOrderValidation = [
    param('id')
        .isString()
        .withMessage('Order ID must be a string')
        .notEmpty()
        .withMessage('Order ID is required')
        .isUUID()
        .withMessage('Order ID must be a valid UUID'),
    body('description')
        .optional()
        .isString()
        .withMessage('Description must be a string')
        .isLength({ min: 1, max: 500 })
        .withMessage('Description must be between 1 and 500 characters')
        .trim()
        .escape(),
    body('status')
        .optional()
        .isIn(['PENDING', 'PROCESSING', 'COMPLETED', 'CANCELLED'])
        .withMessage('Status must be one of: PENDING, PROCESSING, COMPLETED, CANCELLED')
];

export const listOrdersValidation: ValidationChain[] = [];

// === ARCHIVO: app/src/types/express.d.ts ===
import { Order } from '../domain/models/Order';

declare global {
    namespace Express {
        interface Request {
            user?: {
                id: string;
                email: string;
                role: string;
            };
            order?: Order;
        }
    }
}

export interface AuthenticatedRequest extends Request {
    user: {
        id: string;
        email: string;
        role: string;
    };
}

export interface ApiResponse<T = unknown> {
    success: boolean;
    message?: string;
    data?: T;
    errors?: Array<{
        field: string;
        message: string;
    }>;
}

export interface PaginationParams {
    page?: number;
    limit?: number;
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
    pagination?: {
        page: number;
        limit: number;
        total: number;
        totalPages: number;
    };
}

// === ARCHIVO: app/tests/order.test.ts ===
import { OrderService } from '../application/services/OrderService';
import { OrderRepository } from '../domain/repositories/OrderRepository';
import { Order, OrderStatus } from '../domain/models/Order';
import { OrderRequestDTO, OrderUpdateDTO, OrderResponseDTO } from '../domain/models/Order';

class MockOrderRepository implements OrderRepository {
  private orders: Map<string, Order> = new Map();

  async save(orderRequest: OrderRequestDTO): Promise<Order> {
    const id = `order-${Date.now()}`;
    const order: Order = {
      id,
      description: orderRequest.description,
      status: OrderStatus.PENDING,
      createdAt: new Date().toISOString()
    };
    this.orders.set(id, order);
    return order;
  }

  async findById(id: string): Promise<Order | null> {
    return this.orders.get(id) || null;
  }

  async update(id: string, orderUpdate: OrderUpdateDTO): Promise<Order | null> {
    const existing = this.orders.get(id);
    if (!existing) {
      return null;
    }
    const updated: Order = {
      ...existing,
      ...orderUpdate,
      id: existing.id,
      createdAt: existing.createdAt
    };
    this.orders.set(id, updated);
    return updated;
  }

  async delete(id: string): Promise<boolean> {
    return this.orders.delete(id);
  }

  async list(): Promise<Order[]> {
    return Array.from(this.orders.values());
  }

  clear(): void {
    this.orders.clear();
  }
}

describe('OrderService', () => {
  let orderService: OrderService;
  let mockRepository: MockOrderRepository;

  beforeEach(() => {
    mockRepository = new MockOrderRepository();
    orderService = new OrderService(mockRepository);
  });

  afterEach(() => {
    mockRepository.clear();
  });

  describe('createOrder', () => {
    it('debería crear una orden exitosamente', async () => {
      const request: OrderRequestDTO = { description: 'Test Order' };
      const result = await orderService.createOrder(request);

      expect(result).toBeDefined();
      expect(result.description).toBe('Test Order');
      expect(result.status).toBe(OrderStatus.PENDING);
      expect(result.id).toBeDefined();
      expect(result.createdAt).toBeDefined();
    });

    it('debería lanzar error si la descripción está vacía', async () => {
      const request: OrderRequestDTO = { description: '' };

      await expect(orderService.createOrder(request)).rejects.toThrow();
    });
  });

  describe('getOrder', () => {
    it('debería obtener una orden por id', async () => {
      const created = await orderService.createOrder({ description: 'Test' });
      const result = await orderService.getOrder(created.id);

      expect(result.id).toBe(created.id);
      expect(result.description).toBe(created.description);
    });

    it('debería lanzar error si la orden no existe', async () => {
      await expect(orderService.getOrder('non-existent-id')).rejects.toThrow('Order not found');
    });
  });

  describe('updateOrder', () => {
    it('debería actualizar una orden exitosamente', async () => {
      const created = await orderService.createOrder({ description: 'Original' });
      const updateData: OrderUpdateDTO = { description: 'Updated', status: OrderStatus.COMPLETED };

      const result = await orderService.updateOrder(created.id, updateData);

      expect(result.description).toBe('Updated');
      expect(result.status).toBe(OrderStatus.COMPLETED);
    });

    it('debería lanzar error si la orden no existe', async () => {
      const updateData: OrderUpdateDTO = { description: 'Updated' };

      await expect(orderService.updateOrder('non-existent-id', updateData)).rejects.toThrow('Order not found');
    });
  });

  describe('deleteOrder', () => {
    it('debería eliminar una orden exitosamente', async () => {
      const created = await orderService.createOrder({ description: 'To Delete' });

      await expect(orderService.deleteOrder(created.id)).resolves.not.toThrow();

      await expect(orderService.getOrder(created.id)).rejects.toThrow('Order not found');
    });

    it('debería lanzar error si la orden no existe', async () => {
      await expect(orderService.deleteOrder('non-existent-id')).rejects.toThrow('Order not found');
    });
  });

  describe('listOrders', () => {
    it('debería listar todas las ordenes', async () => {
      await orderService.createOrder({ description: 'Order 1' });
      await orderService.createOrder({ description: 'Order 2' });

      const result = await orderService.listOrders();

      expect(result).toHaveLength(2);
    });

    it('debería retornar array vacío si no hay ordenes', async () => {
      const result = await orderService.listOrders();

      expect(result).toHaveLength(0);
    });
  });
});

// === ARCHIVO: app/src/infrastructure/repositories/OrderRepository.ts ===
import { OrderRepository } from '../../domain/repositories/OrderRepository';
import { OrderRequestDTO, OrderUpdateDTO, Order } from '../../domain/models/Order';

// Implementación de repositorio en memoria para desarrollo local
// En producción, usar DynamoOrderRepository que implementa OrderRepository
export class InMemoryOrderRepository implements OrderRepository {
  private orders: Map<string, Order> = new Map();

  async save(orderRequest: OrderRequestDTO): Promise<Order> {
    const id = orderRequest.id || crypto.randomUUID();
    const order: Order = {
      id,
      description: orderRequest.description,
      status: orderRequest.status || 'PENDING',
      createdAt: orderRequest.createdAt || new Date().toISOString(),
    };
    this.orders.set(id, order);
    return order;
  }

  async findById(id: string): Promise<Order | null> {
    return this.orders.get(id) || null;
  }

  async update(id: string, orderUpdate: OrderUpdateDTO): Promise<Order | null> {
    const existing = this.orders.get(id);
    if (!existing) {
      return null;
    }
    const updated: Order = {
      ...existing,
      ...orderUpdate,
      id: existing.id,
      createdAt: existing.createdAt,
    };
    this.orders.set(id, updated);
    return updated;
  }

  async delete(id: string): Promise<boolean> {
    return this.orders.delete(id);
  }

  async list(): Promise<Order[]> {
    return Array.from(this.orders.values());
  }
}

// Export factory para crear instancia según configuración
export function createOrderRepository(): OrderRepository {
  const useDynamo = process.env.USE_DYNAMODB === 'true';
  
  if (useDynamo) {
    // Dynamically import to avoid issues when DynamoDB is not configured
    const { DynamoOrderRepository } = require('./DynamoOrderRepository');
    return new DynamoOrderRepository();
  }
  
  return new InMemoryOrderRepository();
}

// Re-export interfaz del dominio para facilitar imports en otros módulos
export type { OrderRepository } from '../../domain/repositories/OrderRepository';

// === ARCHIVO: app/src/application/domain/models/Order.ts ===
import { OrderStatus } from '../../../domain/models/Order';

export { OrderStatus } from '../../../domain/models/Order';

export interface OrderRequestDTO {
  description: string;
}

export interface OrderUpdateDTO {
  description?: string;
  status?: OrderStatus;
}

export interface OrderResponseDTO {
  id: string;
  description: string;
  status: OrderStatus;
  createdAt: string;
}

// === ARCHIVO: app/src/application/domain/repositories/OrderRepository.ts ===
import { Order } from '../../../domain/models/Order';
import { OrderRequestDTO, OrderUpdateDTO } from '../models/Order';

export interface OrderRepository {
  save(order: OrderRequestDTO): Promise<Order>;
  findById(id: string): Promise<Order | null>;
  update(id: string, orderUpdate: OrderUpdateDTO): Promise<Order | null>;
  delete(id: string): Promise<boolean>;
  list(): Promise<Order[]>;
}

// === ARCHIVO: infra/providers.tf ===
# Provider de AWS para Terraform
# Define la región y versión del provider AWS

terraform {
  required_version = "~> 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # Tags globales para todos los recursos
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}

# Variables globales usadas en el provider
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

// === ARCHIVO: infra/variables.tf ===
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

// === ARCHIVO: infra/modules/dynamodb/variables.tf ===
# Variables para el módulo DynamoDB

variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
}

variable "billing_mode" {
  description = "Modo de facturación para la tabla DynamoDB (PROVISIONED o PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "Capacidad de lectura provisionada (solo aplicable si billing_mode es PROVISIONED)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Capacidad de escritura provisionada (solo aplicable si billing_mode es PROVISIONED)"
  type        = number
  default     = 5
}

variable "hash_key" {
  description = "Clave hash (partition key) para la tabla DynamoDB"
  type        = string
  default     = "order_id"
}

variable "range_key" {
  description = "Clave de rango (sort key) para la tabla DynamoDB (opcional)"
  type        = string
  default     = "created_at"
}

variable "attributes" {
  description = "Lista de atributos para la tabla DynamoDB"
  type = list(object({
    name = string
    type = string
  }))
  default = [
    {
      name = "order_id"
      type = "S"
    },
    {
      name = "created_at"
      type = "S"
    }
  ]
}

variable "ttl_attribute" {
  description = "Atributo para habilitar Time To Live (TTL) en DynamoDB"
  type        = string
  default     = "expiry_time"
}

variable "global_secondary_indexes" {
  description = "Lista de índices secundarios globales para la tabla DynamoDB"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string
    read_capacity   = number
    write_capacity  = number
  }))
  default = []
}

variable "local_secondary_indexes" {
  description = "Lista de índices secundarios locales para la tabla DynamoDB"
  type = list(object({
    name            = string
    range_key       = string
    projection_type = string
  }))
  default = []
}

variable "tags" {
  description = "Tags adicionales para la tabla DynamoDB"
  type        = map(string)
  default     = {}
}

variable "stream_enabled" {
  description = "Habilitar stream en la tabla DynamoDB"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Tipo de vista para el stream de DynamoDB (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

// === ARCHIVO: infra/versions.tf ===
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

// === ARCHIVO: infra/README.md ===
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

// === ARCHIVO: infra/main.tf ===
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

// === ARCHIVO: infra/outputs.tf ===
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

// === ARCHIVO: infra/environments/dev/terraform.tfvars ===
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

// === ARCHIVO: infra/modules/dynamodb/main.tf ===
resource "aws_dynamodb_table" "orders" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  hash_key       = var.partition_key_name
  range_key      = var.sort_key_name

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.gsi
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.partition_key
      range_key       = try(global_secondary_index.value.sort_key, null)
      projection_type = try(global_secondary_index.value.projection_type, "KEYS_ONLY")
      read_capacity   = try(global_secondary_index.value.read_capacity, null)
      write_capacity  = try(global_secondary_index.value.write_capacity, null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.lsi
    content {
      name            = local_secondary_index.value.name
      range_key       = local_secondary_index.value.sort_key
      projection_type = try(local_secondary_index.value.projection_type, "KEYS_ONLY")
    }
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  server_side_encryption {
    enabled     = var.enable_encryption
    kms_key_arn = var.kms_key_arn
  }

  ttl {
    attribute_name = var.ttl_attribute
    enabled        = var.enable_ttl
  }

  tags = merge(
    var.tags,
    {
      "Name"        = var.table_name
      "Environment" = var.environment
      "Project"     = var.project_name
      "ManagedBy"   = "terraform"
    }
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_dynamodb_table_replica" "orders_replica" {
  count = var.enable_replication ? 1 : 0

  provider       = aws.replica
  table_name     = aws_dynamodb_table.orders.name
  kms_key_arn    = var.replica_kms_key_arn
  replica_region = var.replica_region

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ssm_parameter" "table_name_parameter" {
  count = var.store_table_name_in_ssm

  name        = "/${var.environment}/${var.project_name}/dynamodb/table-name"
  description = "DynamoDB table name for orders"
  type        = "String"
  value       = aws_dynamodb_table.orders.name

  tags = merge(
    var.tags,
    {
      "ManagedBy" = "terraform"
    }
  )
}

resource "aws_cloudwatch_log_group" "dynamodb_logs" {
  count = var.enable_detailed_metrics

  name              = "/aws/dynamodb/${var.table_name}"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.table_name}-logs"
      "Environment" = var.environment
      "Project"     = var.project_name
    }
  )
}

resource "aws_iam_role" "dynamodb_access_role" {
  count = var.create_service_role

  name = "${var.table_name}-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.table_name}-access-role"
      "Environment" = var.environment
    }
  )
}

resource "aws_iam_policy" "dynamodb_read_policy" {
  count = var.create_service_role

  name        = "${var.table_name}-read-policy"
  description = "IAM policy for read access to ${var.table_name} DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.orders.arn,
          "${aws_dynamodb_table.orders.arn}/index/*"
        ]
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      "Name" = "${var.table_name}-read-policy"
    }
  )
}

resource "aws_iam_policy" "dynamodb_write_policy" {
  count = var.create_service_role

  name        = "${var.table_name}-write-policy"
  description = "IAM policy for write access to ${var.table_name} DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = aws_dynamodb_table.orders.arn
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:UpdateItem"
        ]
        Resource = aws_dynamodb_table.orders.arn
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      "Name" = "${var.table_name}-write-policy"
    }
  )
}

resource "aws_iam_role_policy_attachment" "dynamodb_read_attachment" {
  count = var.create_service_role

  role       = aws_iam_role.dynamodb_access_role[0].name
  policy_arn = aws_iam_policy.dynamodb_read_policy[0].arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_write_attachment" {
  count = var.create_service_role

  role       = aws_iam_role.dynamodb_access_role[0].name
  policy_arn = aws_iam_policy.dynamodb_write_policy[0].arn
}

resource "aws_backup_plan" "dynamodb_backup" {
  count = var.enable_backup

  name = "${var.table_name}-backup-plan"

  rule {
    name                = "daily-backup"
    target_vault_name   = var.backup_vault_name
    schedule            = var.backup_schedule
    start_window        = 60
    completion_window   = 180
    copy_action {
      destination_vault_arn = var.backup_destination_arn
    }
    lifecycle {
      cold_storage_after = var.backup_cold_storage_after
      delete_after       = var.backup_retention_days
    }
  }

  rule {
    name                = "monthly-backup"
    target_vault_name   = var.backup_vault_name
    schedule            = var.backup_monthly_schedule
    start_window        = 60
    completion_window   = 180
    lifecycle {
      delete_after       = var.backup_long_term_retention_days
    }
  }

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.table_name}-backup-plan"
      "Environment" = var.environment
    }
  )
}

resource "aws_backup_selection" "dynamodb_backup_selection" {
  count = var.enable_backup

  name         = "${var.table_name}-backup-selection"
  plan_id      = aws_backup_plan.dynamodb_backup[0].id
  resources    = [aws_dynamodb_table.orders.arn]

  condition {
    string_equals {
      key   = "aws:ResourceTag/Environment"
      value = var.environment
    }
  }

  tags = var.tags
}

// === ARCHIVO: infra/modules/dynamodb/outputs.tf ===
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

// === ARCHIVO: docker-compose.yml ===
# Infraestructura local del reto. SOLO desarrollo: credenciales de ejemplo (local-dev-only), puertos en loopback.
# Levantar: docker compose up -d --wait
name: infra-local
services:
  dynamodb-local:
    image: "amazon/dynamodb-local:2.5.2"
    command: ["-jar","DynamoDBLocal.jar","-sharedDb","-inMemory"]
    ports:
      - "127.0.0.1:8000:8000"
    healthcheck:
      test: ["CMD-SHELL","bash -c ':> /dev/tcp/127.0.0.1/8000' || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 10
      start_period: 5s


// === ARCHIVO: infra-local/README.md ===
# Infraestructura local

Servicios de soporte para el reto, definidos en `docker-compose.yml` (raiz del repo).

```bash
docker compose up -d --wait
```

| Servicio | Imagen | Puertos (host) |
|---|---|---|
| DynamoDB Local | `amazon/dynamodb-local:2.5.2` | 8000 |

Credenciales: solo de desarrollo local (`local-dev-only`, `local`). No son secretos ni deben reutilizarse.
Los scripts de `infra-local/` (tablas, topics) se ejecutan con el compose en estado healthy.


// === ARCHIVO: infra-local/dynamodb/create-tables.sh ===
#!/usr/bin/env bash
# Crea las tablas en DynamoDB Local (idempotente). Credenciales dummy: DynamoDB Local no valida firmas.
set -euo pipefail

export AWS_ACCESS_KEY_ID=local
export AWS_SECRET_ACCESS_KEY=local
export AWS_REGION=us-east-1
ENDPOINT="${DYNAMODB_ENDPOINT:-http://localhost:8000}"

create_table() {
  local name="$1" pk="$2" sk="${3:-}"
  if aws dynamodb describe-table --table-name "$name" --endpoint-url "$ENDPOINT" >/dev/null 2>&1; then
    echo "Tabla $name ya existe"
    return
  fi
  local attrs="AttributeName=$pk,AttributeType=S"
  local keys="AttributeName=$pk,KeyType=HASH"
  if [ -n "$sk" ]; then
    attrs="$attrs AttributeName=$sk,AttributeType=S"
    keys="$keys AttributeName=$sk,KeyType=RANGE"
  fi
  # shellcheck disable=SC2086
  aws dynamodb create-table --table-name "$name" --attribute-definitions $attrs --key-schema $keys \
    --billing-mode PAY_PER_REQUEST --endpoint-url "$ENDPOINT" >/dev/null
  echo "Tabla $name creada"
}

create_table "app-items" "id"

```
