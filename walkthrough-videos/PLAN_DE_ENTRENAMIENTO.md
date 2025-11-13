# Dominio de Infrastructure as Code: De Cero a Héroe
## Un Viaje de Aprendizaje Basado en Historias Usando el Marco de Nancy Duarte

### El Arco Narrativo: "La Historia de la Evolución de la Infraestructura"

**El Viaje de Nuestro Héroe**: Una ingeniera junior encargada de construir infraestructura escalable y confiable para la plataforma de datos en crecimiento de Bearsoft.ai.

**Lo que está en Juego**: La infraestructura manual está fallando. Los despliegues toman semanas. Los entornos se desincronizar. La empresa está perdiendo clientes debido a caídas del sistema.

**La Transformación**: Al dominar Infrastructure as Code, nuestro héroe transforma el caos en sistemas orquestados y confiables.

---

## Ruta de Aprendizaje: Estructura Narrativa Progresiva

### **ACTO I: EL PROBLEMA (Conceptos Fundamentales)**
*"Por qué la Infraestructura Manual está Rota"*

#### Episodio 1: "La Crisis de Medianoche" 
**Duración**: 15 minutos | **Complejidad**: Principiante
**Historia**: Son las 2 AM. El servidor de producción se cayó. Sarah, nuestra ingeniera junior, tiene que recrear todo manualmente desde notas dispersas en la wiki...

**Objetivos de Aprendizaje**:
- Problemas con la infraestructura manual
- ¿Qué es Infrastructure as Code?
- Beneficios de enfoques declarativos vs imperativos

**Demos de Asciinema**:
- Configuración manual del servidor (proceso doloroso)
- Introducción a la sintaxis básica de Terraform
- Primer `terraform plan` y `apply`

#### Episodio 2: "El Desastre de la Deriva de Configuración"
**Duración**: 20 minutos | **Complejidad**: Principiante
**Historia**: Dos meses después, staging y producción se ven completamente diferentes. Nadie sabe qué cambió o cuándo...

**Objetivos de Aprendizaje**:
- Conceptos de gestión de estado
- Archivos de estado de Terraform
- Definiciones básicas de recursos
- Control de versiones para infraestructura

**Demos de Asciinema**:
- Crear un recurso simple de GCP
- Entender el estado de Terraform
- Hacer cambios controlados
- Usar control de versiones

#### Episodio 3: "La Pesadilla de las Dependencias" 
**Duración**: 18 minutos | **Complejidad**: Principiante-Intermedio
**Historia**: Sarah trata de eliminar una red, pero 20 otros recursos dependen de ella. El sistema se cae...

**Objetivos de Aprendizaje**:
- Dependencias de recursos
- Grafo de Terraform
- Dependencias implícitas vs explícitas
- Fuentes de datos vs recursos

**Demos de Asciinema**:
- Usar `terraform graph`
- Crear recursos dependientes
- Entender fuentes de datos
- Eliminación segura de recursos

---

### **ACTO II: SURGE LA SOLUCIÓN (Conceptos Intermedios)**
*"Construyendo los Cimientos"*

#### Episodio 4: "La Primera Victoria - Pensamiento Modular"
**Duración**: 25 minutos | **Complejidad**: Intermedio
**Historia**: Sarah descubre los módulos y de repente su infraestructura se vuelve reutilizable. Construye su primer módulo de VPC...

**Objetivos de Aprendizaje**:
- Conceptos y beneficios de los módulos
- Estructura y mejores prácticas de módulos
- Variables de entrada y salidas
- Control de versiones de módulos

**Demos de Asciinema**:
- Crear la capa de infraestructura de nuestro repo
- Entender entradas/salidas de módulos
- Construir componentes reutilizables

#### Episodio 5: "La Revelación de la Inyección de Variables"
**Duración**: 22 minutos | **Complejidad**: Intermedio
**Historia**: Sarah necesita la misma infraestructura en 3 entornos. El copiar-pegar lleva al caos hasta que descubre la inyección de variables...

**Objetivos de Aprendizaje**:
- Precedencia de variables
- Configuraciones específicas por entorno
- Estrategia de archivos `.tfvars`
- Manejo de variables sensibles

**Demos de Asciinema**:
- Desplegar entorno de staging
- Usar el patrón global.tfvars
- Diferenciación por entorno
- Gestión de secretos

#### Episodio 6: "El Avance de la Arquitectura por Capas"
**Duración**: 30 minutos | **Complejidad**: Intermedio-Avanzado
**Historia**: La infraestructura de Sarah se vuelve compleja. Descubre la separación por capas y de repente todo tiene sentido...

**Objetivos de Aprendizaje**:
- Concepto de capas de infraestructura
- Estrategias de separación de estado
- Fuentes de datos de estado remoto
- Gestión de dependencias entre capas

**Demos de Asciinema**:
- Construir capas infraestructura → aplicaciones → kafka
- Integración de estado remoto
- Patrones de dependencia entre capas

---

### **ACTO III: DOMINIO Y TRANSFORMACIÓN (Conceptos Avanzados)**
*"La Sinfonía Orquestada"*

