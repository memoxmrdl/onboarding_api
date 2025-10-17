# Onboarding API

API REST para el sistema de onboarding de empleados. Esta aplicación proporciona endpoints para la autenticación y gestión de empleados con validaciones robustas y arquitectura escalable.

## 🚀 Instrucciones para levantar el proyecto

### Prerrequisitos

- **Ruby 3.4.5** (verificar con `ruby --version`)
- **PostgreSQL 9.3+** (verificar con `psql --version`)
- **Bundler** (instalar con `gem install bundler`)

### Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd onboarding_api
   ```

2. **Instalar dependencias**
   ```bash
   bundle install
   ```

3. **Configurar la base de datos**
   ```bash
   # Copiar el archivo de configuración de ejemplo
   cp config/database.yml.example config/database.yml

   # Editar config/database.yml con tus credenciales de PostgreSQL
   # (opcional si usas configuración por defecto)
   ```

4. **Crear y configurar las bases de datos**
   ```bash
   # Crear las bases de datos
   rails db:create

   # Ejecutar migraciones
   rails db:migrate

   # (Opcional) Cargar datos de prueba
   rails db:seed
   ```

5. **Levantar el servidor**
   ```bash
   bin/rails server
   ```

   La API estará disponible en `http://localhost:3000`

## 🧪 Ejecutar tests

```bash
# Ejecutar toda la suite de tests
bundle exec rspec
```

## 📚 Endpoints disponibles

### Autenticación
- `POST /v1/auth/login` - Generar token de autenticación

### Empleados
- `GET /v1/employees` - Listar empleados
- `POST /v1/employees` - Crear empleado
- `GET /v1/employees/:id` - Obtener empleado
- `PUT /v1/employees/:id` - Actualizar empleado
- `DELETE /v1/employees/:id` - Eliminar empleado


## 🏗️ Decisiones técnicas

### Arquitectura

**API REST con versionado**: Se implementó un sistema de versionado (`v1`) para mantener compatibilidad hacia atrás y facilitar futuras actualizaciones.

**Separación de responsabilidades**:
- **Controllers**: Manejo de requests/responses y autenticación
- **Services**: Lógica de negocio (ej: `AuthenticationService`)
- **Contracts**: Validación de entrada con `dry-validation`
- **Models**: Validaciones de datos y relaciones

### Autenticación y Seguridad

**JWT (JSON Web Tokens)**:
- Implementación con `jwt` gem
- Tokens con expiración de 1 hora
- Algoritmo HS256 para firma
- Secret key basado en `Rails.application.secret_key_base`

**Middleware de autenticación**:
- `BaseController` con `before_action :authenticate_token`
- Validación automática en todos los endpoints protegidos
- Manejo centralizado de errores de autenticación

### Validación de datos

**Doble capa de validación**:
1. **Contracts (dry-validation)**: Validación de entrada en el controlador
2. **Model validations**: Validación a nivel de modelo ActiveRecord

**Validaciones implementadas**:
- Email: formato válido y unicidad
- Teléfono: formato internacional (+1234567890) y longitud (10-15 caracteres)
- Fecha de nacimiento: formato ISO8601 (YYYY-MM-DD)
- Campos requeridos: first_name, last_name, email, date_of_birth, phone_number

### Base de datos

**PostgreSQL**:
- Base de datos robusta para aplicaciones empresariales
- Índices únicos en email para optimizar consultas
- Migraciones versionadas para control de esquema

**Estructura de empleados**:
```sql
employees:
- id (primary key)
- first_name (string, not null)
- last_name (string, not null)
- email (string, not null, unique)
- date_of_birth (date, not null)
- phone_number (string, not null)
- registration_complete (datetime, nullable)
- created_at, updated_at (timestamps)
```

### Testing

- **RSpec**: Framework de testing con sintaxis descriptiva
- **FactoryBot**: Generación de datos de prueba
- **Shoulda Matchers**: Matchers para validaciones de ActiveRecord
- **Database Cleaner**: Limpieza automática entre tests

### Manejo de errores

**Respuestas consistentes**:
- Formato JSON estandarizado para errores
- Códigos HTTP apropiados
- Mensajes descriptivos con atributos específicos

**Error handling centralizado**:
- `ResponseHandlerErrors` concern para parsing de errores
- Soporte para errores de ActiveRecord y dry-validation
- Estructura de error: `{ attribute: string, message: string }`

### Dependencias principales

- **Rails 8.0.3**: Framework web moderno
- **PostgreSQL**: Base de datos robusta
- **JWT**: Autenticación stateless
- **dry-validation**: Validación de entrada
- **jbuilder**: Serialización JSON
- **RSpec**: Testing framework
- **FactoryBot**: Test data generation

### Escalabilidad y mantenibilidad

**Modularización**:
- Namespaces por versión (`V1::`)
- Concerns para funcionalidad compartida
- Services para lógica de negocio compleja

**Configuración flexible**:
- Variables de entorno para configuración
- Diferentes entornos (development, test, production)
- Configuración de CORS para integración frontend

Esta arquitectura permite escalar horizontalmente, mantener código limpio y facilitar el desarrollo de nuevas funcionalidades manteniendo la compatibilidad hacia atrás.
