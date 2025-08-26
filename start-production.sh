#!/bin/sh

# Script de inicio para producción en Render
echo "🚀 Iniciando Structurizr ERP en Render..."

# Obtener puerto de Render (por defecto 8080)
PORT=${PORT:-8080}
echo "🌐 Puerto asignado: $PORT"

# Modificar configuración de nginx para usar el puerto correcto
sed -i "s/listen 8080;/listen $PORT;/" /etc/nginx/nginx.conf

# Verificar que los archivos necesarios existen
echo "🔍 Verificando archivos..."
if [ ! -f "/etc/nginx/.htpasswd" ]; then
    echo "⚠️  Generando archivo de contraseñas..."
    htpasswd -cb /etc/nginx/.htpasswd admin 1234
fi

# Iniciar nginx
echo "🌐 Iniciando nginx en puerto $PORT..."
nginx -g "daemon off;"
