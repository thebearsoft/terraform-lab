# Episodio 5: La Revelación de la Inyección de Variables
## Duración: 22 minutos | Complejidad: Intermedio

### Configuración de la Historia: Marco de Nancy Duarte

**LO QUE ES (Realidad Dolorosa Actual)**
La infraestructura modular de Sarah está funcionando de maravillas para staging y producción en EE.UU. Pero Bearsoft.ai se está expandiendo a Europa, y el equipo de compliance tiene requerimientos estrictos: los datos europeos deben quedarse en regiones europeas, usar estándares de cifrado diferentes, y seguir configuraciones específicas de GDPR. Mientras tanto, el equipo de desarrollo quiere entornos livianos para pruebas de funcionalidades, y el equipo de seguridad demanda diferentes controles de acceso para cada entorno. Sarah trata de manejar esto con variables simples pero rápidamente se da cuenta de que tiene docenas de configuraciones específicas por entorno para gestionar. Sus archivos de variables se están volviendo inmanejables, y está perdiendo el rastro de qué configuración se aplica dónde.

**LO QUE PODRÍA SER (Visión de un Mejor Futuro)**
Imagínate un sistema donde configuraciones complejas y específicas por entorno son organizadas, predecibles y mantenibles. Visualizá poder desplegar la misma infraestructura con requerimientos completamente diferentes de compliance, dimensionamiento de recursos y configuraciones de seguridad - todo gestionado a través de patrones elegantes de inyección de variables que escalan a entornos y requerimientos ilimitados.

### Objetivos de Aprendizaje

1. Dominar precedencia avanzada de variables y patrones de inyección
2. Implementar estrategias de configuración específicas por entorno
3. Aprender manejo de variables sensibles y mejores prácticas de seguridad
4. Diseñar sistemas escalables de gestión de configuración
5. Manejar despliegues complejos multi-región y multi-compliance

### Desarrollo de la Historia

El viaje de dominio de inyección de variables de Sarah:
- Descubre la complejidad de requerimientos reales de entorno
- Aprende el sistema de precedencia de variables de Terraform
- Implementa el patrón de variables de dos niveles de nuestro repositorio
- Domina la gestión de variables sensibles
- Construye confianza en gestión de configuración compleja

### Script de Asciinema 1: La Explosión de Configuración

```bash
# Título: "Cuando las Variables Simples se Vuelven Configuración Compleja"
echo "Los requerimientos de expansión de Sarah se están volviendo complejos..."
echo "Veamos lo que necesita manejar ahora:"
echo ""

# Mostrar la complejidad creciente
cat > requerimientos.txt << 'EOF'
Requerimientos de Entornos:

US-STAGING:
- Región: us-central1
- Tipos de máquina: e2-small (optimización de costos)
- Residencia de datos: EE.UU.
- Cifrado: Cifrado estándar de GCP
- Compliance: SOC2
- Cantidad de nodos: 1-3 nodos
- Monitoreo: Básico

US-PRODUCTION:
- Región: us-central1  
- Tipos de máquina: e2-standard-4
- Residencia de datos: EE.UU.
- Cifrado: Claves gestionadas por cliente
- Compliance: SOC2 + HIPAA
- Cantidad de nodos: 3-10 nodos
- Monitoreo: Avanzado + alertas

EU-STAGING:
- Región: europe-west1
- Tipos de máquina: e2-small
- Residencia de datos: Solo UE
- Cifrado: Claves compatibles con UE
- Compliance: GDPR + SOC2
- Cantidad de nodos: 1-3 nodos
- Monitoreo: Logging compatible con GDPR

EU-PRODUCTION:
- Región: europe-west1
- Tipos de máquina: e2-standard-4
- Residencia de datos: Solo UE  
- Cifrado: Claves compatibles con UE
- Compliance: GDPR + SOC2 + ISO27001
- Cantidad de nodos: 3-15 nodos
- Monitoreo: Avanzado + protección de datos UE

FEATURE-TESTING:
- Región: us-central1
- Tipos de máquina: e2-micro
- Residencia de datos: EE.UU.
- Cifrado: Ninguno (solo datos de prueba)
- Compliance: Ninguno
- Cantidad de nodos: 1 nodo
- Monitoreo: Ninguno
- Auto-destruir: Después de 24 horas
EOF

cat requerimientos.txt
echo ""

echo "El primer intento de Sarah con variables simples:"
cat > variables_desordenadas.tf << 'EOF'
# Este enfoque rápidamente se vuelve inmanejable...

variable "cluster_name" { default = "bearsoft-staging" }
variable "region" { default = "us-central1" }
variable "machine_type" { default = "e2-small" }
variable "min_nodes" { default = 1 }
variable "max_nodes" { default = 3 }
variable "enable_monitoring" { default = false }
variable "enable_eu_compliance" { default = false }
variable "enable_hipaa" { default = false }
variable "enable_encryption" { default = false }
variable "encryption_key_ring" { default = "" }
variable "data_residency_region" { default = "us" }
variable "compliance_logging" { default = false }
variable "auto_destroy_hours" { default = 0 }
variable "feature_testing_mode" { default = false }
variable "gdpr_compliance_mode" { default = false }
# ... 50+ variables más específicas por entorno
EOF

cat variables_desordenadas.tf
echo ""

echo "Problemas con este enfoque:"
echo "❌ Archivos de variables enormes que son difíciles de mantener"
echo "❌ Fácil configurar combinaciones conflictivas de variables"
echo "❌ No hay organización clara por entorno"
echo "❌ Difícil entender qué variables se aplican dónde"
echo "❌ Errores de copiar-pegar entre entornos"

rm requerimientos.txt variables_desordenadas.tf
```

