#!/bin/bash

# Título: "El Intento de Recuperación Manual de Medianoche de Sarah"
echo -e "\033[34mTítulo: El Intento de Recuperación Manual de Medianoche de Sarah\033[0m"
echo -e "\033[31mSon las 2:30 AM. Sarah necesita recrear el servidor de producción caído...\033[0m"
echo ""

# Navegar al directorio raíz de terraform-demo
cd ../../
echo -e "\033[36mNavegando al directorio raíz del proyecto: $(pwd)\033[0m"
echo ""

# Simular puntos de dolor de la creación manual de servidores
echo -e "\033[33mPaso 1: Encontrar las especificaciones del servidor...\033[0m"
cat > notas_servidor.txt << 'EOF'
Configuración del Servidor de Producción (¿tal vez desactualizada?)
- Tipo de instancia: n1-standard-4 (¿o era n1-standard-2?)
- Disco: 100GB SSD (preguntarle a Tom sobre el tipo de disco)
- Red: VPC personalizada (¿cuál exactamente?)
- Firewall: Permitir puertos 80, 443, 8080 (¿algo más?)
- Última actualización: hace 6 meses por alguien que ya no trabaja aquí
EOF

cat notas_servidor.txt
echo ""
echo -e "\033[31m¿Ya estás confundido? Estas notas tienen 6 meses de antigüedad...\033[0m"
echo ""

# Mostrar el problema con pasos manuales
echo -e "\033[33mPaso 2: Clickear manualmente en la consola de GCP...\033[0m"
echo -e "\033[36m  - Navegar a Compute Engine\033[0m"
echo -e "\033[36m  - Hacer click en Crear Instancia\033[0m"  
echo -e "\033[36m  - Llenar más de 20 campos de configuración\033[0m"
echo -e "\033[36m  - Esperar recordar todas las dependencias\033[0m"
echo -e "\033[31m  - Rezar para que no se te olvide nada crítico\033[0m"
echo ""

echo -e "\033[33mPaso 3: Configurar la aplicación manualmente...\033[0m"
echo -e "\033[36m  - SSH al servidor\033[0m"
echo -e "\033[36m  - Instalar paquetes (¿cuáles versiones?)\033[0m"
echo -e "\033[36m  - Configurar servicios (¿qué configuraciones?)\033[0m"
echo -e "\033[36m  - Actualizar reglas de firewall (¿cuáles?)\033[0m"
echo -e "\033[31m  - Probar todo (cruzar los dedos)\033[0m"
echo ""

echo -e "\033[35mResultados del Enfoque Manual:\033[0m"
echo -e "\033[31m  Tiempo transcurrido: 3 horas y contando...\033[0m"
echo -e "\033[31m  Nivel de confianza: Muy bajo\033[0m"
echo -e "\033[31m  Precisión de la documentación: Desconocida\033[0m"
echo -e "\033[31m  Reproducibilidad: Cero\033[0m"

rm notas_servidor.txt