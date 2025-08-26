#!/bin/bash

echo "🔍 Diagnóstico de Conectividad - Sistema ERP"
echo "============================================="

echo ""
echo "📊 Estado de los contenedores:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "🌐 Verificando conectividad local:"
echo "   Probando localhost:8080..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "401\|302"; then
    echo "   ✅ Servidor respondiendo correctamente"
else
    echo "   ❌ Servidor no responde"
fi

echo ""
echo "🔧 Verificando puerto 8080:"
if lsof -i :8080 > /dev/null 2>&1; then
    echo "   ✅ Puerto 8080 está en uso por Docker"
else
    echo "   ❌ Puerto 8080 no está en uso"
fi

echo ""
echo "📋 Información de acceso:"
echo "   🌐 URL: http://localhost:8080"
echo "   👤 Usuario: admin"
echo "   🔑 Contraseña: 1234"

echo ""
echo "💡 Soluciones si Safari no conecta:"
echo "   1. Limpia caché: Cmd + Shift + R"
echo "   2. Modo incógnito: Cmd + Shift + N"
echo "   3. Prueba con IP directa: http://127.0.0.1:8080"
echo "   4. Verifica firewall de macOS"
echo "   5. Reinicia Safari completamente"
echo "   6. Si redirige sin puerto, reinicia: ./restart-system.sh"

echo ""
echo "🔍 Últimos logs de nginx:"
docker logs --tail 5 nginx-auth 2>/dev/null || echo "   No se pueden obtener logs"

echo ""
echo "🎯 Prueba manual:"
echo "   curl -u admin:1234 http://localhost:8080"
