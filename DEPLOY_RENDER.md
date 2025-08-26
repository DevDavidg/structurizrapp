# 🚀 Despliegue en Render

## Pasos para Desplegar tu Aplicación Structurizr en Render

### 1. Preparación del Repositorio

Asegúrate de que tu repositorio contenga estos archivos:

- `render.yaml` - Configuración de Render
- `Dockerfile` - Configuración de Docker
- `start-production.sh` - Script de inicio
- `nginx.conf.example` - Ejemplo de configuración de nginx
- `src/main/resources/workspace.dsl` - Archivo DSL de Structurizr

**Nota**: Los archivos `nginx.conf` y `.htpasswd` se generan automáticamente durante el build.

### 2. Crear Cuenta en Render

1. Ve a [render.com](https://render.com)
2. Crea una cuenta gratuita
3. Conecta tu cuenta de GitHub/GitLab

### 3. Desplegar la Aplicación

#### Opción A: Despliegue Automático con render.yaml

1. **Sube tu código a GitHub**:

   ```bash
   git add .
   git commit -m "Preparar para despliegue en Render"
   git push origin main
   ```

2. **En Render Dashboard**:

   - Haz clic en "New +"
   - Selecciona "Blueprint"
   - Conecta tu repositorio de GitHub
   - Render detectará automáticamente el `render.yaml`

3. **Configuración**:
   - **Name**: `structurizr-erp`
   - **Environment**: `Docker`
   - **Plan**: `Free`

#### Opción B: Despliegue Manual

1. **En Render Dashboard**:

   - Haz clic en "New +"
   - Selecciona "Web Service"
   - Conecta tu repositorio de GitHub

2. **Configuración del Servicio**:

   - **Name**: `structurizr-erp`
   - **Environment**: `Docker`
   - **Region**: `Oregon (US West)` (más rápida)
   - **Branch**: `main`
   - **Root Directory**: `/` (dejar vacío)
   - **Dockerfile Path**: `./Dockerfile`
   - **Docker Context**: `.`

3. **Variables de Entorno** (opcional):
   - `NODE_ENV`: `production`

### 4. Configuración de Autenticación

La aplicación incluye autenticación básica:

- **Usuario**: `admin`
- **Contraseña**: `1234`

### 4.1. Funcionalidad

La aplicación desplegada incluye:

- **Página principal**: Muestra el archivo DSL de Structurizr
- **Autenticación**: Protegida con usuario/contraseña
- **Archivo DSL**: Accesible en `/workspace.dsl`
- **Interfaz web**: Formateada y legible

### 5. Verificación del Despliegue

1. **Logs**: Revisa los logs en Render Dashboard
2. **Health Check**: Render verificará automáticamente `/`
3. **URL**: Tu aplicación estará disponible en `https://tu-app.onrender.com`

### 6. Comandos Útiles

```bash
# Verificar archivos antes del despliegue
ls -la

# Verificar que el Dockerfile es válido
docker build -t test .

# Probar localmente
docker run -p 8080:8080 test
```

### 7. Solución de Problemas

#### Error: "Docker not found"

- Render incluye Docker por defecto
- Verifica que el Dockerfile esté en la raíz

#### Error: "Port not available"

- Render asigna automáticamente el puerto
- El script `start-production.sh` maneja esto

#### Error: "Health check failed"

- Verifica que nginx esté iniciando correctamente
- Revisa los logs en Render Dashboard

### 8. Actualizaciones

Para actualizar la aplicación:

1. Haz cambios en tu código
2. Haz commit y push a GitHub
3. Render desplegará automáticamente

### 9. Costos

- **Plan Free**: 750 horas/mes
- **Plan Paid**: $7/mes por servicio

### 10. URLs de Acceso

Una vez desplegado, tu aplicación estará disponible en:

- `https://tu-app.onrender.com`
- Credenciales: `admin` / `1234`

## 🎉 ¡Listo!

Tu arquitectura Structurizr estará disponible públicamente en la web.
