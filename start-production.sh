#!/bin/sh

# Script de inicio para producción en Render
echo "🚀 Iniciando Structurizr ERP en Render..."

# Obtener puerto de Render (por defecto 8080)
PORT=${PORT:-8080}
echo "🌐 Puerto asignado: $PORT"

# Modificar configuración de nginx para usar el puerto correcto
sed -i "s/listen 8081;/listen $PORT;/" /etc/nginx/nginx.conf

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

# Verificar contenido del workspace
echo "🔍 Verificando contenido del workspace:"
echo "📄 Primeras 5 líneas del workspace.dsl:"
head -5 /usr/local/structurizr/workspace.dsl
echo "📄 Tamaño del archivo: $(wc -l < /usr/local/structurizr/workspace.dsl) líneas"

# Iniciar Structurizr Lite en segundo plano
echo "📊 Iniciando Structurizr Lite..."
cd /usr/local/structurizr
echo "🔍 Directorio actual: $(pwd)"
echo "🔍 Contenido del directorio:"
ls -la
echo "🔍 Ejecutando Structurizr Lite..."
java -jar structurizr-lite.war /usr/local/structurizr > /tmp/structurizr.log 2>&1 &
STRUCTURIZR_PID=$!

# Esperar a que Structurizr esté listo
echo "⏳ Esperando a que Structurizr esté listo..."
sleep 30

# Esperar a que Structurizr esté completamente iniciado
echo "🔍 Esperando a que Structurizr esté completamente listo..."
for i in {1..10}; do
    if netstat -tuln | grep -q ":8080 "; then
        echo "✅ Structurizr Lite detectado en puerto 8080, intento $i"
        break
    fi
    echo "⏳ Esperando puerto de Structurizr Lite (8080), intento $i/10..."
    sleep 5
done

# Verificar que Structurizr esté ejecutándose
if kill -0 $STRUCTURIZR_PID 2>/dev/null; then
    echo "✅ Structurizr Lite iniciado correctamente"
    
    # Mostrar logs de Structurizr
echo "🔍 Logs de Structurizr Lite:"
if [ -f "/tmp/structurizr.log" ]; then
    echo "📄 Últimas 30 líneas del log:"
    tail -30 /tmp/structurizr.log
    echo ""
    echo "🔍 Buscando errores específicos:"
    grep -i "error\|exception\|failed" /tmp/structurizr.log || echo "No se encontraron errores"
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
    
    # Buscar puerto de Structurizr Lite
    echo "🔍 Buscando puerto de Structurizr Lite..."
    echo "🔍 Puertos disponibles:"
    netstat -tuln | grep LISTEN | grep ":8080"
    
    # Verificar si Structurizr está en puerto 8080
    if netstat -tuln | grep -q ":8080 "; then
        STRUCTURIZR_PORT="8080"
        echo "✅ Structurizr Lite detectado en puerto 8080"
    else
        echo "⚠️  Structurizr Lite no está en puerto 8080, buscando puertos alternativos..."
        netstat -tuln | grep LISTEN | grep -E ":(1801[23]|19099)"
        
        # Intentar múltiples veces para encontrar el puerto correcto
        STRUCTURIZR_PORT=""
        for attempt in {1..5}; do
            echo "🔍 Intento $attempt de detectar puerto alternativo..."
            STRUCTURIZR_PORT=$(netstat -tuln | grep LISTEN | grep -E ":(1801[23]|19099)" | head -1 | awk '{print $4}' | sed 's/.*://')
            if [ ! -z "$STRUCTURIZR_PORT" ]; then
                echo "✅ Puerto alternativo detectado: $STRUCTURIZR_PORT"
                break
            fi
            echo "⏳ Puerto no detectado, esperando 2 segundos..."
            sleep 2
        done
    fi
    echo "🔍 Puerto final extraído: '$STRUCTURIZR_PORT'"
    if [ ! -z "$STRUCTURIZR_PORT" ]; then
        echo "✅ Structurizr Lite encontrado en puerto $STRUCTURIZR_PORT"
        echo "🔄 Actualizando configuración de nginx para usar puerto $STRUCTURIZR_PORT..."
        sed -i "s/proxy_pass http:\/\/localhost:8080;/proxy_pass http:\/\/localhost:$STRUCTURIZR_PORT;/" /etc/nginx/nginx.conf
        sed -i "s/X-Forwarded-Port 8080;/X-Forwarded-Port $STRUCTURIZR_PORT;/" /etc/nginx/nginx.conf
        
        # Verificar conectividad a Structurizr Lite
        echo "🔍 Verificando conectividad a Structurizr Lite en puerto $STRUCTURIZR_PORT..."
        if curl -s --connect-timeout 5 http://localhost:$STRUCTURIZR_PORT > /dev/null 2>&1; then
            echo "✅ Conectividad a Structurizr Lite verificada"
        else
            echo "⚠️  No se pudo conectar a Structurizr Lite en puerto $STRUCTURIZR_PORT"
        fi
    else
        echo "❌ No se pudo encontrar el puerto de Structurizr Lite"
    fi
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
