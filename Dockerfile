# Dockerfile para Structurizr ERP en Render
FROM alpine:latest

# Instalar Java, nginx y dependencias
RUN apk add --no-cache openjdk17-jre nginx apache2-utils curl file

# Crear directorio de trabajo
WORKDIR /app

# Crear directorio para Structurizr
RUN mkdir -p /usr/local/structurizr

# Descargar Structurizr Lite (ahora es un archivo WAR)
RUN curl -L -o /usr/local/structurizr/structurizr-lite.war \
    "https://github.com/structurizr/lite/releases/download/v2025.05.28/structurizr-lite.war" && \
    ls -la /usr/local/structurizr/structurizr-lite.war && \
    echo "Structurizr Lite descargado correctamente"

# Copiar archivos de configuración
COPY nginx.conf.example /etc/nginx/nginx.conf
COPY src/main/resources/workspace.dsl /usr/local/structurizr/workspace.dsl

# Generar archivo de contraseñas
RUN htpasswd -cb /etc/nginx/.htpasswd admin 1234

# Script de inicio
COPY start-production.sh /start-production.sh
RUN chmod +x /start-production.sh

# Exponer puerto (Render usa $PORT)
EXPOSE $PORT

# Comando de inicio
CMD ["/start-production.sh"]
