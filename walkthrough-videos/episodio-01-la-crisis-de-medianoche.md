# Episodio 1: La Crisis de Medianoche
## Duración: 15 minutos | Complejidad: Principiante

### Configuración de la Historia: Marco de Nancy Duarte

**LO QUE ES (Realidad Dolorosa Actual)**
Son las 2:30 AM de un martes. Sarah, una ingeniera junior en Bearsoft.ai, recibe la temida llamada telefónica. El servidor de procesamiento de datos de producción se ha caído, y los reportes de clientes de mañana dependen de él. Abre su laptop para encontrar páginas dispersas en la wiki, runbooks desactualizados, y documentación contradictoria sobre las configuraciones del servidor.

**LO QUE PODRÍA SER (Visión de un Mejor Futuro)**  
Imagínate si Sarah simplemente pudiera ejecutar un comando y hacer que toda la infraestructura se recreara automáticamente, consistentemente, y confiablemente - en minutos, no horas.

### Objetivos de Aprendizaje

1. Entender los puntos de dolor de la gestión manual de infraestructura
2. Definir Infrastructure as Code y sus beneficios principales
3. Distinguir entre enfoques declarativos vs imperativos
4. Ejecutar los primeros comandos de Terraform

### Preparación Pre-Grabación

```bash
# Script de preparación del entorno para asciinema
export DEMO_MAGIC_NO_WAIT=1
export TYPE_SPEED=20
cd ~/terraform-demo
```

### Script de Asciinema 1: El Dolor Manual

```bash
# Título: "El Intento de Recuperación Manual de Medianoche de Sarah"
echo "Son las 2:30 AM. Sarah necesita recrear el servidor de producción caído..."
echo ""

# Simular puntos de dolor de la creación manual de servidores
echo "Paso 1: Encontrar las especificaciones del servidor..."
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
echo "¿Ya estás confundido? Estas notas tienen 6 meses de antigüedad..."
echo ""

# Mostrar el problema con pasos manuales
echo "Paso 2: Clickear manualmente en la consola de GCP..."
echo "- Navegar a Compute Engine"
echo "- Hacer click en Crear Instancia"  
echo "- Llenar más de 20 campos de configuración"
echo "- Esperar recordar todas las dependencias"
echo "- Rezar para que no se te olvide nada crítico"
echo ""

echo "Paso 3: Configurar la aplicación manualmente..."
echo "- SSH al servidor"
echo "- Instalar paquetes (¿cuáles versiones?)"
echo "- Configurar servicios (¿qué configuraciones?)"
echo "- Actualizar reglas de firewall (¿cuáles?)"
echo "- Probar todo (cruzar los dedos)"
echo ""

echo "Tiempo transcurrido: 3 horas y contando..."
echo "Nivel de confianza: Muy bajo"
echo "Precisión de la documentación: Desconocida"
echo "Reproducibilidad: Cero"

rm notas_servidor.txt
```

### Script de Asciinema 2: La Alternativa de IaC

```bash
# Título: "Cómo se Vería la Vida de Sarah con Infrastructure as Code"
echo "Ahora imagínate la vida de Sarah con Infrastructure as Code..."
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

echo "Mirá este archivo de Terraform - todo está documentado en código:"
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

echo "Y el script de configuración también está en control de versiones:"
cat script-configuracion.sh
echo ""

echo "El nuevo flujo de trabajo de Sarah con Terraform:"
echo "1. terraform init    # Inicializar el proyecto"
echo "2. terraform plan    # Vista previa de lo que se creará"
echo "3. terraform apply   # Crear la infraestructura"
echo ""
echo "Tiempo de recuperación: 5 minutos"
echo "Nivel de confianza: Alto"
echo "Documentación: Código autodocumentado"
echo "Reproducibilidad: 100%"

# Limpieza
rm servidor_simple.tf script-configuracion.sh
```

### Script de Asciinema 3: Primera Experiencia con Terraform

```bash
# Título: "Tus Primeros Comandos de Terraform"
echo "Experimentemos los conceptos básicos de Terraform usando nuestro repositorio de Bearsoft.ai..."
echo ""

# Navegar a la capa de infraestructura
cd infrastructure
echo "Estamos en la capa de infraestructura de nuestra arquitectura de 3 niveles"
ls -la
echo ""

# Mostrar un archivo real de Terraform
echo "Así se ve Terraform listo para producción:"
head -20 main.tf
echo ""
echo "No te preocupes por entender todo todavía - ¡vamos construyendo hacia esto!"
echo ""

# Inicializar Terraform
echo "Paso 1: Inicializar Terraform"
echo "Esto descarga los proveedores necesarios y configura el workspace"
echo ""
echo "Comando: terraform init"
echo "(En la demo real, esto realmente se ejecutaría)"
echo ""

# Mostrar qué hace terraform plan
echo "Paso 2: Vista previa de cambios con 'terraform plan'"
echo "Esto muestra lo que Terraform HARÍA, sin hacer cambios"
echo ""
echo "Comando: terraform plan"
echo "(Esto mostraría un plan detallado de recursos a crear)"
echo ""

# Explicar terraform apply
echo "Paso 3: Aplicar cambios con 'terraform apply'"
echo "Esto crea la infraestructura real en GCP"
echo ""
echo "Comando: terraform apply"
echo "(Esto crearía recursos reales de GCP - lo haremos en episodios posteriores)"
echo ""

cd ..
```

### Transiciones Narrativas

**Gancho de Apertura**: "A las 2:30 AM, cada paso manual se siente como una eternidad..."

**Amplificación del Problema**: Mostrar múltiples puntos de falla en el proceso manual

**Vista Previa de la Solución**: "Pero ¿qué tal si hubiera una mejor manera?"

**Llamada a la Acción**: "En nuestro próximo episodio, veremos qué pasa cuando Sarah trata de recrear esta misma configuración dos meses después..."

### Puntos Clave de Enseñanza

1. **Conexión Emocional**: Todos han experimentado el dolor de procesos manuales
2. **Ejemplos Concretos**: Comandos reales, archivos reales, problemas reales
3. **Revelación Progresiva**: Mostrar complejidad gradualmente
4. **Valor Práctico**: Entendimiento inmediato de "por qué importa IaC"

### Preguntas de Evaluación

1. ¿Cuáles son tres problemas con la gestión manual de infraestructura?
2. ¿Qué significa "declarativo" en el contexto de Infrastructure as Code?
3. ¿Cuáles son los tres comandos básicos de Terraform que aprendimos?
4. ¿Cómo ayudaría IaC durante una crisis de medianoche?

### Conclusión del Episodio

**Lo Que Aprendimos**: La infraestructura manual es frágil, consume tiempo y es propensa a errores

**Lo Que Sigue**: "Sarah cree que ha solucionado el problema, pero dos meses después descubre la 'deriva de configuración' - sus entornos de staging y producción están completamente diferentes. ¿Cómo pasó esto? ¿Y cómo puede el estado de Terraform ayudar a prevenirlo?"

**Cliffhanger**: Vista previa de la próxima crisis que la gestión de estado resuelve

Este episodio establece la base emocional - el dolor de los procesos manuales - antes de introducir la solución técnica. Sigue el marco de Duarte contrastando el presente doloroso con el futuro posible, usando storytelling para hacer memorables los conceptos técnicos.