### Script de Asciinema 2: Entendiendo la Precedencia de Variables

```bash
# Título: "Sistema de Precedencia de Variables de Terraform"
echo "Sarah aprende cómo Terraform resuelve variables de múltiples fuentes..."
echo ""

echo "Precedencia de Variables de Terraform (menor a mayor prioridad):"
echo ""

cat > ejemplo_precedencia.txt << 'EOF'
1. Defaults de variables (en variables.tf)
   variable "machine_type" {
     default = "e2-micro"
   }

2. Variables de entorno (TF_VAR_*)
   export TF_VAR_machine_type="e2-small"

3. archivo terraform.tfvars
   machine_type = "e2-medium"

4. archivos *.auto.tfvars (orden alfabético)
   staging.auto.tfvars: machine_type = "e2-standard-2"

5. flags -var de línea de comandos
   terraform apply -var="machine_type=e2-standard-4"

6. flags -var-file de línea de comandos  
   terraform apply -var-file="production.tfvars"
EOF

cat ejemplo_precedencia.txt
echo ""

echo "¡Este sistema de precedencia permite estrategias de configuración sofisticadas!"
echo ""

echo "Veamos cómo nuestro repositorio de Bearsoft usa este sistema:"
echo ""

# Mostrar nuestra estrategia real de variables
echo "Nuestro patrón de inyección de variables de dos niveles:"
echo ""

echo "Nivel 1: Variables globales (compartidas entre capas)"
ls -la environments/staging/
echo ""

echo "environments/staging/global.tfvars contiene:"
head -15 environments/staging/global.tfvars
echo "# ... más configuración global ..."
echo ""

echo "Nivel 2: Overrides específicos por capa"
echo "environments/staging/infrastructure.tfvars contiene:"
cat environments/staging/infrastructure.tfvars
echo ""

echo "Este patrón proporciona:"
echo "✅ Configuración compartida en global.tfvars"
echo "✅ Overrides específicos por capa cuando se necesitan"
echo "✅ Separación clara de entornos"
echo "✅ Cumplimiento del principio DRY"

rm ejemplo_precedencia.txt
```

### Script de Asciinema 3: Implementando Configuración Específica por Entorno

```bash
# Título: "Construyendo el Sistema de Variables de Dos Niveles"
echo "Sarah implementa nuestro patrón avanzado de inyección de variables..."
echo ""

echo "Examinemos cómo nuestro repositorio maneja configuraciones complejas:"
echo ""

echo "CONFIGURACIÓN GLOBAL (environments/staging/global.tfvars):"
echo "Contiene variables usadas en TODAS las capas:"
echo ""

grep -E "^(cluster_name|project_id|region|environment_name)" environments/staging/global.tfvars
echo ""

echo "CONFIGURACIÓN DE NODE POOL:"
grep -E "^(core_node_pool|worker_node_pool)" environments/staging/global.tfvars | head -6
echo ""

echo "FEATURE FLAGS:"
grep -E "^enable_" environments/staging/global.tfvars | head -4
echo ""

echo "Comparar con configuración de PRODUCCIÓN:"
echo ""

echo "Producción usa dimensionamiento diferente de recursos:"
echo "environments/production/global.tfvars:"
grep -E "machine_type.*=.*e2-" environments/production/global.tfvars
echo ""

echo "Producción habilita monitoreo adicional:"
grep -E "enable_cloud_monitoring" environments/production/global.tfvars
echo ""

echo "OVERRIDES ESPECÍFICOS POR CAPA:"
echo "Cada capa puede tener overrides específicos cuando se necesiten:"
echo ""

echo "environments/staging/kafka.tfvars:"
cat environments/staging/kafka.tfvars
echo ""

echo "Esto permite variables sensibles específicas por capa y configuraciones."
```

### Script de Asciinema 4: Gestión de Variables Sensibles

