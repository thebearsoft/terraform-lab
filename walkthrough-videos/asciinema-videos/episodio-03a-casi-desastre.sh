#!/bin/bash

# Título: "El Plan de Destrucción Accidental"
echo -e "\033[34mTítulo: El Plan de Destrucción Accidental\033[0m"
echo -e "\033[33mSarah quiere limpiar una red VPC no utilizada en staging...\033[0m"
echo -e "\033[31mParece bastante simple. ¿Qué podría salir mal?\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Simular el plan peligroso de terraform
echo -e "\033[36mSarah crea un plan para destruir solo la VPC:\033[0m"
cat > destruir_vpc.tf << 'EOF'
# Sarah piensa que esta VPC no se usa y puede eliminarse de forma segura
# Está a punto de aprender sobre dependencias implícitas...
resource "google_compute_network" "vpc_vieja" {
  name                    = "vpc-vieja-sin-uso"
  auto_create_subnetworks = false
}
EOF

echo -e "\033[32mLa VPC objetivo parece bastante inocente:\033[0m"
cat destruir_vpc.tf
echo ""

echo "Sarah ejecuta: terraform plan -destroy -target=google_compute_network.vpc_vieja"
echo ""
echo -e "\033[31mLa respuesta de Terraform es aterradora:\033[0m"
echo ""

cat > plan_destruccion.txt << 'EOF'
Terraform realizará las siguientes acciones:

  # google_compute_network.vpc_vieja será destruida
  - resource "google_compute_network" "vpc_vieja" {...}

  # google_container_cluster.primary será destruido
  # (porque depende de la VPC que está siendo destruida)
  - resource "google_container_cluster" "primary" {...}

  # google_container_node_pool.core_nodes será destruido
  # (porque depende del cluster que está siendo destruido)
  - resource "google_container_node_pool" "core_nodes" {...}

  # google_sql_database_instance.kafka_db será destruida
  # (porque usa la red privada de la VPC)
  - resource "google_sql_database_instance" "kafka_db" {...}

  # ... 43 recursos más serán destruidos

Plan: 0 para agregar, 0 para cambiar, 47 para destruir.
EOF

cat plan_destruccion.txt
echo ""

echo -e "\033[31mEl corazón de Sarah se detiene. Esta VPC 'sin uso' destruiría:\033[0m"
echo -e "\033[31m  • Todo el cluster de GKE\033[0m"
echo -e "\033[31m  • Todas las aplicaciones ejecutándose en el cluster\033[0m"  
echo -e "\033[31m  • La base de datos de Kafka con meses de historial de eventos\033[0m"
echo -e "\033[31m  • Sistemas de almacenamiento con datos críticos\033[0m"
echo -e "\033[31m  • 43 otros recursos interconectados\033[0m"
echo ""

echo -e "\033[32mCancela la operación inmediatamente.\033[0m"
echo -e "\033[33m¿Pero cómo se suponía que supiera sobre estas dependencias?\033[0m"

rm destruir_vpc.tf plan_destruccion.txt