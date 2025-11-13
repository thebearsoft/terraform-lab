#!/bin/bash

# Título: "Sistema de Precedencia de Variables de Terraform"
echo -e "\033[34mTítulo: Sistema de Precedencia de Variables de Terraform\033[0m"
echo -e "\033[32mSarah aprende cómo Terraform resuelve variables de múltiples fuentes...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

echo -e "\033[35mPrecedencia de Variables de Terraform (menor a mayor prioridad):\033[0m"
echo ""

cat > ejemplo_precedencia.txt << 'EOF'
1. Defaults de variables (en variables.tf)
   variable "machine_type" {
     default = "e2-micro"
   }

2. Variables de entorno (TF_VAR_*)
   export TF_VAR_machine_type="e2-small"

3. archivo terraform.tfvars
   machine_type = "e2-medium"

4. archivos *.auto.tfvars (orden alfabético)
   staging.auto.tfvars: machine_type = "e2-standard-2"

5. flags -var de línea de comandos
   terraform apply -var="machine_type=e2-standard-4"

6. flags -var-file de línea de comandos  
   terraform apply -var-file="production.tfvars"
EOF

cat ejemplo_precedencia.txt
echo ""

echo -e "\033[33m¡Este sistema de precedencia permite estrategias de configuración sofisticadas!\033[0m"
echo ""

echo -e "\033[36mVeamos cómo nuestro repositorio de Bearsoft usa este sistema:\033[0m"
echo ""

# Mostrar nuestra estrategia real de variables
echo -e "\033[32mNuestro patrón de inyección de variables de dos niveles:\033[0m"
echo ""

echo "Nivel 1: Variables globales (compartidas entre capas)"
ls -la environments/staging/
echo ""

echo "environments/staging/global.tfvars contiene:"
head -15 environments/staging/global.tfvars
echo "# ... más configuración global ..."
echo ""

echo "Nivel 2: Overrides específicos por capa"
echo "environments/staging/infrastructure.tfvars contiene:"
cat environments/staging/infrastructure.tfvars
echo ""

echo -e "\033[32mEste patrón proporciona:\033[0m"
echo -e "\033[32m  Configuración compartida en global.tfvars\033[0m"
echo -e "\033[32m  Overrides específicos por capa cuando se necesiten\033[0m"
echo -e "\033[32m  Separación clara de entornos\033[0m"
echo -e "\033[32m  Cumplimiento del principio DRY\033[0m"

rm ejemplo_precedencia.txt