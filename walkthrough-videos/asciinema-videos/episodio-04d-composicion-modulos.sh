#!/bin/bash

# Título: "Usando Módulos en Configuraciones de Entorno"
echo -e "\033[34mTítulo: Usando Módulos en Configuraciones de Entorno\033[0m"
echo -e "\033[32mSarah aprende cómo componer módulos en entornos completos...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

echo -e "\033[33mAsí es como nuestros entornos usan el 'módulo' de infraestructura:\033[0m"
echo ""

# Mostrar el patrón de nuestro entorno de staging
echo -e "\033[36menvironments/staging/main.tf (conceptualmente):\033[0m"
cat > staging_main.tf << 'EOF'
# Así es como llamarías nuestra infraestructura como módulo
module "infrastructure" {
  source = "../../infrastructure"
  
  # Variables de entrada personalizan el módulo
  cluster_name = "bearsoft-staging-gke"
  project_id   = "bearsoft-demo"
  region       = "us-central1"
  
  # Dimensionamiento específico de staging
  core_node_pool_machine_type = "e2-small"
  worker_node_pool_preemptible = true
  
  # Funcionalidades específicas de staging
  enable_cloud_monitoring = false
  
  common_tags = {
    environment = "staging"
    cost_center = "engineering"
  }
}

# Usar outputs del módulo de infraestructura
output "cluster_endpoint" {
  value = module.infrastructure.cluster_endpoint
}
EOF

cat staging_main.tf
echo ""

echo -e "\033[36menvironments/production/main.tf sería:\033[0m"
cat > production_main.tf << 'EOF'
module "infrastructure" {
  source = "../../infrastructure"
  
  # Mismo módulo, parámetros diferentes
  cluster_name = "bearsoft-production-gke"
  project_id   = "bearsoft-demo"  
  region       = "us-central1"
  
  # Dimensionamiento específico de producción
  core_node_pool_machine_type = "e2-standard-4"
  worker_node_pool_preemptible = false
  
  # Funcionalidades específicas de producción
  enable_cloud_monitoring = true
  
  common_tags = {
    environment = "production"
    cost_center = "business"
  }
}
EOF

cat production_main.tf
echo ""

echo -e "\033[32mBeneficios de este enfoque:\033[0m"
echo -e "\033[32m  Escribir código de infraestructura una vez\033[0m"
echo -e "\033[32m  Personalizar por entorno con variables\033[0m"
echo -e "\033[32m  Infraestructura consistente entre entornos\033[0m"
echo -e "\033[32m  Fácil actualizar todos los entornos\033[0m"
echo -e "\033[32m  Separación clara de lógica reutilizable vs configuración\033[0m"

rm staging_main.tf production_main.tf