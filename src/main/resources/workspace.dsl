workspace "Sistema de Gestión Empresarial" "Plataforma integral para gestión de recursos empresariales" {

    !identifiers hierarchical

    model {
        // Usuarios del sistema
        admin = person "Administrador del Sistema" "Gestiona usuarios, configuraciones y mantenimiento del sistema"
        manager = person "Gerente" "Supervisa operaciones y genera reportes ejecutivos"
        employee = person "Empleado" "Utiliza las funcionalidades diarias del sistema"
        customer = person "Cliente" "Accede al portal de autogestión"

        // Sistema principal
        erp = softwareSystem "Sistema ERP" "Plataforma central de gestión empresarial" {
            
            // Contenedores principales
            webApp = container "Aplicación Web" "Interfaz principal del sistema" "Spring Boot, React" "Web Application" {
                auth = component "Módulo de Autenticación" "Gestiona autenticación y autorización" "Spring Security, JWT"
                userMgmt = component "Gestión de Usuarios" "Administra usuarios y roles" "Spring Boot"
                dashboard = component "Dashboard" "Panel de control y métricas" "React, Chart.js"
                reports = component "Generador de Reportes" "Crea reportes personalizados" "JasperReports"
            }
            
            api = container "API Gateway" "Punto de entrada unificado para todas las APIs" "Spring Cloud Gateway" "API Gateway" {
                rateLimiter = component "Rate Limiter" "Controla el tráfico de requests" "Redis"
                authFilter = component "Filtro de Autenticación" "Valida tokens JWT" "Spring Security"
                loadBalancer = component "Load Balancer" "Distribuye la carga entre servicios" "Netflix Ribbon"
            }
            
            // Microservicios
            inventory = container "Servicio de Inventario" "Gestiona productos, stock y categorías" "Spring Boot, MongoDB" "Microservice" {
                productMgmt = component "Gestión de Productos" "CRUD de productos y categorías" "Spring Data"
                stockControl = component "Control de Stock" "Maneja niveles de inventario" "Spring Boot"
                barcodeScanner = component "Escáner de Códigos" "Procesa códigos de barras" "ZXing"
            }
            
            sales = container "Servicio de Ventas" "Gestiona pedidos, facturas y clientes" "Spring Boot, PostgreSQL" "Microservice" {
                orderMgmt = component "Gestión de Pedidos" "Procesa órdenes de venta" "Spring Boot"
                invoiceGen = component "Generador de Facturas" "Crea facturas electrónicas" "Apache PDFBox"
                customerMgmt = component "Gestión de Clientes" "Mantiene datos de clientes" "Spring Data"
            }
            
            hr = container "Servicio de RRHH" "Gestiona empleados, nóminas y ausencias" "Spring Boot, MySQL" "Microservice" {
                employeeMgmt = component "Gestión de Empleados" "Mantiene datos de empleados" "Spring Data"
                payroll = component "Nómina" "Calcula salarios y beneficios" "Spring Boot"
                attendance = component "Control de Asistencia" "Registra entradas y salidas" "Spring Boot"
            }
            
            finance = container "Servicio Financiero" "Gestiona contabilidad y presupuestos" "Spring Boot, PostgreSQL" "Microservice" {
                accounting = component "Contabilidad" "Maneja cuentas y transacciones" "Spring Boot"
                budgetMgmt = component "Gestión de Presupuestos" "Controla presupuestos por departamento" "Spring Boot"
                taxCalculator = component "Calculadora de Impuestos" "Calcula impuestos automáticamente" "Spring Boot"
            }
            
            // Base de datos
            mainDb = container "Base de Datos Principal" "Almacena datos transaccionales" "PostgreSQL" "Database" {
                userTable = component "Tabla de Usuarios" "Datos de usuarios y autenticación"
                auditTable = component "Tabla de Auditoría" "Logs de cambios y accesos"
            }
            
            cache = container "Sistema de Cache" "Mejora el rendimiento con cache distribuido" "Redis Cluster" "Cache"
            
            // Servicios externos
            emailService = container "Servicio de Email" "Envía notificaciones por email" "SendGrid API" "External Service"
            smsService = container "Servicio de SMS" "Envía notificaciones por SMS" "Twilio API" "External Service"
            paymentGateway = container "Pasarela de Pagos" "Procesa pagos con tarjeta" "Stripe API" "External Service"
        }
        
        // Sistema de BI
        bi = softwareSystem "Sistema de Business Intelligence" "Análisis avanzado y reportes ejecutivos" {
            dataWarehouse = container "Data Warehouse" "Almacén de datos para análisis" "Snowflake" "Database"
            etl = container "Proceso ETL" "Extrae, transforma y carga datos" "Apache Airflow" "ETL Tool"
            biDashboard = container "Dashboard BI" "Visualizaciones y reportes" "Tableau" "BI Tool"
        }
        
        // Sistema de Monitoreo
        monitoring = softwareSystem "Sistema de Monitoreo" "Monitoreo y alertas del sistema" {
            prometheus = container "Prometheus" "Recolecta métricas del sistema" "Prometheus" "Monitoring"
            grafana = container "Grafana" "Visualización de métricas" "Grafana" "Monitoring"
            alertManager = container "Alert Manager" "Gestiona alertas y notificaciones" "AlertManager" "Monitoring"
        }

        // Relaciones entre usuarios y sistemas
        admin -> erp "Administra"
        manager -> erp "Genera reportes y supervisa"
        employee -> erp "Utiliza funcionalidades diarias"
        customer -> erp.webApp "Accede al portal de autogestión"
        
        // Relaciones internas del ERP
        erp.webApp -> erp.api "Consume APIs"
        erp.api -> erp.inventory "Rutas a /inventory/*"
        erp.api -> erp.sales "Rutas a /sales/*"
        erp.api -> erp.hr "Rutas a /hr/*"
        erp.api -> erp.finance "Rutas a /finance/*"
        
        // Relaciones entre microservicios
        erp.sales -> erp.inventory "Consulta stock disponible"
        erp.sales -> erp.paymentGateway "Procesa pagos"
        erp.hr -> erp.finance "Envía datos de nómina"
        
        // Relaciones con base de datos
        erp.inventory -> erp.mainDb "Persiste datos de productos"
        erp.sales -> erp.mainDb "Persiste datos de ventas"
        erp.hr -> erp.mainDb "Persiste datos de empleados"
        erp.finance -> erp.mainDb "Persiste datos financieros"
        
        // Relaciones con cache
        erp.webApp -> erp.cache "Cachea sesiones y datos frecuentes"
        erp.api -> erp.cache "Cachea respuestas de APIs"
        
        // Relaciones con servicios externos
        erp.sales -> erp.emailService "Envía confirmaciones de pedido"
        erp.hr -> erp.smsService "Envía notificaciones de ausencia"
        
        // Relaciones para el flujo de pedidos
        erp.sales -> erp.webApp "Retorna respuesta de pedido"
        
        // Relaciones con BI
        erp -> bi "Envía datos para análisis"
        bi.etl -> erp "Extrae datos del ERP"
        bi.biDashboard -> bi.dataWarehouse "Consulta datos para reportes"
        
        // Relaciones con monitoreo
        erp -> monitoring "Envía métricas"
        monitoring.grafana -> monitoring.prometheus "Consulta métricas"
        monitoring.alertManager -> erp.emailService "Envía alertas por email"
    }

    views {
        // Vista de contexto del sistema
        systemContext erp "context" {
            include *
            autolayout lr
        }
        
        // Vista de contenedores del ERP
        container erp "containers" {
            include *
            autolayout tb
        }
        
        // Vista de componentes de la aplicación web
        component erp.webApp "webapp-components" {
            include *
            autolayout lr
        }
        
        // Vista de componentes del API Gateway
        component erp.api "api-components" {
            include *
            autolayout lr
        }
        
        // Vista de componentes del servicio de inventario
        component erp.inventory "inventory-components" {
            include *
            autolayout lr
        }
        
        // Vista de componentes del servicio de ventas
        component erp.sales "sales-components" {
            include *
            autolayout lr
        }
        
        // Vista de componentes del servicio de RRHH
        component erp.hr "hr-components" {
            include *
            autolayout lr
        }
        
        // Vista de componentes del servicio financiero
        component erp.finance "finance-components" {
            include *
            autolayout lr
        }
        
        // Vista de componentes de la base de datos
        component erp.mainDb "database-components" {
            include *
            autolayout lr
        }
        
        // Vista dinámica - Flujo de procesamiento de pedidos
        dynamic erp "order-flow" {
            customer -> erp.webApp "1. Crea pedido"
            erp.webApp -> erp.api "2. Envía request"
            erp.api -> erp.sales "3. Procesa pedido"
            erp.sales -> erp.inventory "4. Verifica stock"
            erp.sales -> erp.paymentGateway "5. Procesa pago"
            erp.sales -> erp.emailService "6. Envía confirmación"
            erp.sales -> erp.webApp "7. Retorna respuesta"
            erp.webApp -> customer "8. Muestra confirmación"
        }
        


        // Estilos personalizados
        styles {
            element "Person" {
                shape person
                color #08427B
            }
            element "Software System" {
                color #1168BD
            }
            element "Container" {
                color #438DD5
            }
            element "Component" {
                color #85BBF0
            }
            element "Database" {
                shape cylinder
                color #FF8C00
            }
            element "Cache" {
                color #FFD700
            }
            element "External Service" {
                color #999999
            }
            element "API Gateway" {
                color #FF6B6B
            }
            element "Microservice" {
                color #4ECDC4
            }
            element "Web Application" {
                color #45B7D1
            }
            element "Monitoring" {
                color #96CEB4
            }
            element "BI Tool" {
                color #FFEAA7
            }
            element "ETL Tool" {
                color #000000
            }
            
            relationship "Relationship" {
                thickness 2
                color #707070
            }
        }
    }

}
