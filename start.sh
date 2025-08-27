#!/usr/bin/env sh
set -eu

DATA_DIR=/usr/local/structurizr
cd "$DATA_DIR"

# borrar JSON vacío (causaba 500)
if [ -f workspace.json ] && [ ! -s workspace.json ]; then
  echo "workspace.json está vacío; se elimina para usar workspace.dsl"
  rm -f workspace.json
fi

# índice de búsqueda (silencia el warning de Lucene)
mkdir -p "$DATA_DIR/.structurizr/index"

# URL pública detrás de proxy (opcional pero útil)
if [ -n "${STRUCTURIZR_URL:-}" ]; then
  printf 'structurizr.url=%s\n' "$STRUCTURIZR_URL" > "$DATA_DIR/structurizr.properties"
fi

# ligar a 0.0.0.0 y respetar $PORT de Render
exec java -jar "$DATA_DIR/structurizr-lite.war" "$DATA_DIR" \
  --server.address=0.0.0.0 \
  --server.port="${PORT:-8080}" \
  --spring.profiles.active=production \
  --structurizr.lite.preview-features=false
