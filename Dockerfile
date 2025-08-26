# Dockerfile para Structurizr ERP en Render (Optimizado)
FROM eclipse-temurin:17-jre-jammy

WORKDIR /usr/local/structurizr

# Descargar Structurizr Lite
RUN curl -L -o /usr/local/structurizr/structurizr-lite.war \
    "https://github.com/structurizr/lite/releases/download/v2025.05.28/structurizr-lite.war" && \
    echo "Structurizr Lite descargado correctamente"

# Copiar workspace DSL
COPY src/main/resources/workspace.dsl /usr/local/structurizr/workspace.dsl

# NO copiar workspace.json si está vacío (causa errores)
# COPY workspace.json /usr/local/structurizr/workspace.json

# Crear índice de búsqueda
RUN mkdir -p /usr/local/structurizr/.structurizr/index

# Copiar script de limpieza
COPY clean-workspace.sh /usr/local/structurizr/clean-workspace.sh
RUN chmod +x /usr/local/structurizr/clean-workspace.sh

# Configuración de entorno
ENV STRUCTURIZR_DATA_DIRECTORY=/usr/local/structurizr
ENV JAVA_TOOL_OPTIONS="-Xms128m -Xmx512m -Djava.awt.headless=true"
ENV STRUCTURIZR_URL="https://structurizr-erp.onrender.com"

EXPOSE 8080

CMD sh -lc '/usr/local/structurizr/clean-workspace.sh && java -Djdk.util.jar.enableMultiRelease=false \
  -jar /usr/local/structurizr/structurizr-lite.war /usr/local/structurizr \
  --server.address=0.0.0.0 \
  --server.port=${PORT:-8080} \
  --spring.profiles.active=production \
  --structurizr.lite.preview-features=false'
