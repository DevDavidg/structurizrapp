#!/bin/bash

# Script de validación básica del DSL sin dependencias externas
echo "🔍 Validación Básica del DSL"
echo "============================"

DSL_FILE="src/main/resources/workspace.dsl"

# Verificar que el archivo existe
if [ ! -f "$DSL_FILE" ]; then
    echo "❌ Error: Archivo DSL no encontrado en $DSL_FILE"
    exit 1
fi

echo "✅ Archivo DSL encontrado: $DSL_FILE"

# Verificar sintaxis básica
echo ""
echo "🔍 Verificando sintaxis básica..."

# Verificar que comience con workspace
if ! grep -q "^workspace" "$DSL_FILE"; then
    echo "❌ Error: El archivo debe comenzar con 'workspace'"
    exit 1
fi
echo "✅ Inicio de workspace encontrado"

# Verificar que tenga sección model
if ! grep -q "^    model" "$DSL_FILE"; then
    echo "❌ Error: Falta la sección 'model'"
    exit 1
fi
echo "✅ Sección model encontrada"

# Verificar que tenga sección views
if ! grep -q "^    views" "$DSL_FILE"; then
    echo "❌ Error: Falta la sección 'views'"
    exit 1
fi
echo "✅ Sección views encontrada"

# Verificar que tenga llaves de cierre
if ! grep -q "^}" "$DSL_FILE"; then
    echo "❌ Error: Falta llave de cierre '}'"
    exit 1
fi
echo "✅ Llave de cierre encontrada"

# Contar elementos básicos
echo ""
echo "📊 Análisis de elementos:"

PERSONAS=$(grep -c "person" "$DSL_FILE" || echo "0")
SOFTWARE_SYSTEMS=$(grep -c "softwareSystem" "$DSL_FILE" || echo "0")
CONTAINERS=$(grep -c "container" "$DSL_FILE" || echo "0")
COMPONENTS=$(grep -c "component" "$DSL_FILE" || echo "0")
RELATIONSHIPS=$(grep -c "->" "$DSL_FILE" || echo "0")

echo "   - Personas: $PERSONAS"
echo "   - Sistemas de Software: $SOFTWARE_SYSTEMS"
echo "   - Contenedores: $CONTAINERS"
echo "   - Componentes: $COMPONENTS"
echo "   - Relaciones: $RELATIONSHIPS"

# Verificar que tenga al menos un elemento de cada tipo
if [ "$PERSONAS" -eq 0 ]; then
    echo "⚠️  Advertencia: No se encontraron personas"
fi

if [ "$SOFTWARE_SYSTEMS" -eq 0 ]; then
    echo "⚠️  Advertencia: No se encontraron sistemas de software"
fi

if [ "$CONTAINERS" -eq 0 ]; then
    echo "⚠️  Advertencia: No se encontraron contenedores"
fi

# Verificar vistas
echo ""
echo "🔍 Verificando vistas:"

SYSTEM_CONTEXT=$(grep -c "systemContext" "$DSL_FILE" || echo "0")
CONTAINER_VIEWS=$(grep -c "container" "$DSL_FILE" | head -1 || echo "0")
COMPONENT_VIEWS=$(grep -c "component" "$DSL_FILE" | head -1 || echo "0")
DYNAMIC_VIEWS=$(grep -c "dynamic" "$DSL_FILE" || echo "0")

echo "   - Vistas de Contexto: $SYSTEM_CONTEXT"
echo "   - Vistas de Contenedores: $CONTAINER_VIEWS"
echo "   - Vistas de Componentes: $COMPONENT_VIEWS"
echo "   - Vistas Dinámicas: $DYNAMIC_VIEWS"

# Verificar estilos
if grep -q "styles" "$DSL_FILE"; then
    echo "✅ Estilos personalizados encontrados"
else
    echo "⚠️  Advertencia: No se encontraron estilos personalizados"
fi

echo ""
echo "🎉 Validación básica completada exitosamente!"
echo ""
echo "💡 Para validación completa, usa Structurizr Lite:"
echo "   ./start-simple.sh"
echo ""
echo "📋 Credenciales: admin / 1234"
