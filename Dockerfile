# Dockerfile para Structurizr ERP en Render
FROM nginx:alpine

# Instalar dependencias
RUN apk add --no-cache curl docker

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración
COPY nginx.conf /etc/nginx/nginx.conf
COPY .htpasswd /etc/nginx/.htpasswd
COPY src/main/resources/workspace.dsl /usr/local/structurizr/workspace.dsl

# Script de inicio
COPY start-production.sh /start-production.sh
RUN chmod +x /start-production.sh

# Exponer puerto (Render usa $PORT)
EXPOSE $PORT

# Comando de inicio
CMD ["/start-production.sh"]
