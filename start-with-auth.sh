#!/bin/bash

# Script para levantar Structurizr Lite con autenticación básica
# Usuario: admin
# Contraseña: 1234

echo "🚀 Iniciando Sistema ERP - Arquitectura con Autenticación"
echo "========================================================="

# Verificar que Docker esté ejecutándose
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está ejecutándose"
    echo "Por favor, inicia Docker y vuelve a intentar"
    exit 1
fi

# Detener contenedores existentes
echo "🔄 Deteniendo contenedores existentes..."
docker stop structurizr-lite nginx-auth 2>/dev/null || true
docker rm structurizr-lite nginx-auth 2>/dev/null || true

# Crear archivo de configuración de nginx
echo "📝 Creando configuración de nginx..."
cat > nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream structurizr {
        server structurizr-lite:8080;
    }

    server {
        listen 8080;
        
        location / {
            auth_basic "Sistema ERP - Arquitectura";
            auth_basic_user_file /etc/nginx/.htpasswd;
            
            proxy_pass http://structurizr;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

# Crear archivo de contraseñas
echo "🔐 Configurando autenticación..."
docker run --rm httpd:2.4-alpine htpasswd -nbB admin 1234 > .htpasswd

# Levantar Structurizr Lite
echo "🌐 Levantando Structurizr Lite..."
docker run -d \
    --name structurizr-lite \
    --network structurizr-network \
    -v $(pwd)/src/main/resources:/usr/local/structurizr \
    structurizr/lite

# Crear red si no existe
docker network create structurizr-network 2>/dev/null || true

# Levantar nginx con autenticación
echo "🔒 Levantando nginx con autenticación..."
docker run -d \
    --name nginx-auth \
    --network structurizr-network \
    -p 8080:8080 \
    -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v $(pwd)/.htpasswd:/etc/nginx/.htpasswd:ro \
    nginx:alpine

# Esperar a que los servicios estén listos
echo "⏳ Esperando a que los servicios estén listos..."
sleep 15

# Verificar que todo esté funcionando
if curl -s -u admin:1234 http://localhost:8080 > /dev/null; then
    echo ""
    echo "✅ Sistema iniciado correctamente!"
    echo ""
    echo "📋 Información de acceso:"
    echo "   🌐 URL: http://localhost:8080"
    echo "   👤 Usuario: admin"
    echo "   🔑 Contraseña: 1234"
    echo ""
    echo "🔧 Para detener el sistema:"
    echo "   docker stop nginx-auth structurizr-lite"
    echo "   docker rm nginx-auth structurizr-lite"
    echo ""
    echo "🌐 Abriendo en el navegador..."
    open http://localhost:8080
else
    echo "❌ Error: No se pudo conectar al sistema"
    echo "Verificando logs..."
    docker logs nginx-auth
    docker logs structurizr-lite
fi
