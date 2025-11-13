#!/bin/bash

# Título: "Visualizando Dependencias de Infraestructura"
echo -e "\033[34mTítulo: Visualizando Dependencias de Infraestructura\033[0m"
echo -e "\033[32mSarah aprende a mapear las dependencias de su infraestructura...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Moverse a nuestra capa de infraestructura
cd infrastructure
echo -e "\033[35mTerraform tiene una herramienta poderosa para entender dependencias: terraform graph\033[0m"
echo ""

echo "$ terraform graph"
echo -e "\033[36mEste comando muestra cómo los recursos dependen unos de otros.\033[0m"
echo ""

# Mostrar un grafo de dependencias simplificado
echo -e "\033[33mEsto es lo que revela el grafo de dependencias:\033[0m"
cat > ejemplo_dependencia.txt << 'EOF'
Ejemplo de Cadena de Dependencias:

Red VPC
    ↓
Subnet (depende de VPC)
    ↓  
Cluster GKE (depende de Subnet)
    ↓
Node Pools (dependen del Cluster)
    ↓
Aplicaciones (dependen de Node Pools)

Más dependencias en paralelo:
VPC → Red Privada → Cloud SQL → Kafka
VPC → Reglas de Firewall → Load Balancer → Ingress
EOF

cat ejemplo_dependencia.txt
echo ""

echo -e "\033[34mExaminemos las dependencias reales de nuestra infraestructura:\033[0m"
echo ""

# Mostrar dependencias reales de nuestro repo
echo "En nuestro infrastructure/main.tf, podemos ver dependencias:"
echo ""

echo -e "\033[32m1. Dependencias IMPLÍCITAS (Terraform las descifra):\033[0m"
grep -A 5 "network.*=" main.tf 2>/dev/null || echo "  subnetwork = google_compute_subnetwork.subnet.name"
echo "     # Los node pools automáticamente dependen del cluster"
echo "     # El cluster automáticamente depende de la red"
echo ""

echo -e "\033[33m2. Dependencias EXPLÍCITAS (las declaramos nosotros):\033[0m"
echo "  depends_on = [google_container_cluster.primary]"
echo "     # Le decimos explícitamente a Terraform sobre esta dependencia"
echo ""

echo -e "\033[34m3. Dependencias de DATOS (leyendo recursos existentes):\033[0m"
echo "  data \"google_client_config\" \"default\" {}"
echo "     # Esto lee datos pero no crea dependencias"

rm ejemplo_dependencia.txt
cd ..