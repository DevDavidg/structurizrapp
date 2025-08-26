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

# Crear directorio para Structurizr si no existe
mkdir -p /usr/local/structurizr

# Verificar que el archivo JAR existe y es válido
echo "🔍 Verificando archivo Structurizr Lite..."
if [ ! -f "/usr/local/structurizr/structurizr-lite.jar" ]; then
    echo "❌ Error: Archivo structurizr-lite.jar no encontrado"
    exit 1
fi

# Verificar que el archivo JAR es válido
if ! java -jar /usr/local/structurizr/structurizr-lite.jar --help > /dev/null 2>&1; then
    echo "❌ Error: Archivo structurizr-lite.jar no es válido"
    exit 1
fi

echo "✅ Archivo Structurizr Lite verificado"

# Iniciar Structurizr Lite en segundo plano
echo "📊 Iniciando Structurizr Lite..."
java -jar /usr/local/structurizr/structurizr-lite.jar /usr/local/structurizr/workspace.dsl 8080 &
STRUCTURIZR_PID=$!

# Esperar a que Structurizr esté listo
echo "⏳ Esperando a que Structurizr esté listo..."
sleep 15

# Verificar que Structurizr esté ejecutándose
if kill -0 $STRUCTURIZR_PID 2>/dev/null; then
    echo "✅ Structurizr Lite iniciado correctamente"
else
    echo "❌ Error: Structurizr Lite no se inició correctamente"
    exit 1
fi

# Iniciar nginx
echo "🌐 Iniciando nginx en puerto $PORT..."
nginx -g "daemon off;"
