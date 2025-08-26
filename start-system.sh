#!/bin/bash

# Script para levantar el sistema completo de Structurizr con login
# Autor: Sistema ERP Arquitectura
# Fecha: $(date)

echo "🚀 Iniciando Sistema ERP - Arquitectura con Login"
echo "=================================================="

# Verificar que Docker esté ejecutándose
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está ejecutándose"
    echo "Por favor, inicia Docker y vuelve a intentar"
    exit 1
fi

# Verificar que Java esté instalado
if ! command -v java &> /dev/null; then
    echo "❌ Error: Java no está instalado"
    echo "Por favor, instala Java 17 o superior"
    exit 1
fi

# Verificar que Gradle esté disponible
if ! command -v ./gradlew &> /dev/null; then
    echo "❌ Error: Gradle wrapper no está disponible"
    echo "Asegúrate de estar en el directorio correcto del proyecto"
    exit 1
fi

echo "✅ Verificaciones completadas"

# Detener contenedores existentes de Structurizr Lite
echo "🔄 Deteniendo contenedores existentes..."
docker stop $(docker ps -q --filter ancestor=structurizr/lite) 2>/dev/null || true
docker rm $(docker ps -aq --filter ancestor=structurizr/lite) 2>/dev/null || true

# Levantar Structurizr Lite en puerto 8081
echo "🌐 Levantando Structurizr Lite en puerto 8081..."
docker run -d \
    --name structurizr-lite \
    -p 8081:8080 \
    -v $(pwd)/src/main/resources:/usr/local/structurizr \
    structurizr/lite

if [ $? -eq 0 ]; then
    echo "✅ Structurizr Lite iniciado correctamente"
else
    echo "❌ Error al iniciar Structurizr Lite"
    exit 1
fi

# Esperar a que Structurizr Lite esté listo
echo "⏳ Esperando a que Structurizr Lite esté listo..."
sleep 10

# Verificar que Structurizr Lite esté respondiendo
if curl -s http://localhost:8081 > /dev/null; then
    echo "✅ Structurizr Lite está respondiendo"
else
    echo "⚠️  Structurizr Lite aún no está listo, continuando..."
fi

# Buildear la aplicación Spring Boot
echo "🔨 Buildeando aplicación Spring Boot..."
./gradlew build -x test

if [ $? -eq 0 ]; then
    echo "✅ Build completado exitosamente"
else
    echo "❌ Error en el build"
    exit 1
fi

# Levantar la aplicación Spring Boot
echo "🚀 Levantando aplicación Spring Boot..."
echo ""
echo "📋 Información de acceso:"
echo "   🌐 URL: http://localhost:8080"
echo "   👤 Usuario: admin"
echo "   🔑 Contraseña: 1234"
echo ""
echo "📊 Structurizr Lite: http://localhost:8081"
echo ""
echo "⏹️  Para detener el sistema, presiona Ctrl+C"
echo ""

# Ejecutar la aplicación Spring Boot
./gradlew bootRun
