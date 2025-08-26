# Sistema ERP - Arquitectura con Structurizr DSL

Este proyecto contiene una definición completa de arquitectura de software para un Sistema ERP empresarial utilizando Structurizr DSL (Domain Specific Language). Incluye una aplicación Java para validar el DSL y exportarlo a JSON, además de instrucciones para visualizar la arquitectura con Structurizr Lite.

## 📋 Contenido del Proyecto

### Arquitectura Definida

El `workspace.dsl` define una arquitectura completa de Sistema ERP con:

- **4 Personas**: Administrador, Gerente, Empleado, Cliente
- **3 Sistemas de Software**: ERP, Business Intelligence, Monitoreo
- **17 Contenedores**: Microservicios, APIs, Bases de datos, Cache
- **21 Componentes**: Módulos internos de cada servicio
- **Múltiples Vistas**: Contexto, Contenedores, Componentes, Flujos dinámicos

### Estructura del Proyecto

```
structurizrapp/
├── src/
│   └── main/
│       ├── java/
│       │   └── demo/
│       │       └── Main.java          # Validador y exportador DSL
│       └── resources/
│           └── workspace.dsl          # Definición de arquitectura
├── build.gradle                       # Configuración Gradle
├── gradlew                            # Gradle wrapper (Unix/macOS)
├── gradlew.bat                        # Gradle wrapper (Windows)
├── validate-dsl.sh                    # Validación básica DSL
└── README.md                          # Este archivo
```

## 🚀 Configuración Inicial

### Prerrequisitos

1. **Java Development Kit (JDK) 17 o superior**
2. **Docker** (para Structurizr Lite)
3. **Gradle** (incluido en el proyecto)

### Instalación de JDK

#### Opción 1: Descarga desde Oracle (Recomendado)

1. Ve a https://www.oracle.com/java/technologies/downloads/
2. Descarga JDK 17 o superior para macOS
3. Instala el archivo `.dmg` descargado

#### Opción 2: Usando Homebrew

```bash
# Instalar Homebrew (si no lo tienes)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar OpenJDK
brew install openjdk@17
```

#### Opción 3: Usando SDKMAN!

```bash
# Instalar SDKMAN!
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Instalar Java
sdk install java 17.0.9-tem
```

### Verificar la Instalación

```bash
# Verificar Java
java -version

# Verificar JDK (debe mostrar javac)
javac -version

# Verificar JAVA_HOME
echo $JAVA_HOME
```

Si `JAVA_HOME` no apunta al JDK correcto, configúralo:

```bash
# Para macOS con Oracle JDK
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home

# Para Homebrew OpenJDK
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Agregar a tu shell profile (~/.zshrc o ~/.bash_profile)
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 17)' >> ~/.zshrc
source ~/.zshrc
```

## 🔧 Build y Validación

### Validación Básica

```bash
# Validación rápida del DSL
./validate-dsl.sh
```

### Validación Básica (Recomendado para Java 24)

```bash
# Validación básica sin dependencias externas
./validate-dsl-basic.sh
```

### Validación con Java Directo (Solo para Java 17-21)

```bash
# Validación usando Java directamente (evita problemas de Gradle)
./validate-dsl-simple.sh
```

### Build Completo del Proyecto

```bash
# Hacer el build del proyecto
./gradlew build
```

### Validación y Exportación

```bash
# Ejecutar el validador completo
./gradlew run
```

## 🚀 Scripts Disponibles

### Scripts Principales

- **`./start-simple.sh`** - Levanta Structurizr Lite con autenticación (admin/1234)
- **`./restart-system.sh`** - Reinicia completamente el sistema (solución a problemas de login)
- **`./validate-dsl-basic.sh`** - Validación básica del DSL (recomendado para Java 24)
- **`./validate-dsl-simple.sh`** - Valida el DSL usando Java directamente (Java 17-21)
- **`./validate-dsl.sh`** - Validación básica del DSL

### Scripts Adicionales

- **`./start-with-auth.sh`** - Versión avanzada con nginx y autenticación
- **`./start-system.sh`** - Script completo con Spring Boot (requiere Java 17-21)
- **`./cleanup.sh`** - Limpia contenedores y archivos temporales

Esto realizará:

1. ✅ Parse del archivo DSL
2. ✅ Validación de sintaxis
3. ✅ Verificación de relaciones
4. ✅ Conteo de elementos
5. ✅ Exportación a JSON (si se implementa)

**Salida esperada:**

```
✅ Workspace cargado exitosamente: Sistema de Gestión Empresarial
✅ DSL validado correctamente
📊 Elementos encontrados:
   - Personas: 4
   - Sistemas de Software: 3
   - Contenedores: 17
   - Componentes: 21
```

## 🌐 Visualización con Structurizr Lite

### Opción 1: Con Autenticación (Recomendado)

```bash
# Ejecutar el script que incluye login
./start-simple.sh
```

**Credenciales de acceso:**

- **Usuario**: `admin`
- **Contraseña**: `1234`
- **URL**: http://localhost:8080

### Opción 2: Sin Autenticación

