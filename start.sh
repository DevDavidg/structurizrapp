#!/usr/bin/env sh
set -euo pipefail

DATA_DIR=/usr/local/structurizr
cd "$DATA_DIR"

echo "🚀 Iniciando Structurizr Lite con auto-corrección..."

# Verificar workspace.dsl
if [ ! -f "workspace.dsl" ]; then
    echo "❌ Error: workspace.dsl no encontrado"
    exit 1
fi
echo "✅ workspace.dsl encontrado ($(wc -l < workspace.dsl) líneas)"

# Borrar JSON vacío para evitar 500 en "/"
if [ -f workspace.json ] && [ ! -s workspace.json ]; then
    echo "⚠️  workspace.json está vacío; se elimina para usar workspace.dsl"
    rm -f workspace.json
    echo "✅ workspace.json vacío eliminado"
elif [ -f workspace.json ]; then
    echo "✅ workspace.json encontrado con contenido ($(wc -c < workspace.json) bytes)"
else
    echo "✅ No existe workspace.json - usando solo workspace.dsl"
fi

# Asegurar índice de búsqueda
echo "📁 Creando directorio de índice..."
mkdir -p "$DATA_DIR/.structurizr/index"
echo "✅ Directorio de índice creado"

# Configurar URL pública para enlaces correctos detrás de proxy
if [ -n "${STRUCTURIZR_URL:-}" ]; then
    echo "🌐 Configurando URL pública: $STRUCTURIZR_URL"
    echo "structurizr.url=${STRUCTURIZR_URL}" > "$DATA_DIR/structurizr.properties"
    echo "✅ structurizr.properties creado"
fi

echo "📊 Iniciando Structurizr Lite..."
echo "   Puerto: ${PORT:-8080}"
echo "   Dirección: 0.0.0.0"
echo "   Perfil: production"

exec java -jar "$DATA_DIR/structurizr-lite.war" "$DATA_DIR" \
  --server.address=0.0.0.0 \
  --server.port="${PORT:-8080}" \
  --spring.profiles.active=production \
  --structurizr.lite.preview-features=false