```bash
# Título: "Manejo Seguro de Variables Sensibles"
echo "Sarah aprende a manejar contraseñas, claves y secretos de forma segura..."
echo ""

echo "NUNCA poner valores sensibles directamente en archivos .tfvars:"
echo ""

cat > mal_ejemplo.tfvars << 'EOF'
# ❌ MALO: Secretos en control de versiones
database_password = "super-secret-password-123"
api_key = "ak-1234567890abcdef"
EOF

echo "❌ MAL EJEMPLO:"
cat mal_ejemplo.tfvars
echo ""

echo "✅ ENFOQUES BUENOS para variables sensibles:"
echo ""

echo "Método 1: Variables de Entorno"
echo "export TF_VAR_database_password='tu-contraseña-secreta'"
echo "export TF_VAR_webserver_default_user_password='contraseña-admin'"
echo ""

echo "Método 2: sensitive.tfvars separado (no en git)"
cat > sensitive.tfvars << 'EOF'
# Este archivo está en .gitignore
database_password = "contraseña-secreta-real"
webserver_default_user_password = "contraseña-admin-real"
EOF

echo "terraform apply -var-file='sensitive.tfvars'"
echo ""

echo "Método 3: Prompting interactivo"
cat > vars_interactivas.tf << 'EOF'
variable "database_password" {
  description = "Contraseña de base de datos para Kafka"
  type        = string
  sensitive   = true
  # Sin default = Terraform preguntará
}
EOF

echo "Cuando no se proporciona default, Terraform pregunta:"
echo "$ terraform apply"
echo "var.database_password"
echo "  Ingresá un valor: [entrada oculta]"
echo ""

echo "Método 4: Gestión externa de secretos"
echo "Usar herramientas como:"
echo "- Google Secret Manager"  
echo "- HashiCorp Vault"
echo "- Kubernetes Secrets"
echo "- Inyección de secretos en pipeline CI/CD"
echo ""

echo "Nuestros scripts de despliegue usan el Método 1:"
echo "Configurar variables de entorno antes de ejecutar scripts de despliegue"

rm mal_ejemplo.tfvars sensitive.tfvars vars_interactivas.tf
```

### Script de Asciinema 5: Patrones de Configuración Compleja

```bash
# Título: "Gestión Avanzada de Configuración"
echo "Sarah aprende patrones para gestionar configuraciones complejas y multi-entorno..."
echo ""

echo "PATRÓN 1: Configuración de Feature Flags"
echo "Controlar funcionalidades opcionales por entorno:"
echo ""

cat > feature_flags.tf << 'EOF'
# En variables.tf
variable "enable_monitoring" {
  description = "Habilitar monitoreo avanzado"
  type        = bool
  default     = false
}

variable "enable_backup" {
  description = "Habilitar backups automáticos"
  type        = bool
  default     = false
}

# En main.tf
resource "google_monitoring_workspace" "workspace" {
  count = var.enable_monitoring ? 1 : 0
  # ... configuración
}
EOF

cat feature_flags.tf
echo ""

echo "PATRÓN 2: Configuración Condicional de Recursos"
echo "Diferentes recursos basados en entorno:"
echo ""

cat > recursos_condicionales.tf << 'EOF'
# Diferentes tipos de máquina por entorno
locals {
  machine_type_map = {
    "staging"    = "e2-small"
    "production" = "e2-standard-4"
    "testing"    = "e2-micro"
  }
  
  node_count_map = {
    "staging"    = { min = 1, max = 3 }
    "production" = { min = 3, max = 10 }
    "testing"    = { min = 1, max = 1 }
  }
}

resource "google_container_node_pool" "primary" {
  node_config {
    machine_type = local.machine_type_map[var.environment_name]
  }
  
  autoscaling {
    min_node_count = local.node_count_map[var.environment_name].min
    max_node_count = local.node_count_map[var.environment_name].max
  }
}
EOF

cat recursos_condicionales.tf
echo ""

echo "PATRÓN 3: Validación de Configuración"
echo "Prevenir combinaciones inválidas de variables:"
echo ""

cat > validacion.tf << 'EOF'
variable "environment_name" {
  description = "Nombre del entorno"
  type        = string
  
  validation {
    condition = contains([
      "staging", 
      "production", 
      "development", 
      "testing"
    ], var.environment_name)
    error_message = "El entorno debe ser staging, production, development, o testing."
  }
}

variable "node_count" {
  description = "Número de nodos"
  type        = number
  
  validation {
    condition = var.node_count >= 1 && var.node_count <= 20
    error_message = "La cantidad de nodos debe estar entre 1 y 20."
  }
}
EOF

cat validacion.tf
echo ""

echo "Estos patrones proporcionan:"
echo "✅ Comportamiento específico por entorno"
echo "✅ Validación de configuración"
echo "✅ Gestión clara de funcionalidades"
echo "✅ Prevención de errores"

rm feature_flags.tf recursos_condicionales.tf validacion.tf
```

