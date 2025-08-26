#!/bin/bash

# Script para limpiar contenedores y archivos temporales
echo "🧹 Limpiando sistema Structurizr..."
echo "=================================="

# Detener contenedores
echo "🛑 Deteniendo contenedores..."
docker stop structurizr-lite nginx-auth 2>/dev/null || true
docker stop $(docker ps -q --filter ancestor=structurizr/lite) 2>/dev/null || true

# Eliminar contenedores
echo "🗑️  Eliminando contenedores..."
docker rm structurizr-lite nginx-auth 2>/dev/null || true
docker rm $(docker ps -aq --filter ancestor=structurizr/lite) 2>/dev/null || true

# Eliminar red
echo "🌐 Eliminando red Docker..."
docker network rm structurizr-network 2>/dev/null || true

# Eliminar archivos temporales
echo "📁 Eliminando archivos temporales..."
rm -f nginx.conf .htpasswd
rm -rf temp-build

# Limpiar caché de Gradle (opcional)
if [ "$1" = "--full" ]; then
    echo "🗂️  Limpiando caché de Gradle..."
    rm -rf ~/.gradle/caches
fi

echo "✅ Limpieza completada!"
echo ""
echo "Para reiniciar el sistema:"
echo "  ./start-simple.sh"
