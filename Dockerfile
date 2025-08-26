# Dockerfile para Structurizr ERP en Render
FROM alpine:latest

# Instalar Java, nginx y dependencias
RUN apk add --no-cache openjdk17-jre nginx apache2-utils curl file net-tools graphviz

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
COPY structurizr.properties /usr/local/structurizr/structurizr.properties

# Generar archivo de contraseñas
RUN htpasswd -cb /etc/nginx/.htpasswd admin 1234

# Script de inicio
COPY start-production.sh /start-production.sh
RUN chmod +x /start-production.sh

# Exponer puerto 8080 para Structurizr Lite
EXPOSE 8080

# Comando de inicio optimizado
CMD ["java", "-jar", "/usr/local/structurizr/structurizr-lite.war", "/usr/local/structurizr", \
     "--server.port=8080", "--spring.profiles.active=production", "--structurizr.lite.preview-features=false"]