#### Episodio 7: "La Revelación de Kubernetes"
**Duración**: 35 minutos | **Complejidad**: Avanzado
**Historia**: Sarah necesita gestionar no solo infraestructura, sino aplicaciones. Descubre la integración con Kubernetes...

**Objetivos de Aprendizaje**:
- Uso del proveedor de Kubernetes
- Integración de Helm con Terraform
- Patrones de Workload Identity
- Conceptos de service mesh

**Demos de Asciinema**:
- Desplegar capa de aplicaciones
- Integración Kubernetes + Terraform
- Gestión de charts de Helm
- Configuración de Workload Identity

#### Episodio 8: "El Dominio del Streaming de Eventos con Kafka"
**Duración**: 40 minutos | **Complejidad**: Avanzado
**Historia**: El equipo de datos necesita procesamiento de eventos en tiempo real. Sarah construye una plataforma completa de streaming de eventos con auto-scaling y monitoreo...

**Objetivos de Aprendizaje**:
- Infraestructura de streaming de eventos
- Patrones de auto-scaling
- Monitoreo y observabilidad
- Integración completa del sistema

**Demos de Asciinema**:
- Despliegue completo de Kafka
- Configuración de auto-scaling con KEDA
- Pipeline de eventos end-to-end
- Configuración de monitoreo

#### Episodio 9: "El Triunfo del Despliegue en Producción"
**Duración**: 30 minutos | **Complejidad**: Avanzado
**Historia**: Sarah despliega confiadamente en producción, con planes de rollback, monitoreo y tiempo de inactividad cero...

**Objetivos de Aprendizaje**:
- Estrategias de despliegue en producción
- Despliegues blue-green
- Procedimientos de rollback
- Monitoreo avanzado

**Demos de Asciinema**:
- Despliegue en producción
- Escenarios de rollback
- Monitoreo de rendimiento
- Recuperación ante desastres

---

### **EPÍLOGO: CONTINÚA EL DOMINIO (Nivel Experto)**
*"Construyendo el Futuro"*

#### Episodio 10: "La Evolución de la Ingeniería de Plataforma"
**Duración**: 45 minutos | **Complejidad**: Experto
**Historia**: Sarah se convierte en ingeniera de plataforma, construyendo infraestructura de autoservicio para todo el equipo de ingeniería...

**Objetivos de Aprendizaje**:
- Conceptos de ingeniería de plataforma
- Workflows de GitOps
- Políticas como código
- Pruebas de infraestructura

**Demos de Asciinema**:
- Configuración de pipeline GitOps
- Pruebas de infraestructura
- Aplicación de políticas
- Plataformas de autoservicio

---

## Guías de Producción

### Aplicación del Marco de Nancy Duarte:

1. **Lo Que Es (Estado Actual)**: Cada episodio comienza con el estado actual doloroso
2. **Lo Que Podría Ser (Visión)**: Mostrar el estado futuro transformado
3. **Contraste**: Comparaciones dramáticas antes/después
4. **Llamada a la Acción**: Pasos claros siguientes para los espectadores

### Elementos Narrativos:

- **Desarrollo de Personaje**: Sarah evoluciona de ingeniera junior a senior
- **Stakes Emocionales**: Impacto real de negocio de las decisiones de infraestructura
- **Metáforas Visuales**: Infraestructura como planeación urbana, código como planos
- **Cliffhangers**: Cada episodio termina con un nuevo desafío

### Producción Técnica:

- **Scripts de Asciinema**: Pre-escritos, probados, con manejo de errores
- **Entorno Real**: Usando el repositorio real de Bearsoft.ai
- **Complejidad Progresiva**: Cada concepto se construye sobre los anteriores
- **Práctica Hands-on**: Los espectadores pueden seguir el ritmo

### Estrategia de Evaluación:

- **Revisiones de Conocimiento**: Quizzes rápidos después de cada episodio
- **Labs Prácticos**: Ejercicios hands-on usando el repositorio
- **Proyecto Capstone**: Construir infraestructura completa desde cero
- **Revisión entre Pares**: Sesiones de revisión de código

---

## Plan de Implementación

### Fase 1: Fundamentos (Episodios 1-3)
- Crear scripts de conceptos básicos
- Construir demostraciones simples
- Enfocar en "por qué" antes de "cómo"

### Fase 2: Construcción de Habilidades (Episodios 4-6)
- Desarrollar complejidad intermedia
- Usar ejemplos reales del repositorio
- Enfatizar mejores prácticas

### Fase 3: Dominio (Episodios 7-10)
- Patrones avanzados de integración
- Despliegues listos para producción
- Conceptos de ingeniería de plataforma

### Métricas de Éxito:
- Los ingenieros pueden desplegar infraestructura independientemente
- 80% de reducción en incidentes relacionados con infraestructura
- 90% más rápido el aprovisionamiento de entornos
- Alta confianza en despliegues de producción

Este entrenamiento transforma ingenieros junior intimidados en practicantes de infraestructura seguros a través de storytelling atractivo y experiencia hands-on con nuestro repositorio de Bearsoft.ai.