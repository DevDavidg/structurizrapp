#!/bin/bash

# Script de verificación para la solución de Structurizr Lite
echo "🔍 Verificando solución de Structurizr Lite..."
echo "=============================================="

# URL de la aplicación
URL="https://structurizr-erp.onrender.com"

echo "1️⃣ Verificando conectividad básica..."
if curl -s -I "$URL" | grep -q "200\|401"; then
    echo "✅ Conectividad básica: OK"
else
    echo "❌ Conectividad básica: FALLA"
    exit 1
fi

echo ""
echo "2️⃣ Verificando autenticación..."
RESPONSE=$(curl -s -u admin:1234 "$URL")
if echo "$RESPONSE" | grep -q "<!DOCTYPE html\|<html"; then
    echo "✅ Autenticación y HTML: OK"
    echo "   Respuesta contiene HTML (interfaz web)"
elif echo "$RESPONSE" | grep -q "^[0-9]*$"; then
    echo "⚠️  Autenticación: OK, pero devuelve ID de sesión"
    echo "   Respuesta: $RESPONSE"
    echo "   Problema: Modo desarrollo aún activo"
else
    echo "❌ Autenticación: FALLA"
    echo "   Respuesta: $RESPONSE"
fi

echo ""
echo "3️⃣ Verificando workspace DSL..."
if curl -s -u admin:1234 "$URL/workspace.dsl" | grep -q "workspace"; then
    echo "✅ Workspace DSL: OK"
else
    echo "❌ Workspace DSL: FALLA"
fi

echo ""
echo "4️⃣ Verificando diagramas..."
if curl -s -u admin:1234 "$URL/workspace/diagrams" | grep -q "<!DOCTYPE html\|<html\|diagram"; then
    echo "✅ Diagramas: OK"
else
    echo "⚠️  Diagramas: Posible problema"
    echo "   Respuesta: $(curl -s -u admin:1234 "$URL/workspace/diagrams" | head -c 100)..."
fi

echo ""
echo "5️⃣ Verificando puerto interno..."
echo "   Puerto esperado: 8080"
echo "   Puerto actual: Verificar en logs de Render"

echo ""
echo "📋 Resumen de verificación:"
echo "=========================="
echo "• Si ves '✅ HTML': Solución EXITOSA"
echo "• Si ves '⚠️ ID de sesión': Aún en modo desarrollo"
echo "• Si ves '❌': Problema de conectividad"

echo ""
echo "🌐 Para acceder a la aplicación:"
echo "   URL: $URL"
echo "   Usuario: admin"
echo "   Contraseña: 1234"
