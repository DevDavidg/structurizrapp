#!/bin/bash

# Script simplificado para levantar Structurizr Lite con autenticación
# Usuario: admin
# Contraseña: 1234

echo "🚀 Iniciando Sistema ERP - Arquitectura con Login"
echo "=================================================="

# Detener contenedores existentes
echo "🔄 Deteniendo contenedores existentes..."
docker stop structurizr-lite 2>/dev/null || true
docker rm structurizr-lite 2>/dev/null || true

# Crear archivo de contraseñas
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
            proxy_set_header Host $host:8080;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host:8080;
            proxy_set_header X-Forwarded-Port 8080;
            
            # Configuración adicional para Structurizr
            proxy_redirect off;
            proxy_buffering off;
            proxy_request_buffering off;
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
sleep 10

# Verificar
echo "🔍 Verificando servicios..."
if curl -s -u admin:1234 http://localhost:8080 > /dev/null; then
    echo ""
    echo "✅ Sistema iniciado correctamente!"
    echo ""
    echo "📋 Información de acceso:"
    echo "   🌐 URL: http://localhost:8080"
    echo "   👤 Usuario: admin"
    echo "   🔑 Contraseña: 1234"
    echo ""
    echo "🔧 Para detener: docker stop nginx-auth structurizr-lite"
    echo ""
    echo "🌐 Abriendo en el navegador..."
    open http://localhost:8080
else
    echo "❌ Error: No se pudo conectar"
    echo "Verificando logs..."
    docker logs nginx-auth
    docker logs structurizr-lite
fi
