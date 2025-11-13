# Episodio 3: La Pesadilla de las Dependencias
## Duración: 18 minutos | Complejidad: Principiante-Intermedio

### Configuración de la Historia: Marco de Nancy Duarte

**LO QUE ES (Realidad Dolorosa Actual)**
Sarah se siente confiada después de dominar la gestión de estado. Decide limpiar algunos recursos no utilizados en staging. Apunta a lo que parece ser una red VPC simple y no utilizada. Ejecuta `terraform destroy` solo en ese recurso y mira con horror cómo Terraform planea destruir 47 otros recursos: bases de datos, servidores de aplicaciones, balanceadores de carga y sistemas de almacenamiento. Todo el entorno de staging se borraría. ¿Cómo están conectados estos recursos? ¿Y por qué no sabía sobre estas dependencias?

**LO QUE PODRÍA SER (Visión de un Mejor Futuro)**
Imagínate entender exactamente cómo cada pieza de tu infraestructura se conecta con cada otra pieza. Imaginate poder visualizar estas relaciones, hacer cambios seguros, y nunca destruir accidentalmente sistemas críticos debido a dependencias ocultas.

### Objetivos de Aprendizaje

1. Entender dependencias de recursos implícitas vs explícitas
2. Aprender a usar `terraform graph` para visualizar dependencias
3. Dominar fuentes de datos vs recursos
4. Implementar estrategias seguras de eliminación de recursos
5. Diseñar infraestructura consciente de dependencias

### Desarrollo de la Historia

El viaje de descubrimiento de dependencias de Sarah:
- Una eliminación "simple" de red destruiría todo el entorno
- Los recursos tienen dependencias implícitas (cluster GKE depende de VPC)
- Algunas dependencias son explícitas (base de datos depende de subnet específica)
- Las dependencias forman un grafo complejo, no una lista simple
- Entender las dependencias es crucial para cambios seguros de infraestructura

### Script de Asciinema 1: El Descubrimiento del Casi-Desastre

```bash
# Título: "El Plan de Destrucción Accidental"
echo "Sarah quiere limpiar una red VPC no utilizada en staging..."
echo "Parece bastante simple. ¿Qué podría salir mal?"
echo ""

# Simular el plan peligroso de terraform
echo "Sarah crea un plan para destruir solo la VPC:"
cat > destruir_vpc.tf << 'EOF'
# Sarah piensa que esta VPC no se usa y puede eliminarse de forma segura
# Está a punto de aprender sobre dependencias implícitas...
resource "google_compute_network" "vpc_vieja" {
  name                    = "vpc-vieja-sin-uso"
  auto_create_subnetworks = false
}
EOF

echo "La VPC objetivo parece bastante inocente:"
cat destruir_vpc.tf
echo ""

echo "Sarah ejecuta: terraform plan -destroy -target=google_compute_network.vpc_vieja"
echo ""
echo "La respuesta de Terraform es aterradora:"
echo ""

cat > plan_destruccion.txt << 'EOF'
Terraform realizará las siguientes acciones:

  # google_compute_network.vpc_vieja será destruida
  - resource "google_compute_network" "vpc_vieja" {...}

  # google_container_cluster.primary será destruido
  # (porque depende de la VPC que está siendo destruida)
  - resource "google_container_cluster" "primary" {...}

  # google_container_node_pool.core_nodes será destruido
  # (porque depende del cluster que está siendo destruido)
  - resource "google_container_node_pool" "core_nodes" {...}

  # google_sql_database_instance.kafka_db será destruida
  # (porque usa la red privada de la VPC)
  - resource "google_sql_database_instance" "kafka_db" {...}

  # ... 43 recursos más serán destruidos

Plan: 0 para agregar, 0 para cambiar, 47 para destruir.
EOF

cat plan_destruccion.txt
echo ""

echo "El corazón de Sarah se detiene. Esta VPC 'sin uso' destruiría:"
echo "- Todo el cluster de GKE"
echo "- Todas las aplicaciones ejecutándose en el cluster"  
echo "- La base de datos de Kafka con meses de historial de eventos"
echo "- Sistemas de almacenamiento con datos críticos"
echo "- 43 otros recursos interconectados"
echo ""

echo "Cancela la operación inmediatamente."
echo "¿Pero cómo se suponía que supiera sobre estas dependencias?"

rm destruir_vpc.tf plan_destruccion.txt
```

### Script de Asciinema 2: Entendiendo el Grafo de Dependencias

