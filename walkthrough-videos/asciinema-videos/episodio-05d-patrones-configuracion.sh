#!/bin/bash

# Título: "Gestión Avanzada de Configuración"
echo -e "\033[34mTítulo: Gestión Avanzada de Configuración\033[0m"
echo -e "\033[32mSarah aprende patrones para gestionar configuraciones complejas y multi-entorno...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

echo -e "\033[33m1. PATRÓN 1: Configuración de Feature Flags\033[0m"
echo -e "\033[35m  Controlar funcionalidades opcionales por entorno:\033[0m"
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

echo -e "\033[33m2. PATRÓN 2: Configuración Condicional de Recursos\033[0m"
echo -e "\033[35m  Diferentes recursos basados en entorno:\033[0m"
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

echo -e "\033[33m3. PATRÓN 3: Validación de Configuración\033[0m"
echo -e "\033[35m  Prevenir combinaciones inválidas de variables:\033[0m"
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

echo -e "\033[32mEstos patrones proporcionan:\033[0m"
echo -e "\033[32m  Comportamiento específico por entorno\033[0m"
echo -e "\033[32m  Validación de configuración\033[0m"
echo -e "\033[32m  Gestión clara de funcionalidades\033[0m"
echo -e "\033[32m  Prevención de errores\033[0m"

rm feature_flags.tf recursos_condicionales.tf validacion.tf