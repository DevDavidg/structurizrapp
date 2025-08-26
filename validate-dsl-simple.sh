#!/bin/bash

# Script simple para validar el DSL usando Java directamente
# Evita problemas de compatibilidad con Gradle

echo "🔍 Validando DSL con Java directo..."
echo "===================================="

# Verificar que Java esté disponible
if ! command -v java &> /dev/null; then
    echo "❌ Error: Java no está instalado"
    exit 1
fi

# Verificar que javac esté disponible
if ! command -v javac &> /dev/null; then
    echo "❌ Error: JDK no está instalado (javac no encontrado)"
    exit 1
fi

echo "✅ Java encontrado: $(java -version 2>&1 | head -1)"
echo "✅ JDK encontrado: $(javac -version 2>&1)"

# Crear directorio temporal para compilación
mkdir -p temp-build

# Descargar dependencias si no existen
if [ ! -f "temp-build/structurizr-core.jar" ]; then
    echo "📥 Descargando dependencias..."
    curl -L -o temp-build/structurizr-core.jar \
        "https://repo1.maven.org/maven2/com/structurizr/structurizr-core/1.18.0/structurizr-core-1.18.0.jar"
    curl -L -o temp-build/structurizr-dsl.jar \
        "https://repo1.maven.org/maven2/com/structurizr/structurizr-dsl/1.18.0/structurizr-dsl-1.18.0.jar"
    curl -L -o temp-build/httpcore5.jar \
        "https://repo1.maven.org/maven2/org/apache/httpcomponents/core5/httpcore5/5.2.1/httpcore5-5.2.1.jar"
    curl -L -o temp-build/httpclient5.jar \
        "https://repo1.maven.org/maven2/org/apache/httpcomponents/client5/httpclient5/5.2.1/httpclient5-5.2.1.jar"
    curl -L -o temp-build/commons-logging.jar \
        "https://repo1.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar"
    curl -L -o temp-build/commons-codec.jar \
        "https://repo1.maven.org/maven2/commons-codec/commons-codec/1.15/commons-codec-1.15.jar"
    curl -L -o temp-build/jackson-core.jar \
        "https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.15.2/jackson-core-2.15.2.jar"
    curl -L -o temp-build/jackson-databind.jar \
        "https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.15.2/jackson-databind-2.15.2.jar"
    curl -L -o temp-build/jackson-annotations.jar \
        "https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.15.2/jackson-annotations-2.15.2.jar"
fi

# Compilar el validador
echo "🔨 Compilando validador..."
javac -cp "temp-build/*" -d temp-build src/main/java/demo/Main.java

if [ $? -eq 0 ]; then
    echo "✅ Compilación exitosa"
    
    # Ejecutar el validador
    echo "🚀 Ejecutando validador..."
    java -cp "temp-build:temp-build/*" demo.Main
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 Validación completada exitosamente!"
    else
        echo "❌ Error en la validación"
        exit 1
    fi
else
    echo "❌ Error en la compilación"
    exit 1
fi

# Limpiar archivos temporales
echo "🧹 Limpiando archivos temporales..."
rm -rf temp-build

echo "✅ Proceso completado"