```bash
# Título: "Visualizando Dependencias de Infraestructura"
echo "Sarah aprende a mapear las dependencias de su infraestructura..."
echo ""

# Moverse a nuestra capa de infraestructura
cd infrastructure
echo "Terraform tiene una herramienta poderosa para entender dependencias: terraform graph"
echo ""

echo "$ terraform graph"
echo "Este comando muestra cómo los recursos dependen unos de otros."
echo ""

# Mostrar un grafo de dependencias simplificado
echo "Esto es lo que revela el grafo de dependencias:"
cat > ejemplo_dependencia.txt << 'EOF'
Ejemplo de Cadena de Dependencias:

Red VPC
    ↓
Subnet (depende de VPC)
    ↓  
Cluster GKE (depende de Subnet)
    ↓
Node Pools (dependen del Cluster)
    ↓
Aplicaciones (dependen de Node Pools)

Más dependencias en paralelo:
VPC → Red Privada → Cloud SQL → Kafka
VPC → Reglas de Firewall → Load Balancer → Ingress
EOF

cat ejemplo_dependencia.txt
echo ""

echo "Examinemos las dependencias reales de nuestra infraestructura:"
echo ""

# Mostrar dependencias reales de nuestro repo
echo "En nuestro infrastructure/main.tf, podemos ver dependencias:"
echo ""

echo "1. Dependencias IMPLÍCITAS (Terraform las descifra):"
grep -A 5 "network.*=" main.tf 2>/dev/null || echo "  subnetwork = google_compute_subnetwork.subnet.name"
echo "     # Los node pools automáticamente dependen del cluster"
echo "     # El cluster automáticamente depende de la red"
echo ""

echo "2. Dependencias EXPLÍCITAS (las declaramos nosotros):"
echo "  depends_on = [google_container_cluster.primary]"
echo "     # Le decimos explícitamente a Terraform sobre esta dependencia"
echo ""

echo "3. Dependencias de DATOS (leyendo recursos existentes):"
echo "  data \"google_client_config\" \"default\" {}"
echo "     # Esto lee datos pero no crea dependencias"

rm ejemplo_dependencia.txt
cd ..
```

### Script de Asciinema 3: Fuentes de Datos vs Recursos

```bash
# Título: "Fuentes de Datos: Leer Sin Crear"
echo "Sarah descubre la diferencia entre recursos y fuentes de datos..."
echo ""

cd infrastructure
echo "RECURSOS crean y gestionan infraestructura:"
echo ""

cat > ejemplo_recurso.tf << 'EOF'
# Esto CREA un nuevo bucket de storage
resource "google_storage_bucket" "logs" {
  name     = "bearsoft-logs"
  location = "US"
}
EOF

cat ejemplo_recurso.tf
echo ""

echo "FUENTES DE DATOS leen infraestructura existente:"
echo ""

cat > ejemplo_fuente_datos.tf << 'EOF'
# Esto LEE un proyecto existente (no lo crea)
data "google_project" "current" {}

# Esto LEE info del cluster (no crea el cluster)
data "google_container_cluster" "existing" {
  name     = "mi-cluster-existente"
  location = "us-central1"
}
EOF

cat ejemplo_fuente_datos.tf
echo ""

echo "Diferencias clave:"
echo ""
echo "RECURSOS:"
echo "- Crean, actualizan y destruyen infraestructura"
echo "- Rastreados en el estado de Terraform"
echo "- Pueden ser destruidos por Terraform"
echo "- Ejemplo: google_compute_network"
echo ""

echo "FUENTES DE DATOS:"
echo "- Leen información sobre infraestructura existente"
echo "- No crean ni destruyen nada"
echo "- No rastreados en estado como recursos gestionables"
echo "- Ejemplo: data.google_project.current"
echo ""

echo "En nuestra capa de aplicaciones, usamos fuentes de datos para leer"
echo "infraestructura creada por la capa de infraestructura:"
echo ""

cd ../applications
head -10 provider.tf 2>/dev/null || echo "data \"terraform_remote_state\" \"infrastructure\" {"
echo "  # Esto lee outputs de la capa de infraestructura"
echo "  # sin crear una dependencia que podría destruirla"
echo "}"

rm -f ../infrastructure/ejemplo_recurso.tf ../infrastructure/ejemplo_fuente_datos.tf
cd ..
```

### Script de Asciinema 4: Estrategias de Eliminación Segura

```bash
# Título: "Cambios Seguros de Infraestructura"
echo "Sarah aprende cómo modificar infraestructura de forma segura con dependencias..."
echo ""

echo "Estrategia 1: PLANEAR PRIMERO, SIEMPRE"
echo "$ terraform plan"
echo "Siempre verificar qué hará Terraform antes de aplicar cambios"
echo ""

echo "Estrategia 2: USAR OPERACIONES DIRIGIDAS CON CUIDADO"
echo "$ terraform plan -target=recurso_específico"
echo "Pero entender que los targets pueden romper dependencias"
echo ""

echo "Estrategia 3: ENTENDER LA CADENA DE DEPENDENCIAS"
echo "Antes de eliminar cualquier cosa, preguntarse:"
echo "- ¿Qué depende de este recurso?"
echo "- ¿Qué se romperá si lo elimino?"
echo "- ¿Necesito eliminar dependientes primero?"
echo ""

echo "Estrategia 4: USAR TERRAFORM GRAPH"
echo "$ terraform graph | dot -Tpng > dependencias.png"
echo "Visualizar dependencias antes de hacer cambios"
echo ""

echo "Estrategia 5: CAMBIOS INCREMENTALES"
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

echo "Enfoque de migración segura:"
cat migracion_segura.sh
echo ""

echo "Este enfoque:"
echo "- Minimiza el riesgo de cambios que rompan cosas"
echo "- Permite pruebas en cada paso"
echo "- Proporciona opciones de rollback"
echo "- Mantiene la disponibilidad del sistema"

rm migracion_segura.sh
```

