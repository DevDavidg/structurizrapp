#!/bin/bash

# Script para reiniciar completamente el sistema
echo "🔄 Reiniciando Sistema ERP - Arquitectura con Login"
echo "=================================================="

# Detener y limpiar todo
echo "🧹 Limpiando sistema anterior..."
docker stop nginx-auth structurizr-lite 2>/dev/null || true
docker rm nginx-auth structurizr-lite 2>/dev/null || true
docker network rm structurizr-network 2>/dev/null || true

# Eliminar archivos temporales
rm -f nginx.conf .htpasswd

# Crear archivo de contraseñas correcto
echo "🔐 Configurando autenticación..."
docker run --rm httpd:2.4-alpine htpasswd -nbB admin 1234 > .htpasswd

# Crear configuración de nginx
echo "📝 Creando configuración de nginx..."
cat > nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    server {
        listen 8080;
        
        location / {
            auth_basic "Sistema ERP - Arquitectura";
            auth_basic_user_file /etc/nginx/.htpasswd;
            
            proxy_pass http://structurizr-lite:8080;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

# Crear red
echo "🌐 Creando red Docker..."
docker network create structurizr-network 2>/dev/null || true

# Levantar Structurizr Lite
echo "🌐 Levantando Structurizr Lite..."
docker run -d \
    --name structurizr-lite \
    --network structurizr-network \
    -v $(pwd)/src/main/resources:/usr/local/structurizr \
    structurizr/lite

# Levantar nginx
echo "🔒 Levantando nginx con autenticación..."
docker run -d \
    --name nginx-auth \
    --network structurizr-network \
    -p 8080:8080 \
    -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v $(pwd)/.htpasswd:/etc/nginx/.htpasswd:ro \
    nginx:alpine

# Esperar
echo "⏳ Esperando a que los servicios estén listos..."
sleep 15

# Verificar
echo "🔍 Verificando servicios..."
if curl -s -u admin:1234 http://localhost:8080 > /dev/null; then
    echo ""
    echo "✅ Sistema reiniciado correctamente!"
    echo ""
    echo "📋 Información de acceso:"
    echo "   🌐 URL: http://localhost:8080"
    echo "   👤 Usuario: admin"
    echo "   🔑 Contraseña: 1234"
    echo ""
    echo "💡 Si el navegador no funciona, intenta:"
    echo "   1. Limpiar caché del navegador (Cmd+Shift+R)"
    echo "   2. Abrir en modo incógnito"
    echo "   3. Cerrar y abrir el navegador"
    echo ""
    echo "🌐 Abriendo en el navegador..."
    open http://localhost:8080
else
    echo "❌ Error: No se pudo conectar"
    echo "Verificando logs..."
    docker logs nginx-auth
    docker logs structurizr-lite
fi
