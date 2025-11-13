# Episodio 2: El Desastre de la Deriva de Configuración
## Duración: 20 minutos | Complejidad: Principiante

### Configuración de la Historia: Marco de Nancy Duarte

**LO QUE ES (Realidad Dolorosa Actual)**
Dos meses después del triunfo de medianoche de Sarah con su primer despliegue de Terraform, se enfrenta a una nueva crisis. Aparece un bug crítico en producción, pero cuando trata de reproducirlo en staging, no pasa nada. Después de investigar, descubre la verdad aterradora: staging y producción están completamente diferentes. Alguien cambió producción manualmente, staging se actualizó de forma distinta, y ahora nadie sabe cuál debería ser la configuración "real".

**LO QUE PODRÍA SER (Visión de un Mejor Futuro)**
Imagínate infraestructura donde cada cambio está rastreado, cada entorno es idéntico, y podés ver exactamente qué cambió, cuándo, y quién lo hizo. Un mundo donde la "deriva de configuración" se vuelve imposible.

### Objetivos de Aprendizaje

1. Entender el concepto de deriva de configuración
2. Aprender cómo el estado de Terraform previene la deriva
3. Dominar definiciones básicas de recursos y gestión de estado
4. Implementar control de versiones para infraestructura
5. Crear cambios controlados y rastreados

### Desarrollo de la Historia

Sarah descubre que:
- Producción tiene 8 núcleos de CPU, staging tiene 4
- Producción tiene reglas adicionales de firewall que nadie documentó
- Staging tiene configuraciones de debug habilitadas que producción no tiene
- Tres personas diferentes hicieron cambios manuales durante dos meses
- Nadie recuerda cuál debería ser la configuración "correcta"

### Script de Asciinema 1: Descubriendo la Deriva

```bash
# Título: "El Descubrimiento de la Deriva de Configuración"
echo "Dos meses después del éxito inicial de Sarah..."
echo "Aparece un bug en producción pero no en staging. Vamos a investigar."
echo ""

# Simular la verificación de la infraestructura actual
echo "Sarah revisa la configuración del servidor de producción:"
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

echo "Ahora revisa staging:"
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

echo "Y finalmente, lo que dice el código de Terraform:"
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

echo "¡Tres configuraciones diferentes! Esto es DERIVA DE CONFIGURACIÓN."
echo "Sarah necesita entender cuál es 'correcta' y cómo prevenir esto."

rm realidad_produccion.txt realidad_staging.txt definicion_terraform.txt
```

### Script de Asciinema 2: Entendiendo el Estado de Terraform

```bash
# Título: "Estado de Terraform - La Fuente de Verdad"
echo "Aprendamos cómo Terraform previene la deriva de configuración..."
echo ""

# Moverse a nuestra infraestructura demo
cd infrastructure
echo "Primero, entendamos qué es el estado de Terraform:"
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

echo "Acá tenemos una definición simple de recurso:"
cat ejemplo_simple.tf
echo ""

echo "Cuando ejecutamos 'terraform apply', Terraform crea dos cosas:"
echo "1. El recurso real en GCP (el bucket)"
echo "2. Un archivo de estado que rastrea lo que se creó"
echo ""

echo "Simulemos el workflow de terraform:"
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

echo "Este archivo de estado es la 'memoria' de Terraform de lo que existe en GCP."
echo "Es así como Terraform detecta deriva y planea cambios."

rm ejemplo_simple.tf estado_ejemplo.json
cd ..
```

### Script de Asciinema 3: Previniendo la Deriva con Control de Versiones

```bash
# Título: "Control de Versiones: Historia de Infrastructure as Code"
echo "Sarah aprende a prevenir la deriva usando control de versiones con Git..."
echo ""

# Demostrar el workflow de control de versiones
echo "Paso 1: Inicializar repositorio Git para infraestructura"
echo "$ git init"
echo "$ git add ."
echo "$ git commit -m 'Configuración inicial de infraestructura'"
echo ""

echo "Paso 2: Hacer un cambio controlado a la infraestructura"
cd infrastructure

# Mostrar cómo hacer un cambio a la infraestructura
echo "Sarah necesita actualizar el tamaño del disco del entorno de staging:"
echo ""
echo "Antes del cambio en variables.tf:"
echo "core_node_pool_disk_size = 50  # Tamaño actual"
echo ""
echo "Después del cambio en variables.tf:"
echo "core_node_pool_disk_size = 100  # Tamaño actualizado"
echo ""

echo "Paso 3: Planear el cambio para ver qué pasará"
echo "$ terraform plan -var-file='../environments/staging/global.tfvars'"
echo ""
echo "Terraform mostrará exactamente qué cambiará:"
echo "~ google_container_node_pool.core_nodes"
echo "  ~ node_config {"
echo "    ~ disk_size_gb = 50 -> 100"
echo "    }"
echo ""

echo "Paso 4: Aplicar el cambio"
echo "$ terraform apply"
echo "La infraestructura se actualiza consistentemente."
echo ""

echo "Paso 5: Hacer commit del cambio al control de versiones"
echo "$ git add variables.tf"
echo "$ git commit -m 'Actualizar tamaño de disco staging de 50GB a 100GB'"
echo ""

echo "Ahora el cambio está:"
echo "- Documentado en el historial de Git"
echo "- Rastreado en el estado de Terraform"
echo "- Aplicado consistentemente"
echo "- Reproducible en otros entornos"

cd ..
```