### Script de Asciinema 5: Mejores Prácticas de Dependencias

```bash
# Título: "Diseñando Infraestructura Consciente de Dependencias"
echo "Sarah aprende a diseñar mejores dependencias de infraestructura..."
echo ""

echo "MEJOR PRÁCTICA 1: Estratificar Dependencias Claramente"
echo "Nuestra arquitectura de 3 capas previene dependencias circulares:"
echo ""

echo "Capa de Infraestructura (Fundación)"
echo "    ↓ (proporciona outputs)"
echo "Capa de Aplicaciones (Plataforma)"  
echo "    ↓ (proporciona servicios)"
echo "Capa de Kafka (Cargas de Trabajo)"
echo ""

echo "Cada capa solo depende de las capas debajo de ella."
echo ""

echo "MEJOR PRÁCTICA 2: Usar Dependencias Explícitas Cuando Sea Necesario"
cd infrastructure

echo "Ejemplo de nuestro código de infraestructura:"
grep -A 2 -B 2 "depends_on" main.tf 2>/dev/null || cat << 'EOF'
resource "kubernetes_storage_class" "gp2" {
  # ... configuración ...
  
  depends_on = [
    null_resource.delete_default_gp2,
    aws_eks_access_policy_association.cluster_creator_admin
  ]
}
EOF
echo ""

echo "MEJOR PRÁCTICA 3: Minimizar Dependencias Entre Capas"
echo "En lugar de referenciar recursos directamente entre capas:"
echo "❌ MALO: referenciar IDs específicos de recursos"
echo "✅ BUENO: usar outputs y fuentes de datos"
echo ""

cd ../applications
echo "En la capa de aplicaciones, usamos estado remoto:"
head -5 provider.tf 2>/dev/null || echo 'data "terraform_remote_state" "infrastructure" {'
echo "Esto crea una dependencia de datos, no una dependencia de recurso"
echo ""

cd ..

echo "MEJOR PRÁCTICA 4: Documentar Dependencias"
echo "Nuestro README.md muestra el orden de despliegue:"
echo "1. infrastructure → 2. applications → 3. kafka"
echo "Esto hace claras las dependencias para el equipo."
```

### Puntos Clave de Enseñanza

**Tipos de Dependencias**:
- **Implícitas**: Terraform las infiere de los atributos de recursos
- **Explícitas**: Declaradas con `depends_on`
- **Datos**: Flujo de información sin dependencias de recursos

**Estrategias de Seguridad**:
- Siempre planear antes de aplicar
- Entender el impacto antes de hacer cambios
- Usar visualización de grafos
- Hacer cambios incrementales
- Diseñar teniendo en mente las dependencias

**Patrones de Arquitectura**:
- Estratificar dependencias claramente
- Evitar dependencias circulares
- Usar outputs y fuentes de datos para comunicación entre capas
- Documentar relaciones de dependencias

### Preguntas de Evaluación

1. ¿Cuál es la diferencia entre dependencias implícitas y explícitas?
2. ¿Cómo ayuda `terraform graph` con la gestión de dependencias?
3. ¿Cuál es la diferencia entre un recurso y una fuente de datos?
4. ¿Cuáles son tres estrategias para eliminación segura de recursos?

### Conclusión del Episodio

**Lo Que Aprendimos**:
- Las dependencias forman grafos complejos, no listas simples
- Entender dependencias previene destrucción accidental
- Terraform proporciona herramientas para visualizar y gestionar dependencias
- Los cambios seguros requieren planificación y enfoques incrementales

**Transición Dramática**: "Sarah ahora entiende recursos individuales y sus dependencias, pero su infraestructura está volviéndose compleja. Está copiando y pegando configuraciones similares para diferentes entornos. Su colega le menciona los 'módulos' y de repente Sarah se da cuenta de que ha estado haciendo las cosas de la manera difícil. ¿Qué son los módulos, y cómo pueden transformar su pesadilla de copiar-pegar en infraestructura elegante y reutilizable?"

**Lo Que Sigue**: El Episodio 4 introducirá el pensamiento modular y mostrará cómo construir componentes de infraestructura reutilizables.

Este episodio escala la complejidad técnica mientras mantiene la tensión narrativa. El escenario del casi-desastre hace que la gestión de dependencias sea visceralmente importante en lugar de solo académicamente interesante.