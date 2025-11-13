#!/bin/bash

# Título: "El Descubrimiento de la Deriva de Configuración"
echo -e "\033[34mTítulo: El Descubrimiento de la Deriva de Configuración\033[0m"
echo -e "\033[33mDos meses después del éxito inicial de Sarah...\033[0m"
echo -e "\033[31mAparece un bug en producción pero no en staging. Vamos a investigar.\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Simular la verificación de la infraestructura actual
echo -e "\033[36mSarah revisa la configuración del servidor de producción:\033[0m"
cat > realidad_produccion.txt << 'EOF'
Servidor de Producción (Estado Actual):
- Tipo de Máquina: n1-standard-8 (¿CUÁNDO cambió de n1-standard-4?)
- Disco: 200GB SSD (Eran 100GB originalmente)
- Reglas adicionales de firewall: 9090, 3000, 8888 (¿Quién agregó estas?)
- Modificaciones personalizadas en el script de inicio (¡No están en nuestro código!)
- Logging de debug: DESHABILITADO (Bien)
EOF

cat realidad_produccion.txt
echo ""

echo -e "\033[36mAhora revisa staging:\033[0m"
cat > realidad_staging.txt << 'EOF'  
Servidor de Staging (Estado Actual):
- Tipo de Máquina: n1-standard-4 (Tamaño original)
- Disco: 100GB SSD (Tamaño original)
- Solo reglas estándar de firewall
- Script de inicio original
- Logging de debug: HABILITADO (Alguien estaba debuggeando)
EOF

cat realidad_staging.txt
echo ""

echo -e "\033[36mY finalmente, lo que dice el código de Terraform:\033[0m"
cat > definicion_terraform.txt << 'EOF'
Definición de Terraform (¿Fuente de Verdad?):
- Tipo de Máquina: n1-standard-4
- Disco: 100GB SSD  
- Reglas estándar de firewall
- Script de inicio estándar
- Logging de debug: No especificado
EOF

cat definicion_terraform.txt
echo ""

echo -e "\033[31m¡Tres configuraciones diferentes! Esto es DERIVA DE CONFIGURACIÓN.\033[0m"
echo -e "\033[33mSarah necesita entender cuál es 'correcta' y cómo prevenir esto.\033[0m"

rm realidad_produccion.txt realidad_staging.txt definicion_terraform.txt