#!/bin/bash

# Título: "Creando un Módulo de Cluster GKE"
echo -e "\033[34mTítulo: Creando un Módulo de Cluster GKE\033[0m"
echo -e "\033[32mConstruyamos el primer módulo de Sarah usando nuestra infraestructura de Bearsoft...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Navegar a nuestra infraestructura y examinarla como un módulo potencial
cd infrastructure
echo -e "\033[33m¡Nuestra capa de infraestructura ya está estructurada como un módulo!\033[0m"
echo -e "\033[36mExaminemos la estructura del módulo:\033[0m"
echo ""

ls -la
echo ""

echo -e "\033[35mMejores Prácticas de Estructura de Módulos:\033[0m"
echo -e "\033[36m  1. main.tf    - Definiciones primarias de recursos\033[0m"
echo -e "\033[36m  2. variables.tf - Parámetros de entrada\033[0m"
echo -e "\033[36m  3. outputs.tf   - Valores de retorno\033[0m"
echo -e "\033[36m  4. versions.tf  - Requerimientos del proveedor\033[0m"
echo ""

echo -e "\033[33mMiremos nuestro variables.tf para ver parámetros de entrada:\033[0m"
echo ""
head -20 variables.tf
echo "# ... más variables definidas acá ..."
echo ""

echo -e "\033[32mEstas variables hacen nuestra infraestructura personalizable:\033[0m"
echo "- cluster_name: Nombres diferentes por entorno"
echo "- region: Desplegar en diferentes regiones"
echo "- machine_types: Diferentes tamaños por entorno"
echo "- node_counts: Escalar diferente por entorno"
echo ""

echo -e "\033[33mAhora revisemos outputs.tf para ver qué exponemos:\033[0m"
echo ""
head -15 outputs.tf
echo "# ... más outputs definidos acá ..."
echo ""

echo -e "\033[32mLos outputs permiten que otros módulos usen nuestra infraestructura:\033[0m"
echo "- cluster_name: Usado por la capa de aplicaciones"
echo "- detalles de red: Usados para configuración de servicios"
echo "- info de service account: Usada para workload identity"
echo ""

cd ..