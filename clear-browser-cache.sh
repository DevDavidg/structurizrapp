#!/bin/bash

echo "🧹 Limpieza de Caché del Navegador"
echo "==================================="

echo ""
echo "🔍 Verificando estado del sistema..."
if ./test-access.sh > /dev/null 2>&1; then
    echo "✅ Sistema funcionando correctamente"
else
    echo "❌ Problemas detectados en el sistema"
    exit 1
fi

echo ""
echo "📋 Pasos para limpiar caché en Safari:"
echo "   1. Abre Safari"
echo "   2. Presiona Cmd + Shift + R (recarga forzada)"
echo "   3. O ve a Safari > Preferencias > Privacidad"
echo "   4. Haz clic en 'Gestionar datos de sitios web'"
echo "   5. Busca 'localhost' y elimínalo"
echo "   6. Reinicia Safari (Cmd + Q)"

echo ""
echo "📋 Pasos para limpiar caché en Chrome:"
echo "   1. Abre Chrome"
echo "   2. Presiona Cmd + Shift + R (recarga forzada)"
echo "   3. O presiona Cmd + Shift + Delete"
echo "   4. Selecciona 'Todo el tiempo' y 'Todo'"
echo "   5. Haz clic en 'Borrar datos'"
echo "   6. Reinicia Chrome"

echo ""
echo "🌐 URLs de acceso:"
echo "   Principal: http://localhost:8080"
echo "   Alternativa: http://127.0.0.1:8080"

echo ""
echo "🔐 Credenciales:"
echo "   Usuario: admin"
echo "   Contraseña: 1234"

echo ""
echo "💡 Si el problema persiste:"
echo "   1. Usa modo incógnito/privado"
echo "   2. Prueba con IP directa: http://127.0.0.1:8080"
echo "   3. Verifica que no haya otros servicios en puerto 8080"
echo "   4. Reinicia el sistema: ./restart-system.sh"

echo ""
echo "🎯 Comando para abrir directamente:"
echo "   open http://localhost:8080"
