#!/bin/sh

# Script de inicio para producción en Render
echo "🚀 Iniciando Structurizr ERP en Render..."

# Obtener puerto de Render (por defecto 8080)
PORT=${PORT:-8080}
echo "🌐 Puerto asignado: $PORT"

# Crear red Docker si no existe
docker network create structurizr-network 2>/dev/null || true

# Iniciar Structurizr Lite
echo "📊 Iniciando Structurizr Lite..."
docker run -d \
    --name structurizr-lite \
    --network structurizr-network \
    -v /usr/local/structurizr/workspace.dsl:/usr/local/structurizr/workspace.dsl \
    structurizr/lite:latest

# Esperar a que Structurizr esté listo
echo "⏳ Esperando a que Structurizr esté listo..."
sleep 15

# Modificar configuración de nginx para usar el puerto correcto
sed -i "s/listen 8080;/listen $PORT;/" /etc/nginx/nginx.conf

# Iniciar nginx
echo "🌐 Iniciando nginx en puerto $PORT..."
nginx -g "daemon off;"
