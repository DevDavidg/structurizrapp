#!/bin/bash

echo "🧪 Prueba de Acceso - Sistema ERP"
echo "================================="

echo ""
echo "🔐 Probando autenticación..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -u admin:1234 http://localhost:8080)

if [ "$RESPONSE" = "302" ]; then
    echo "✅ Autenticación exitosa (redirección 302)"
else
    echo "❌ Error en autenticación (código: $RESPONSE)"
    exit 1
fi

echo ""
echo "📊 Probando acceso a diagramas..."
DIAGRAMS_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -u admin:1234 http://localhost:8080/workspace/diagrams)

if [ "$DIAGRAMS_RESPONSE" = "200" ]; then
    echo "✅ Página de diagramas accesible"
else
    echo "❌ Error accediendo a diagramas (código: $DIAGRAMS_RESPONSE)"
    exit 1
fi

echo ""
echo "🎉 ¡Sistema completamente funcional!"
echo ""
echo "📋 Información de acceso:"
echo "   🌐 URL: http://localhost:8080"
echo "   👤 Usuario: admin"
echo "   🔑 Contraseña: 1234"
echo ""
echo "💡 Si Safari muestra error de conexión:"
echo "   1. Limpia caché: Cmd + Shift + R"
echo "   2. Modo incógnito: Cmd + Shift + N"
echo "   3. Reinicia Safari completamente"
