#!/bin/bash

# Título: "Control de Versiones: Historia de Infrastructure as Code"
echo -e "\033[34mTítulo: Control de Versiones: Historia de Infrastructure as Code\033[0m"
echo -e "\033[32mSarah aprende a prevenir la deriva usando control de versiones con Git...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Demostrar el workflow de control de versiones
echo -e "\033[34mPaso 1: Inicializar repositorio Git para infraestructura\033[0m"
echo "$ git init"
echo "$ git add ."
echo "$ git commit -m 'Configuración inicial de infraestructura'"
echo ""

echo -e "\033[34mPaso 2: Hacer un cambio controlado a la infraestructura\033[0m"
cd infrastructure

# Mostrar cómo hacer un cambio a la infraestructura
echo -e "\033[33mSarah necesita actualizar el tamaño del disco del entorno de staging:\033[0m"
echo ""
echo "Antes del cambio en variables.tf:"
echo "core_node_pool_disk_size = 50  # Tamaño actual"
echo ""
echo "Después del cambio en variables.tf:"
echo "core_node_pool_disk_size = 100  # Tamaño actualizado"
echo ""

echo -e "\033[34mPaso 3: Planear el cambio para ver qué pasará\033[0m"
echo "$ terraform plan -var-file='../environments/staging/global.tfvars'"
echo ""
echo "Terraform mostrará exactamente qué cambiará:"
echo "~ google_container_node_pool.core_nodes"
echo "  ~ node_config {"
echo "    ~ disk_size_gb = 50 -> 100"
echo "    }"
echo ""

echo -e "\033[34mPaso 4: Aplicar el cambio\033[0m"
echo "$ terraform apply"
echo "La infraestructura se actualiza consistentemente."
echo ""

echo -e "\033[34mPaso 5: Hacer commit del cambio al control de versiones\033[0m"
echo "$ git add variables.tf"
echo "$ git commit -m 'Actualizar tamaño de disco staging de 50GB a 100GB'"
echo ""

echo -e "\033[32mAhora el cambio está:\033[0m"
echo -e "\033[36m  - Documentado en el historial de Git\033[0m"
echo -e "\033[36m  - Rastreado en el estado de Terraform\033[0m"
echo -e "\033[36m  - Aplicado consistentemente\033[0m"
echo -e "\033[36m  - Reproducible en otros entornos\033[0m"

cd ..