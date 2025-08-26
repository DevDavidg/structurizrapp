# Dockerfile para Structurizr ERP en Render (Definitivo)
FROM eclipse-temurin:17-jre-jammy
WORKDIR /usr/local/structurizr

# Descargar Structurizr Lite
RUN curl -L -o ./structurizr-lite.war \
    "https://github.com/structurizr/lite/releases/download/v2025.05.28/structurizr-lite.war" && \
    echo "Structurizr Lite descargado correctamente"

# Copiar workspace DSL
COPY src/main/resources/workspace.dsl ./workspace.dsl
# OJO: no copies workspace.json si está vacío

# Script de arranque optimizado
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Configuración de entorno
ENV STRUCTURIZR_DATA_DIRECTORY=/usr/local/structurizr
ENV JAVA_TOOL_OPTIONS="-Xms128m -Xmx512m -Djava.awt.headless=true"
ENV STRUCTURIZR_URL="https://structurizr-erp.onrender.com"

EXPOSE 8080
CMD ["/usr/local/bin/start.sh"]
