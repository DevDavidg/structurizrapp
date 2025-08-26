#!/bin/sh

# Script de inicio para producción en Render
echo "🚀 Iniciando Structurizr ERP en Render..."

# Obtener puerto de Render (por defecto 8080)
PORT=${PORT:-8080}
echo "🌐 Puerto asignado: $PORT"

# Modificar configuración de nginx para usar el puerto correcto
sed -i "s/listen 8080;/listen $PORT;/" /etc/nginx/nginx.conf
sed -i "s/X-Forwarded-Port 8080;/X-Forwarded-Port $PORT;/" /etc/nginx/nginx.conf

# Verificar que los archivos necesarios existen
echo "🔍 Verificando archivos..."
if [ ! -f "/etc/nginx/.htpasswd" ]; then
    echo "⚠️  Generando archivo de contraseñas..."
    htpasswd -cb /etc/nginx/.htpasswd admin 1234
fi

# Crear directorio para Structurizr si no existe
mkdir -p /usr/local/structurizr

# Verificar que el archivo WAR existe y es válido
echo "🔍 Verificando archivo Structurizr Lite..."
if [ ! -f "/usr/local/structurizr/structurizr-lite.war" ]; then
    echo "❌ Error: Archivo structurizr-lite.war no encontrado"
    exit 1
fi

# Verificar que el archivo WAR tiene un tamaño razonable (más de 1MB)
FILE_SIZE=$(stat -c%s /usr/local/structurizr/structurizr-lite.war 2>/dev/null || stat -f%z /usr/local/structurizr/structurizr-lite.war 2>/dev/null || echo "0")
if [ "$FILE_SIZE" -lt 1000000 ]; then
    echo "❌ Error: Archivo structurizr-lite.war es muy pequeño ($FILE_SIZE bytes), posiblemente corrupto"
    exit 1
fi

echo "✅ Archivo Structurizr Lite verificado"

# Verificar que el archivo workspace.dsl existe
if [ ! -f "/usr/local/structurizr/workspace.dsl" ]; then
    echo "❌ Error: Archivo workspace.dsl no encontrado"
    exit 1
fi
echo "✅ Archivo workspace.dsl verificado"

# Iniciar Structurizr Lite en segundo plano
echo "📊 Iniciando Structurizr Lite..."
cd /usr/local/structurizr
echo "🔍 Directorio actual: $(pwd)"
echo "🔍 Contenido del directorio:"
ls -la
echo "🔍 Ejecutando Structurizr Lite..."
java -jar structurizr-lite.war --workspace /usr/local/structurizr --port 8080 > /tmp/structurizr.log 2>&1 &
STRUCTURIZR_PID=$!

# Esperar a que Structurizr esté listo
echo "⏳ Esperando a que Structurizr esté listo..."
sleep 20

# Verificar que Structurizr esté ejecutándose
if kill -0 $STRUCTURIZR_PID 2>/dev/null; then
    echo "✅ Structurizr Lite iniciado correctamente"
    
    # Mostrar logs de Structurizr
    echo "🔍 Logs de Structurizr Lite:"
    if [ -f "/tmp/structurizr.log" ]; then
        tail -20 /tmp/structurizr.log
    else
        echo "⚠️  No se encontraron logs de Structurizr"
    fi
    
    # Verificar que esté escuchando en el puerto 8080
    echo "🔍 Verificando que Structurizr esté escuchando en puerto 8080..."
    if netstat -tuln | grep -q ":8080 "; then
        echo "✅ Structurizr Lite escuchando en puerto 8080"
    else
        echo "⚠️  Structurizr Lite no está escuchando en puerto 8080"
        echo "🔍 Puertos en uso:"
        netstat -tuln | grep LISTEN
    fi
else
    echo "❌ Error: Structurizr Lite no se inició correctamente"
    echo "🔍 Últimos logs de Structurizr:"
    if [ -f "/tmp/structurizr.log" ]; then
        cat /tmp/structurizr.log
    fi
    echo "🔍 Procesos Java:"
    ps aux | grep java
    exit 1
fi

# Iniciar nginx
echo "🌐 Iniciando nginx en puerto $PORT..."
nginx -g "daemon off;"
