# Implementación de CRUD de ordenes en DynamoDB

El sistema debe permitir la gestión de ordenes en una tabla DynamoDB a través de una API REST. Las operaciones CRUD (Crear, Leer, Actualizar, Eliminar) deben ser implementadas para manejar ordenes en el sistema de gestión de inventario de una tienda en línea. Cada orden debe tener un identificador único, descripción, estado y fecha de creación. El sistema debe manejar correctamente los casos de error y validación, como ordenes duplicadas o intentos de actualizar ordenes inexistentes.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | CRUD de ordenes sobre DynamoDB |
| **Nivel** | advanced-l2 |
| **Tipo** | practical |
| **Tiempo estimado** | 8 horas |

## Fases del Reto

### Fase 0: Configuración del Proyecto

**Objetivo:** Obtener el proyecto base funcional enviando el Código Base a un asistente de IA, que lo analizará, corregirá errores y entregará cada archivo con su ruta.

**Tiempo estimado:** 15-30 minutos

**Instrucciones:**

- Asegúrate de tener instalado para ejecutar el proyecto: Node.js 18+, npm, VS Code o similar.
- Copia todo el contenido del campo **Código Base** de este reto — incluyendo el texto de instrucciones que aparece al inicio.
- Abre un asistente de IA (Claude en claude.ai, ChatGPT o Gemini — se recomienda Claude), pega el contenido copiado en el chat y envíalo.
- El asistente analizará los archivos, corregirá errores y entregará cada archivo con su ruta. Guárdalos en la carpeta donde quieras trabajar, respetando las rutas.
- Ejecuta `npm install && npm run build` (o `npm start`). Si no hay errores, estás listo.

**Entregable:** El proyecto compila/arranca sin errores.

<details>
<summary>Pistas de conocimiento</summary>

- Copia el Código Base completo incluyendo el texto de instrucciones al inicio — esas instrucciones le indican al asistente exactamente qué hacer con los archivos.
- Si el asistente no entrega todos los archivos al terminar el análisis, escríbele: "entrégame todos los archivos con su ruta".
- Si el proyecto tiene errores al arrancar, comparte el mensaje de error con el mismo asistente para que lo corrija.

</details>

### Fase 1: Configuración inicial y creación de la tabla DynamoDB

**Objetivo:** Configurar el entorno de desarrollo y crear la tabla DynamoDB para almacenar las ordenes.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Configura tu entorno de desarrollo para trabajar con DynamoDB.
- Crea una tabla DynamoDB con las columnas necesarias para almacenar las ordenes.
- Verifica que la tabla se ha creado correctamente y que puedes acceder a ella.

**Entregable:** Tabla DynamoDB creada y configurada para almacenar ordenes.

<details>
<summary>Pistas de conocimiento</summary>

- Utiliza Terraform para configurar y gestionar la infraestructura.
- Recuerda que cada orden debe tener un identificador único, descripción, estado y fecha de creación.

</details>

### Fase 2: Implementación de la operación Crear

**Objetivo:** Implementar la funcionalidad para crear nuevas ordenes en la tabla DynamoDB.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Desarrolla la lógica para crear una nueva orden en la tabla DynamoDB.
- Maneja correctamente los casos de error, como intentos de crear ordenes duplicadas.
- Verifica que la orden se ha creado correctamente y que puedes acceder a ella.

**Entregable:** Funcionalidad para crear nuevas ordenes en DynamoDB, con manejo de errores y validación.

<details>
<summary>Pistas de conocimiento</summary>

- Recuerda manejar los casos de error y validación correctamente.
- Verifica que la orden se ha creado correctamente y que puedes acceder a ella.

</details>

### Fase 3: Implementación de las operaciones Leer, Actualizar y Eliminar

**Objetivo:** Implementar las funcionalidades para leer, actualizar y eliminar ordenes en la tabla DynamoDB.

**Tiempo estimado:** 4 horas

**Instrucciones:**

- Desarrolla la lógica para leer, actualizar y eliminar ordenes en la tabla DynamoDB.
- Maneja correctamente los casos de error, como intentos de actualizar o eliminar ordenes inexistentes.
- Verifica que las operaciones se realizan correctamente y que puedes acceder a las ordenes actualizadas o eliminadas.

**Entregable:** Funcionalidades para leer, actualizar y eliminar ordenes en DynamoDB, con manejo de errores y validación.

<details>
<summary>Pistas de conocimiento</summary>

- Recuerda manejar los casos de error y validación correctamente.
- Verifica que las operaciones se realizan correctamente y que puedes acceder a las ordenes actualizadas o eliminadas.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué es una orden en el contexto de este reto?
- **paraQueSirve**: ¿Para qué sirve la tabla DynamoDB en este reto?
- **comoSeUsa**: ¿Cómo se usa la API REST para interactuar con la tabla DynamoDB?
- **erroresComunes**: ¿Cuáles son los errores comunes que se deben manejar al implementar las operaciones CRUD?

## Criterios de Evaluacion

- Configuración correcta del entorno de desarrollo y creación de la tabla DynamoDB.
- Implementación correcta de la operación Crear con manejo de errores y validación.
- Implementación correcta de las operaciones Leer, Actualizar y Eliminar con manejo de errores y validación.

## Como trabajar con un asistente de IA

Hay dos caminos, elegi uno:

- **AGENTS.md** (recomendado) — instrucciones nativas del repo. Abri esta carpeta con tu agente local (Claude Code, Cursor, Codex, Copilot, Gemini) y las carga solo. Sabe que archivos faltan y con que comando se verifica, y completa el scaffold escribiendo en disco.
- **PROMPT_MEJORA.md** — para copiar y pegar en un chat (claude.ai, ChatGPT) si no tenes un agente en el IDE. Declara lo mismo que AGENTS.md; los archivos que te devuelva el chat los guardas en esta carpeta respetando las rutas.

Ninguno de los dos resuelve las fases del reto: eso es tu trabajo.

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

## Verificacion

El proyecto esta listo para trabajar cuando este comando corre sin errores:

```bash
(cd app && npm install && npm run build) && (cd infra && terraform fmt -check -recursive && terraform init -backend=false && terraform validate) && docker compose config -q
```

---

*Reto generado automaticamente por Challenge Generator - Pragma*
