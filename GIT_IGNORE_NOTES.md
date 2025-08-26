# Notas sobre .gitignore

## Archivos Ignorados

### Archivos de Configuración Local

- `nginx.conf` - Configuración de nginx generada automáticamente
- `.htpasswd` - Archivo de contraseñas generado automáticamente
- `gradle.properties` - Configuración específica del entorno local

### Directorios de Build y Temporales

- `.gradle/` - Caché de Gradle
- `build/` - Archivos compilados
- `temp-build/` - Archivos temporales de compilación
- `.structurizr/` - Caché de Structurizr

### Archivos Generados

- `workspace.json` - Archivo JSON generado por Structurizr
- `*.log` - Archivos de log
- `*.class`, `*.jar` - Archivos compilados de Java

### Archivos del Sistema Operativo

- `.DS_Store` (macOS)
- `Thumbs.db` (Windows)
- Archivos temporales del sistema

## Archivos de Ejemplo Incluidos

### Configuración

- `nginx.conf.example` - Ejemplo de configuración de nginx
- `gradle.properties.example` - Ejemplo de configuración de Gradle

### Scripts de Desarrollo

Los siguientes scripts están incluidos en el repositorio:

- `start-simple.sh` - Inicia el sistema con autenticación
- `restart-system.sh` - Reinicia el sistema completo
- `cleanup.sh` - Limpia contenedores Docker
- `validate-dsl-basic.sh` - Validación básica del DSL
- `validate-dsl-simple.sh` - Validación con Java directo
- `test-access.sh` - Prueba de conectividad
- `diagnose-connection.sh` - Diagnóstico de problemas
- `clear-browser-cache.sh` - Guía de limpieza de caché

## Cómo Usar

### Configuración Inicial

1. Copia `nginx.conf.example` a `nginx.conf`
2. Copia `gradle.properties.example` a `gradle.properties`
3. Modifica los archivos según tu entorno

### Generación de Archivos

Los scripts generarán automáticamente:

- `nginx.conf` - Configuración de nginx
- `.htpasswd` - Archivo de contraseñas
- `workspace.json` - Archivo de Structurizr

### Comandos Útiles

```bash
# Ver archivos ignorados
git status --ignored

# Ver qué archivos serían trackeados
git add . && git status

# Limpiar archivos ignorados del staging
git reset
```

## Notas Importantes

- Los archivos de ejemplo (`.example`) están incluidos en el repositorio
- Los archivos generados automáticamente están ignorados
- Los scripts de desarrollo están incluidos para facilitar el uso
- El archivo `workspace.dsl` es el único archivo de configuración de Structurizr incluido
