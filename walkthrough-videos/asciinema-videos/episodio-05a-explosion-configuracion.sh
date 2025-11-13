#!/bin/bash

# Título: "Cuando las Variables Simples se Vuelven Configuración Compleja"
echo -e "\033[34mTítulo: Cuando las Variables Simples se Vuelven Configuración Compleja\033[0m"
echo -e "\033[31mLos requerimientos de expansión de Sarah se están volviendo complejos...\033[0m"
echo -e "\033[33mVeamos lo que necesita manejar ahora:\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
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

echo -e "\033[31mEl primer intento de Sarah con variables simples:\033[0m"
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

echo -e "\033[31mProblemas con este enfoque:\033[0m"
echo -e "\033[31m  Archivos de variables enormes que son difíciles de mantener\033[0m"
echo -e "\033[31m  Fácil configurar combinaciones conflictivas de variables\033[0m"
echo -e "\033[31m  No hay organización clara por entorno\033[0m"
echo -e "\033[31m  Difícil entender qué variables se aplican dónde\033[0m"
echo -e "\033[31m  Errores de copiar-pegar entre entornos\033[0m"

rm requerimientos.txt variables_desordenadas.tf