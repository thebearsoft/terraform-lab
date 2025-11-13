#!/bin/bash

# Título: "Introducción a los Módulos de Terraform"
echo -e "\033[34mTítulo: Introducción a los Módulos de Terraform\033[0m"
echo -e "\033[32mSarah aprende sobre módulos de Terraform de su colega Mike...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

echo -e "\033[33mMike le muestra a Sarah cómo se ve la infraestructura modular:\033[0m"
echo ""

cat > estructura_modular.txt << 'EOF'
bearsoft-infrastructure/
├── modules/
│   ├── gke-cluster/
│   │   ├── main.tf         # 180 líneas (la lógica reutilizable)
│   │   ├── variables.tf    # Parámetros de entrada
│   │   └── outputs.tf      # Valores de salida
│   ├── networking/
│   │   ├── main.tf         # 120 líneas (la lógica reutilizable)
│   │   ├── variables.tf    # Parámetros de entrada  
│   │   └── outputs.tf      # Valores de salida
│   └── storage/
│       ├── main.tf         # 80 líneas (la lógica reutilizable)
│       ├── variables.tf    # Parámetros de entrada
│       └── outputs.tf      # Valores de salida
├── environments/
│   ├── staging/
│   │   └── main.tf         # 30 líneas (¡solo llamadas a módulos!)
│   ├── production/
│   │   └── main.tf         # 30 líneas (¡solo llamadas a módulos!)
│   └── development/
│       └── main.tf         # 30 líneas (¡solo llamadas a módulos!)

Total: 470 líneas (vs 1290 antes) - ¡63% de reducción!
EOF

cat estructura_modular.txt
echo ""

echo -e "\033[35m¿Qué son los módulos?\033[0m"
echo -e "\033[36m  - Contenedores reutilizables para recursos de Terraform\033[0m"
echo -e "\033[36m  - Aceptan variables de entrada para personalización\033[0m"
echo -e "\033[36m  - Proporcionan valores de salida para integración\033[0m"
echo -e "\033[36m  - Encapsulan complejidad detrás de interfaces simples\033[0m"
echo ""

echo -e "\033[32mPensá en los módulos como funciones en programación:\033[0m"
echo -e "\033[36m  - Escribís la lógica una vez\033[0m"
echo -e "\033[36m  - La llamás con diferentes parámetros\033[0m"
echo -e "\033[36m  - Obtenés resultados consistentes y predecibles\033[0m"

rm estructura_modular.txt