```bash
# Ejecutar Structurizr Lite directamente
docker run -d -p 8080:8080 -v $(pwd)/src/main/resources:/usr/local/structurizr structurizr/lite

# Verificar que esté ejecutándose
docker ps

# Ver logs si es necesario
docker logs <container_id>
```

### Opción 3: Usando JAR

1. Descarga Structurizr Lite desde: https://github.com/structurizr/lite/releases
2. Ejecuta:
   ```bash
   java -jar structurizr-lite.jar -workspace src/main/resources/workspace.dsl
   ```

### Acceso a la Visualización

1. Abre tu navegador
2. Ve a: **http://localhost:8080**
3. Si usas autenticación, ingresa las credenciales
4. Explora las diferentes vistas de tu arquitectura

## 📊 Vistas Disponibles

Una vez que accedas a Structurizr Lite, podrás ver:

### 1. Vista de Contexto del Sistema

- Interacción entre usuarios y el sistema ERP
- Sistemas externos (BI, Monitoreo)

### 2. Vista de Contenedores

- Arquitectura interna del ERP
- Microservicios, APIs, Bases de datos

### 3. Vistas de Componentes

- Detalle de cada servicio:
  - **WebApp**: Autenticación, Dashboard, Reportes
  - **API Gateway**: Rate Limiter, Load Balancer
  - **Microservicios**: Inventario, Ventas, RRHH, Finanzas
  - **Base de Datos**: Tablas y componentes

### 4. Vista Dinámica

- Flujo de procesamiento de pedidos
- Interacciones entre componentes

## 🎨 Personalización

### Estilos Personalizados

El DSL incluye estilos personalizados para:

- **Personas**: Color azul, forma de persona
- **Sistemas**: Diferentes colores por tipo
- **Contenedores**: Colores específicos por tecnología
- **Relaciones**: Grosor y color personalizados

### Modificar la Arquitectura

Para modificar la arquitectura:

1. Edita `src/main/resources/workspace.dsl`
2. Ejecuta `./gradlew run` para validar
3. Recarga Structurizr Lite para ver los cambios

## 🔍 Troubleshooting

### Error: "Could not find tools.jar"

**Problema**: Tienes JRE pero necesitas JDK
**Solución**: Instala un JDK (ver sección de instalación)

### Error: "No matching variant found"

**Problema**: Versión de Java incompatible
**Solución**: Usa Java 17 o superior

### Error: "Unsupported class file major version 68"

**Problema**: Java 24 no es compatible con Gradle actual
**Solución**:

```bash
# Usar validación básica (recomendado para Java 24)
./validate-dsl-basic.sh

# O instalar Java 17-21 para usar Gradle
```

### Error: "Permission denied"

**Problema**: Scripts no ejecutables
**Solución**:

```bash
chmod +x gradlew
chmod +x validate-dsl.sh
```

### Error: "Relationship does not exist in model"

**Problema**: Relaciones en vistas dinámicas no definidas en el modelo
**Solución**: Asegúrate de que todas las relaciones usadas en vistas dinámicas estén definidas en la sección `model`

### Error: "Bootstrap CSS 404"

**Problema**: Advertencias del navegador sobre source maps
**Solución**: Estos errores son normales y no afectan la funcionalidad. Puedes ignorarlos.

### Error: "No se pudo conectar al sistema"

**Problema**: Los contenedores Docker no se iniciaron correctamente
**Solución**:

```bash
# Verificar que Docker esté ejecutándose
docker info

# Detener y limpiar contenedores
docker stop $(docker ps -q)
docker rm $(docker ps -aq)

# Ejecutar nuevamente
./start-simple.sh
```

### Error: "Puerto 8080 ya está en uso"

**Problema**: Otro servicio está usando el puerto 8080
**Solución**:

```bash
# Verificar qué está usando el puerto
lsof -i :8080

# Detener el proceso o usar otro puerto
# Para cambiar puerto, edita nginx.conf y cambia "listen 8080" por "listen 8081"
```

### Error: "No me deja iniciar sesión, se queda en el formulario"

**Problema**: Problemas de caché del navegador o configuración de autenticación
**Solución**:

```bash
# Reiniciar completamente el sistema
./restart-system.sh

# Si persiste, intentar en el navegador:
# 1. Limpiar caché (Cmd+Shift+R en macOS)
# 2. Abrir en modo incógnito
# 3. Cerrar y abrir el navegador
```

### Error: "Password mismatch" en logs de nginx

**Problema**: Hash de contraseña incorrecto
**Solución**:

```bash
# Reiniciar el sistema (regenera el hash correcto)
./restart-system.sh
```

## 📚 Recursos

- [Structurizr DSL Documentation](https://github.com/structurizr/dsl)
- [Structurizr Core](https://github.com/structurizr/core)
- [Structurizr Lite](https://github.com/structurizr/lite)
- [C4 Model](https://c4model.com/)

## 🤝 Contribución

Para contribuir al proyecto:

1. Fork el repositorio
2. Crea una rama para tu feature
3. Haz los cambios en el DSL
4. Valida con `./gradlew run`
5. Envía un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo LICENSE para más detalles.

---

**¡Disfruta explorando tu arquitectura de Sistema ERP!** 🚀
