#!/bin/bash

# Título: "Fuentes de Datos: Leer Sin Crear"
echo -e "\033[34mTítulo: Fuentes de Datos: Leer Sin Crear\033[0m"
echo -e "\033[32mSarah descubre la diferencia entre recursos y fuentes de datos...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

cd infrastructure
echo -e "\033[33mRECURSOS crean y gestionan infraestructura:\033[0m"
echo ""

cat > ejemplo_recurso.tf << 'EOF'
# Esto CREA un nuevo bucket de storage
resource "google_storage_bucket" "logs" {
  name     = "bearsoft-logs"
  location = "US"
}
EOF

cat ejemplo_recurso.tf
echo ""

echo -e "\033[36mFUENTES DE DATOS leen infraestructura existente:\033[0m"
echo ""

cat > ejemplo_fuente_datos.tf << 'EOF'
# Esto LEE un proyecto existente (no lo crea)
data "google_project" "current" {}

# Esto LEE info del cluster (no crea el cluster)
data "google_container_cluster" "existing" {
  name     = "mi-cluster-existente"
  location = "us-central1"
}
EOF

cat ejemplo_fuente_datos.tf
echo ""

echo -e "\033[35mDiferencias clave:\033[0m"
echo ""
echo -e "\033[33mRECURSOS:\033[0m"
echo -e "\033[36m  - Crean, actualizan y destruyen infraestructura\033[0m"
echo -e "\033[36m  - Rastreados en el estado de Terraform\033[0m"
echo -e "\033[36m  - Pueden ser destruidos por Terraform\033[0m"
echo -e "\033[36m  - Ejemplo: google_compute_network\033[0m"
echo ""

echo -e "\033[34mFUENTES DE DATOS:\033[0m"
echo -e "\033[36m  - Leen información sobre infraestructura existente\033[0m"
echo -e "\033[36m  - No crean ni destruyen nada\033[0m"
echo -e "\033[36m  - No rastreados en estado como recursos gestionables\033[0m"
echo -e "\033[36m  - Ejemplo: data.google_project.current\033[0m"
echo ""

echo -e "\033[32mEn nuestra capa de aplicaciones, usamos fuentes de datos para leer\033[0m"
echo -e "\033[32m  infraestructura creada por la capa de infraestructura:\033[0m"
echo ""

cd ../applications
head -10 provider.tf 2>/dev/null || echo "data \"terraform_remote_state\" \"infrastructure\" {"
echo "  # Esto lee outputs de la capa de infraestructura"
echo "  # sin crear una dependencia que podría destruirla"
echo "}"

rm -f ../infrastructure/ejemplo_recurso.tf ../infrastructure/ejemplo_fuente_datos.tf
cd ..