### Script de Asciinema 4: Detectando y Arreglando Deriva

```bash
# Título: "Detección y Resolución de Deriva"
echo "¿Qué pasa cuando alguien hace cambios manuales fuera de Terraform?"
echo ""

# Simular escenario de deriva
echo "Escenario: Alguien cambió manualmente el cluster de GKE en la consola de GCP"
echo "Agregaron node pools extra y cambiaron tipos de máquina..."
echo ""

echo "Sarah ejecuta 'terraform plan' para detectar deriva:"
echo "$ terraform plan"
echo ""

echo "Salida de Terraform:"
echo "Nota: Los objetos han cambiado fuera de Terraform"
echo ""
echo "Terraform detectó los siguientes cambios hechos fuera de Terraform"
echo "desde el último 'terraform apply':"
echo ""
echo "  # google_container_node_pool.worker_nodes ha cambiado"
echo "  ~ resource \"google_container_node_pool\" \"worker_nodes\" {"
echo "    ~ machine_type = \"e2-medium\" -> \"e2-standard-4\""
echo "    }"
echo ""

echo "Sarah tiene tres opciones para arreglar esta deriva:"
echo ""

echo "Opción 1: REVERTIR - Dejar que Terraform arregle la deriva"
echo "$ terraform apply"
echo "Esto cambiará el tipo de máquina de vuelta a e2-medium"
echo ""

echo "Opción 2: ACEPTAR - Actualizar el código para que coincida con la realidad"
echo "Actualizar variables.tf:"
echo "worker_node_pool_machine_type = \"e2-standard-4\""
echo "Después: $ terraform plan  # No debería mostrar cambios"
echo ""

echo "Opción 3: INVESTIGAR - Tal vez este cambio era necesario"
echo "Verificar con el equipo, entender por qué se hizo el cambio"
echo "Documentar la decisión en un commit de Git"
echo ""

echo "Sarah elige la Opción 2 - aceptar y documentar el cambio:"
echo "$ git add variables.tf"
echo "$ git commit -m 'Aceptar optimización de producción: actualizar worker nodes a e2-standard-4'"
echo ""

echo "¡Deriva resuelta! Código e infraestructura están sincronizados de nuevo."
```

### Puntos Clave de Enseñanza

**Gestión de Estado**:
- El archivo de estado es la "memoria" de Terraform
- Rastrea qué recursos existen y su configuración
- Permite detección de deriva
- Debe almacenarse remotamente para colaboración en equipo

**Beneficios del Control de Versiones**:
- Cada cambio está documentado
- Quién hizo qué cambio y cuándo
- Capacidad de hacer rollback de cambios
- Proceso de revisión de código para cambios de infraestructura

**Prevención de Deriva**:
- Todos los cambios van a través de Terraform
- Detección regular de deriva con `terraform plan`
- Procesos y políticas del equipo
- Bloqueo de estado remoto

### Preguntas de Evaluación

1. ¿Qué es la deriva de configuración y por qué es peligrosa?
2. ¿Cómo ayuda el estado de Terraform a prevenir la deriva?
3. ¿Cuáles son las tres opciones cuando se detecta deriva?
4. ¿Por qué es importante el control de versiones para el código de infraestructura?

### Conclusión del Episodio

**Lo Que Aprendimos**: 
- La deriva de configuración pasa cuando la realidad difiere del código
- El estado de Terraform rastrea infraestructura y detecta deriva
- El control de versiones proporciona historial de cambios y responsabilidad
- La planificación regular ayuda a detectar deriva temprano

**Transición Dramática**: "Sarah se siente confiada sobre la gestión de estado, pero una semana después se enfrenta a su desafío más grande hasta ahora. Trata de eliminar un recurso de red simple y mira con horror cómo Terraform quiere destruir 47 otros recursos. ¿Qué salió mal? ¿Y cómo puede la gestión de dependencias salvar su infraestructura del desastre?"

**Lo Que Sigue**: El Episodio 3 abordará el mundo complejo de las dependencias de recursos y el grafo de dependencias de Terraform.

Este episodio construye sobre los cimientos del Episodio 1, introduciendo conceptos más técnicos mientras mantiene el marco narrativo. El problema de deriva es relatable - todos han experimentado sistemas que "de alguna manera cambiaron" con el tiempo.