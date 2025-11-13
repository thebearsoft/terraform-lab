#!/bin/bash

# Título: "Cambios Seguros de Infraestructura"
echo -e "\033[34mTítulo: Cambios Seguros de Infraestructura\033[0m"
echo -e "\033[32mSarah aprende cómo modificar infraestructura de forma segura con dependencias...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

echo -e "\033[33m1. Estrategia 1: PLANEAR PRIMERO, SIEMPRE\033[0m"
echo "$ terraform plan"
echo "Siempre verificar qué hará Terraform antes de aplicar cambios"
echo ""

echo -e "\033[33m2. Estrategia 2: USAR OPERACIONES DIRIGIDAS CON CUIDADO\033[0m"
echo "$ terraform plan -target=recurso_específico"
echo "Pero entender que los targets pueden romper dependencias"
echo ""

echo -e "\033[33m3. Estrategia 3: ENTENDER LA CADENA DE DEPENDENCIAS\033[0m"
echo "Antes de eliminar cualquier cosa, preguntarse:"
echo "- ¿Qué depende de este recurso?"
echo "- ¿Qué se romperá si lo elimino?"
echo "- ¿Necesito eliminar dependientes primero?"
echo ""

echo -e "\033[33m4. Estrategia 4: USAR TERRAFORM GRAPH\033[0m"
echo "$ terraform graph | dot -Tpng > dependencias.png"
echo "Visualizar dependencias antes de hacer cambios"
echo ""

echo -e "\033[33m5. Estrategia 5: CAMBIOS INCREMENTALES\033[0m"
echo "En lugar de destruir la VPC, el enfoque más seguro de Sarah:"
echo ""

cat > migracion_segura.sh << 'EOF'
# Estrategia de migración segura
echo "Paso 1: Crear nueva VPC junto a la vieja"
terraform apply  # Crea nueva VPC

echo "Paso 2: Mover recursos a la nueva VPC uno por uno"
# Actualizar cada recurso para usar nueva VPC
# Aplicar cambios incrementalmente

echo "Paso 3: Verificar que todo funcione en nueva VPC"
# Probar aplicaciones, verificar conectividad

echo "Paso 4: Eliminar VPC vieja (ahora sin uso)"
terraform destroy -target=vpc_vieja
EOF

echo -e "\033[32mEnfoque de migración segura:\033[0m"
cat migracion_segura.sh
echo ""

echo -e "\033[35mEste enfoque:\033[0m"
echo -e "\033[36m  - Minimiza el riesgo de cambios que rompan cosas\033[0m"
echo -e "\033[36m  - Permite pruebas en cada paso\033[0m"
echo -e "\033[36m  - Proporciona opciones de rollback\033[0m"
echo -e "\033[36m  - Mantiene la disponibilidad del sistema\033[0m"

rm migracion_segura.sh