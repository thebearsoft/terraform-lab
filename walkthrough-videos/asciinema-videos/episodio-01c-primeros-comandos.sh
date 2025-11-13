#!/bin/bash

# Título: "Tus Primeros Comandos de Terraform"
echo -e "\033[34mTítulo: Tus Primeros Comandos de Terraform\033[0m"
echo -e "\033[32mExperimentemos los conceptos básicos de Terraform usando nuestro repositorio de Bearsoft.ai...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Navegar a la capa de infraestructura
cd infrastructure
echo -e "\033[36mEstamos en la capa de infraestructura de nuestra arquitectura de 3 niveles\033[0m"
ls -la
echo ""

# Mostrar un archivo real de Terraform
echo -e "\033[32mAsí se ve Terraform listo para producción:\033[0m"
head -20 main.tf
echo ""
echo -e "\033[33mNo te preocupes por entender todo todavía - ¡vamos construyendo hacia esto!\033[0m"
echo ""

# Inicializar Terraform
echo -e "\033[34mPaso 1: Inicializar Terraform\033[0m"
echo -e "\033[35m  Esto descarga los proveedores necesarios y configura el workspace\033[0m"
echo ""
echo -e "\033[36m  Comando: terraform init\033[0m"
echo -e "\033[33m  (En la demo real, esto realmente se ejecutaría)\033[0m"
echo ""

# Mostrar qué hace terraform plan
echo -e "\033[34mPaso 2: Vista previa de cambios con 'terraform plan'\033[0m"
echo -e "\033[35m  Esto muestra lo que Terraform HARÍA, sin hacer cambios\033[0m"
echo ""
echo -e "\033[36m  Comando: terraform plan\033[0m"
echo -e "\033[33m  (Esto mostraría un plan detallado de recursos a crear)\033[0m"
echo ""

# Explicar terraform apply
echo -e "\033[34mPaso 3: Aplicar cambios con 'terraform apply'\033[0m"
echo -e "\033[35m  Esto crea la infraestructura real en GCP\033[0m"
echo ""
echo -e "\033[36m  Comando: terraform apply\033[0m"
echo -e "\033[33m  (Esto crearía recursos reales de GCP - lo haremos en episodios posteriores)\033[0m"
echo ""

cd ..