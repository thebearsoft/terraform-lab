#!/bin/bash

# Título: "Cómo se Vería la Vida de Sarah con Infrastructure as Code"
echo -e "\033[34mTítulo: Cómo se Vería la Vida de Sarah con Infrastructure as Code\033[0m"
echo -e "\033[32mAhora imagínate la vida de Sarah con Infrastructure as Code...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Mostrar un archivo simple de Terraform
cat > servidor_simple.tf << 'EOF'
# Definición simple de servidor - declarativa y clara
resource "google_compute_instance" "servidor_web" {
  name         = "bearsoft-servidor-web"
  machine_type = "n1-standard-4"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
      size  = 100
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # IP pública efímera
    }
  }

  tags = ["servidor-web", "produccion"]

  metadata_startup_script = file("script-configuracion.sh")
}
EOF

echo -e "\033[32mMirá este archivo de Terraform - todo está documentado en código:\033[0m"
cat servidor_simple.tf
echo ""

# Mostrar el script de configuración
cat > script-configuracion.sh << 'EOF'
#!/bin/bash
# Script de configuración de aplicación - versionado y probado
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "Servidor de Bearsoft.ai Listo" > /var/www/html/index.html
EOF

echo -e "\033[32mY el script de configuración también está en control de versiones:\033[0m"
cat script-configuracion.sh
echo ""

echo -e "\033[34mEl nuevo flujo de trabajo de Sarah con Terraform:\033[0m"
echo -e "\033[36m1. terraform init    # Inicializar el proyecto\033[0m"
echo -e "\033[36m2. terraform plan    # Vista previa de lo que se creará\033[0m"
echo -e "\033[36m3. terraform apply   # Crear la infraestructura\033[0m"
echo ""
echo -e "\033[35mResultados del Enfoque IaC:\033[0m"
echo -e "\033[32m  Tiempo de recuperación: 5 minutos\033[0m"
echo -e "\033[32m  Nivel de confianza: Alto\033[0m"
echo -e "\033[32m  Documentación: Código autodocumentado\033[0m"
echo -e "\033[32m  Reproducibilidad: 100%\033[0m"

# Limpieza
rm servidor_simple.tf script-configuracion.sh