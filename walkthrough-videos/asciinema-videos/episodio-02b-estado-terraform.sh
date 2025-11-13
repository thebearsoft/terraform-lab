#!/bin/bash

# Título: "Estado de Terraform - La Fuente de Verdad"
echo -e "\033[34mTítulo: Estado de Terraform - La Fuente de Verdad\033[0m"
echo -e "\033[32mAprendamos cómo Terraform previene la deriva de configuración...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Moverse a nuestra infraestructura demo
cd infrastructure
echo -e "\033[33mPrimero, entendamos qué es el estado de Terraform:\033[0m"
echo ""

# Crear un ejemplo simple para demostrar el estado
cat > ejemplo_simple.tf << 'EOF'
# Un bucket de storage simple para demostrar el estado
resource "google_storage_bucket" "bucket_demo" {
  name     = "bearsoft-demo-ejemplo-estado"
  location = "US"
  
  # Habilitar versionado
  versioning {
    enabled = true
  }
  
  labels = {
    environment = "demo"
    purpose     = "aprendizaje-estado"
  }
}
EOF

echo -e "\033[32mAcá tenemos una definición simple de recurso:\033[0m"
cat ejemplo_simple.tf
echo ""

echo -e "\033[35mCuando ejecutamos 'terraform apply', Terraform crea dos cosas:\033[0m"
echo -e "\033[36m  1. El recurso real en GCP (el bucket)\033[0m"
echo -e "\033[36m  2. Un archivo de estado que rastrea lo que se creó\033[0m"
echo ""

echo -e "\033[33mSimulemos el workflow de terraform:\033[0m"
echo ""

echo "$ terraform init"
echo "Inicializando plugins de proveedores..."
echo "¡Terraform se ha inicializado exitosamente!"
echo ""

echo "$ terraform plan"
echo "Terraform realizará las siguientes acciones:"
echo ""
echo "  # google_storage_bucket.bucket_demo será creado"
echo "  + resource \"google_storage_bucket\" \"bucket_demo\" {"
echo "      + name     = \"bearsoft-demo-ejemplo-estado\""
echo "      + location = \"US\""
echo "      + ..."
echo "    }"
echo ""
echo "Plan: 1 para agregar, 0 para cambiar, 0 para destruir."
echo ""

echo "$ terraform apply"
echo "Creando recursos en GCP..."
echo "google_storage_bucket.bucket_demo: Creando..."
echo "google_storage_bucket.bucket_demo: ¡Creación completa!"
echo ""

# Mostrar lo que contiene el archivo de estado
echo "Ahora Terraform crea un archivo de estado (terraform.tfstate):"
cat > estado_ejemplo.json << 'EOF'
{
  "version": 4,
  "terraform_version": "1.5.0",
  "resources": [
    {
      "type": "google_storage_bucket",
      "name": "bucket_demo", 
      "instances": [
        {
          "attributes": {
            "name": "bearsoft-demo-ejemplo-estado",
            "location": "US",
            "versioning": [{"enabled": true}],
            "labels": {
              "environment": "demo",
              "purpose": "aprendizaje-estado"
            }
          }
        }
      ]
    }
  ]
}
EOF

echo "Contenido simplificado del archivo de estado:"
cat estado_ejemplo.json
echo ""

echo -e "\033[32mEste archivo de estado es la 'memoria' de Terraform de lo que existe en GCP.\033[0m"
echo -e "\033[35mEs así como Terraform detecta deriva y planea cambios.\033[0m"

rm ejemplo_simple.tf estado_ejemplo.json
cd ..