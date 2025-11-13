#!/bin/bash

# Título: "Detección y Resolución de Deriva"
echo -e "\033[34mTítulo: Detección y Resolución de Deriva\033[0m"
echo -e "\033[31m¿Qué pasa cuando alguien hace cambios manuales fuera de Terraform?\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Simular escenario de deriva
echo -e "\033[33mEscenario: Alguien cambió manualmente el cluster de GKE en la consola de GCP\033[0m"
echo -e "\033[31mAgregaron node pools extra y cambiaron tipos de máquina...\033[0m"
echo ""

echo -e "\033[36mSarah ejecuta 'terraform plan' para detectar deriva:\033[0m"
echo "$ terraform plan"
echo ""

echo "Salida de Terraform:"
echo "Nota: Los objetos han cambiado fuera de Terraform"
echo ""
echo "Terraform detectó los siguientes cambios hechos fuera de Terraform"
echo "desde el último 'terraform apply':"
echo ""
echo "  # google_container_node_pool.worker_nodes ha cambiado"
echo "  ~ resource \"google_container_node_pool\" \"worker_nodes\" {"
echo "    ~ machine_type = \"e2-medium\" -> \"e2-standard-4\""
echo "    }"
echo ""

echo -e "\033[35mSarah tiene tres opciones para arreglar esta deriva:\033[0m"
echo ""

echo -e "\033[33mOpción 1: REVERTIR - Dejar que Terraform arregle la deriva\033[0m"
echo "$ terraform apply"
echo "Esto cambiará el tipo de máquina de vuelta a e2-medium"
echo ""

echo -e "\033[32mOpción 2: ACEPTAR - Actualizar el código para que coincida con la realidad\033[0m"
echo "Actualizar variables.tf:"
echo "worker_node_pool_machine_type = \"e2-standard-4\""
echo "Después: $ terraform plan  # No debería mostrar cambios"
echo ""

echo -e "\033[34mOpción 3: INVESTIGAR - Tal vez este cambio era necesario\033[0m"
echo "Verificar con el equipo, entender por qué se hizo el cambio"
echo "Documentar la decisión en un commit de Git"
echo ""

echo -e "\033[32mSarah elige la Opción 2 - aceptar y documentar el cambio:\033[0m"
echo "$ git add variables.tf"
echo "$ git commit -m 'Aceptar optimización de producción: actualizar worker nodes a e2-standard-4'"
echo ""

echo -e "\033[32m¡Deriva resuelta! Código e infraestructura están sincronizados de nuevo.\033[0m"