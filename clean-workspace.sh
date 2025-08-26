#!/bin/bash

# Script para limpiar workspace.json vacío que causa errores
echo "🧹 Limpiando workspace.json vacío..."

WORKSPACE_DIR="/usr/local/structurizr"
JSON_FILE="$WORKSPACE_DIR/workspace.json"

# Verificar si existe workspace.json
if [ -f "$JSON_FILE" ]; then
    echo "📄 Archivo workspace.json encontrado"
    
    # Verificar si está vacío
    if [ ! -s "$JSON_FILE" ]; then
        echo "⚠️  workspace.json está vacío - ELIMINANDO"
        rm -f "$JSON_FILE"
        echo "✅ workspace.json vacío eliminado"
    else
        echo "✅ workspace.json tiene contenido - MANTENIENDO"
        echo "📊 Tamaño: $(wc -c < "$JSON_FILE") bytes"
    fi
else
    echo "✅ No existe workspace.json - OK"
fi

# Verificar workspace.dsl
DSL_FILE="$WORKSPACE_DIR/workspace.dsl"
if [ -f "$DSL_FILE" ]; then
    echo "✅ workspace.dsl encontrado"
    echo "📊 Tamaño: $(wc -c < "$DSL_FILE") bytes"
    echo "📄 Líneas: $(wc -l < "$DSL_FILE")"
else
    echo "❌ workspace.dsl NO encontrado"
    exit 1
fi

# Crear directorio de índice si no existe
INDEX_DIR="$WORKSPACE_DIR/.structurizr/index"
if [ ! -d "$INDEX_DIR" ]; then
    echo "📁 Creando directorio de índice..."
    mkdir -p "$INDEX_DIR"
    echo "✅ Directorio de índice creado"
else
    echo "✅ Directorio de índice ya existe"
fi

echo "🧹 Limpieza completada"