### Script de Asciinema 6: Integración de Scripts de Despliegue

```bash
# Título: "Automatizando la Inyección de Variables"
echo "Sarah aprende cómo los scripts de despliegue manejan gestión compleja de variables..."
echo ""

echo "Nuestros scripts de despliegue demuestran inyección de variables lista para producción:"
echo ""

# Mostrar cómo funcionan nuestros scripts
echo "scripts/deploy-staging.sh demuestra el patrón:"
echo ""

cat > extracto_script.sh << 'EOF'
#!/bin/bash
ENVIRONMENT="staging"

deploy_layer() {
    local layer=$1
    
    # Desplegar con variables tanto globales como específicas por capa
    terraform plan \
        -var-file="environments/$ENVIRONMENT/global.tfvars" \
        -var-file="environments/$ENVIRONMENT/$layer.tfvars" \
        -out="$layer.tfplan"
    
    terraform apply "$layer.tfplan"
}

# Desplegar todas las capas con inyección consistente de variables
deploy_layer "infrastructure"
deploy_layer "applications"
deploy_layer "kafka"
EOF

cat extracto_script.sh
echo ""

echo "Este enfoque proporciona:"
echo "✅ Aplicación consistente de variables entre capas"
echo "✅ Configuración específica por entorno"
echo "✅ Overrides específicos por capa cuando se necesiten"
echo "✅ Despliegues automatizados y repetibles"
echo ""

echo "Para variables sensibles, el script espera variables de entorno:"
echo "export TF_VAR_database_password='tu-contraseña'"
echo "export TF_VAR_webserver_default_user_password='contraseña-admin'"
echo "./scripts/deploy-staging.sh"
echo ""

echo "Esto mantiene los secretos fuera de archivos mientras mantiene automatización."

rm extracto_script.sh
```

### Puntos Clave de Enseñanza

**Estrategias de Inyección de Variables**:
- **Patrón de dos niveles**: Variables globales + específicas por capa
- **Conciencia de precedencia**: Entender cómo Terraform resuelve variables
- **Separación de entornos**: Límites claros entre entornos
- **Manejo de sensibles**: Mantener secretos fuera del control de versiones

**Patrones de Configuración**:
- **Feature flags**: Controlar funcionalidad opcional
- **Recursos condicionales**: Diferentes recursos por entorno
- **Validación**: Prevenir errores de configuración
- **Valores locales**: Lógica de configuración calculada

**Prácticas de Producción**:
- **Automatización**: Scripts manejan inyección compleja de variables
- **Seguridad**: Variables sensibles vía variables de entorno
- **Documentación**: Organización y propósito claros de variables
- **Validación**: Prevenir configuraciones erróneas antes del despliegue

### Preguntas de Evaluación

1. ¿Cuál es el orden de precedencia de variables de Terraform de menor a mayor prioridad?
2. ¿Cómo funciona el patrón de variables de dos niveles en nuestro repositorio?
3. ¿Cuáles son tres maneras seguras de manejar variables sensibles?
4. ¿Cómo ayudan los feature flags a gestionar diferencias entre entornos?

### Conclusión del Episodio

**Lo Que Aprendimos**:
- La inyección de variables permite configuraciones complejas específicas por entorno
- El patrón de dos niveles (global + específico por capa) escala a entornos ilimitados
- El manejo de variables sensibles es crucial para seguridad de producción
- Los scripts de automatización hacen práctica la gestión compleja de variables

**Desarrollo del Personaje**: Sarah evoluciona de luchar con variables simples a manejar configuraciones complejas multi-entorno con confianza. Se siente empoderada para manejar requerimientos de escala empresarial.

**Transición Dramática**: "Sarah ahora se siente confiada sobre gestionar variables a través de múltiples entornos y regiones. Pero a medida que crece la infraestructura de Bearsoft.ai, se da cuenta de que está gestionando tres estados separados de Terraform que necesitan compartir información. Cuando el equipo de aplicaciones necesita información de conexión de base de datos del equipo de infraestructura, y el equipo de Kafka necesita datos tanto de infraestructura como de aplicaciones, Sarah descubre que necesita entender gestión avanzada de estado y comunicación entre capas. ¿Cómo arquitecturar estados de Terraform para entornos complejos multi-equipo?"

**Lo Que Sigue**: El Episodio 6 explorará la sofisticada arquitectura de capas que permite a los equipos trabajar independientemente mientras mantienen integración.

Este episodio establece a Sarah como alguien que puede manejar requerimientos complejos del mundo real, preparando los conceptos arquitectónicos avanzados en los episodios finales.