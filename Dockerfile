# Dockerfile para Structurizr ERP en Render
FROM nginx:alpine

# Instalar dependencias
RUN apk add --no-cache curl apache2-utils

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración
COPY nginx.conf.example /etc/nginx/nginx.conf
COPY src/main/resources/workspace.dsl /usr/local/structurizr/workspace.dsl

# Generar archivo de contraseñas
RUN htpasswd -cb /etc/nginx/.htpasswd admin 1234

# Crear página HTML simple que muestre el DSL
RUN echo '<!DOCTYPE html><html><head><title>Arquitectura ERP - Structurizr</title><style>body{font-family:Arial,sans-serif;margin:40px;background:#f5f5f5;}h1{color:#333;}pre{background:#fff;padding:20px;border-radius:5px;overflow-x:auto;border:1px solid #ddd;}</style></head><body><h1>🏗️ Arquitectura del Sistema ERP</h1><p>Este es el archivo DSL de Structurizr que define la arquitectura del sistema:</p><pre>' > /usr/share/nginx/html/index.html && \
    cat /usr/local/structurizr/workspace.dsl >> /usr/share/nginx/html/index.html && \
    echo '</pre><p><strong>Credenciales:</strong> admin / 1234</p></body></html>' >> /usr/share/nginx/html/index.html

# Script de inicio
COPY start-production.sh /start-production.sh
RUN chmod +x /start-production.sh

# Exponer puerto (Render usa $PORT)
EXPOSE $PORT

# Comando de inicio
CMD ["/start-production.sh"]
