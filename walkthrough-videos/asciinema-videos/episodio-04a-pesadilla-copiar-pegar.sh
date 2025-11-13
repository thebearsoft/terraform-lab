#!/bin/bash

# Título: "Cuando el Código de Infraestructura se Vuelve Inmanejable"
echo -e "\033[34mTítulo: Cuando el Código de Infraestructura se Vuelve Inmanejable\033[0m"
echo -e "\033[31mLa infraestructura de Sarah ha crecido para soportar múltiples entornos...\033[0m"
echo -e "\033[33mVeamos cómo se ve su estructura de directorios ahora:\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Mostrar la estructura problemática de directorios
cat > estructura_actual.txt << 'EOF'
bearsoft-infrastructure/
├── staging/
│   ├── gke-cluster.tf      # 180 líneas
│   ├── networking.tf       # 120 líneas
│   ├── storage.tf          # 80 líneas
│   └── variables.tf        # 50 líneas
├── production/
│   ├── gke-cluster.tf      # 180 líneas (95% idéntico a staging)
│   ├── networking.tf       # 120 líneas (95% idéntico a staging)
│   ├── storage.tf          # 80 líneas (95% idéntico a staging)  
│   └── variables.tf        # 50 líneas (valores diferentes)
└── development/
    ├── gke-cluster.tf      # 180 líneas (95% idéntico a otros)
    ├── networking.tf       # 120 líneas (95% idéntico a otros)
    ├── storage.tf          # 80 líneas (95% idéntico a otros)
    └── variables.tf        # 50 líneas (valores diferentes)

Total: 1290 líneas de código mayormente duplicado
EOF

cat estructura_actual.txt
echo ""

echo -e "\033[31mLos problemas con este enfoque:\033[0m"
echo -e "\033[31m  - 95% de duplicación de código entre entornos\033[0m"
echo -e "\033[31m  - Los cambios requieren actualizaciones en 3 lugares diferentes\033[0m"
echo -e "\033[31m  - Fácil olvidarse de actualizar un entorno\033[0m"
echo -e "\033[31m  - Las inconsistencias se filtran con el tiempo\033[0m"
echo -e "\033[31m  - Difícil de mantener y debuggear\033[0m"
echo ""

# Mostrar un ejemplo de la duplicación
echo -e "\033[33mAsí se ve la duplicación:\033[0m"
echo ""

echo "staging/gke-cluster.tf:"
cat > staging_cluster.tf << 'EOF'
resource "google_container_cluster" "primary" {
  name     = "bearsoft-staging-gke"
  location = "us-central1"
  
  remove_default_node_pool = true
  initial_node_count       = 1
  
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  
  # ... 150 líneas más de configuración
}
EOF

echo "production/gke-cluster.tf:"
cat > production_cluster.tf << 'EOF'
resource "google_container_cluster" "primary" {
  name     = "bearsoft-production-gke"  # ¡Solo diferencia!
  location = "us-central1"
  
  remove_default_node_pool = true
  initial_node_count       = 1
  
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  
  # ... 150 líneas más de configuración IDÉNTICA
}
EOF

head -10 staging_cluster.tf
echo "# ... 150 líneas más ..."
echo ""
head -10 production_cluster.tf
echo "# ... 150 líneas más ..."
echo ""

echo -e "\033[31mEsto viola el principio DRY: Don't Repeat Yourself (No Te Repitas)\033[0m"

rm estructura_actual.txt staging_cluster.tf production_cluster.tf