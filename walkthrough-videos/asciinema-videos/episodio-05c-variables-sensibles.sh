#!/bin/bash

# Título: "Manejo Seguro de Variables Sensibles"
echo -e "\033[34mTítulo: Manejo Seguro de Variables Sensibles\033[0m"
echo -e "\033[32mSarah aprende a manejar contraseñas, claves y secretos de forma segura...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

echo -e "\033[31mNUNCA poner valores sensibles directamente en archivos .tfvars:\033[0m"
echo ""

cat > mal_ejemplo.tfvars << 'EOF'
# ❌ MALO: Secretos en control de versiones
database_password = "super-secret-password-123"
api_key = "ak-1234567890abcdef"
EOF

echo -e "\033[31mMAL EJEMPLO:\033[0m"
cat mal_ejemplo.tfvars
echo ""

echo -e "\033[32mENFOQUES BUENOS para variables sensibles:\033[0m"
echo ""

echo -e "\033[33m1. Método 1: Variables de Entorno\033[0m"
echo "export TF_VAR_database_password='tu-contraseña-secreta'"
echo "export TF_VAR_webserver_default_user_password='contraseña-admin'"
echo ""

echo -e "\033[33m2. Método 2: sensitive.tfvars separado (no en git)\033[0m"
cat > sensitive.tfvars << 'EOF'
# Este archivo está en .gitignore
database_password = "contraseña-secreta-real"
webserver_default_user_password = "contraseña-admin-real"
EOF

echo "terraform apply -var-file='sensitive.tfvars'"
echo ""

echo -e "\033[33m3. Método 3: Prompting interactivo\033[0m"
cat > vars_interactivas.tf << 'EOF'
variable "database_password" {
  description = "Contraseña de base de datos para Kafka"
  type        = string
  sensitive   = true
  # Sin default = Terraform preguntará
}
EOF

echo "Cuando no se proporciona default, Terraform pregunta:"
echo "$ terraform apply"
echo "var.database_password"
echo "  Ingresá un valor: [entrada oculta]"
echo ""

echo -e "\033[33m4. Método 4: Gestión externa de secretos\033[0m"
echo -e "\033[35m  Usar herramientas como:\033[0m"
echo -e "\033[36m  - Google Secret Manager\033[0m"  
echo -e "\033[36m  - HashiCorp Vault\033[0m"
echo -e "\033[36m  - Kubernetes Secrets\033[0m"
echo -e "\033[36m  - Inyección de secretos en pipeline CI/CD\033[0m"
echo ""

echo -e "\033[32mNuestros scripts de despliegue usan el Método 1:\033[0m"
echo -e "\033[36m  Configurar variables de entorno antes de ejecutar scripts de despliegue\033[0m"

rm mal_ejemplo.tfvars sensitive.tfvars vars_interactivas.tf