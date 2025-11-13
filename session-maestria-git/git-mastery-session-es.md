# Sesión de Maestría en Git: "El Kit de DevOps del Oso"

Acá tenés una secuencia progresiva e interactiva de CLI que va a hacer que tu equipo se sienta en un montaje de hackers mientras aprenden habilidades reales de DevOps.

---

## ACTO I: Arqueología Git - "Conocé Tu Historia"

```bash
# Empezamos con estilo
clear && echo "=== Bienvenidos al Dojo Git del Oso ===" && sleep 1

# Clonar el repo (si no lo tienen ya)
git clone https://github.com/thebearsoft/terraform-lab
cd terraform-lab

# Mostrarles el poder de los aliases de git log
git l
```

**PAUSA Y PREGUNTA:** *"¿Qué ven? ¿Qué les dice el gráfico sobre las ramas?"*

```bash
# Comparar con el log aburrido por defecto
git log --oneline

# Ahora mostrarles TU manera
git l -10

# ¿Quién ha estado trabajando en esto?
git who

# Revisar actividad reciente
git r
```

**PAUSA Y PREGUNTA:** *"¿Por qué es importante un historial de git legible para DevOps? ¿Qué pasa durante un incidente de producción?"*

---

## ACTO II: Gimnasia de Ramas - "GitFlow en Acción"

```bash
# Mostrar estado actual
git s

# Crear una rama feature (estilo GitFlow)
git co -b feature/add-monitoring-module

# Mostrar estructura de ramas
git br -a

# Crear un archivo de prueba
echo "# Monitoring Module" > modules/monitoring/main.tf
mkdir -p modules/monitoring
echo 'resource "aws_cloudwatch_alarm" "example" {
  alarm_name = "terraform-lab-cpu-alarm"
}' > modules/monitoring/main.tf
```

**PAUSA Y PREGUNTA:** *"En GitFlow, ¿cuál es la diferencia entre ramas feature/, release/, y hotfix/?"*

```bash
# Stagear y commitear al estilo del Oso
git c -m "feat: add CloudWatch monitoring module"

# Revisar el gráfico ahora
git l -5

# Volver a main
git co main

# Ver la diferencia
git di feature/add-monitoring-module

# Ver estadísticas (el favorito de Jimmy)
git ds feature/add-monitoring-module
```

---

## ACTO III: Viaje en el Tiempo - "Deshacer como un Pro"

```bash
# Crear un "error"
echo "password=supersecret123" >> .env
git add .env
git ci -m "fix: update configuration"

# OH NO!
git l -3
```

**PAUSA Y PREGUNTA:** *"¿Qué acaba de pasar? ¿Cómo lo arreglamos SIN reescribir historia pública?"*

```bash
# Si no se ha pusheado todavía - enmendarlo
rm .env
git add .
git commit --amend -m "fix: update configuration (cleaned)"

# O usar tu alias
git fuck

# Si ya se pusheó y otros lo bajaron
echo "# Safe config" > config.example
git add config.example
git ci -m "fix: add safe config example"

# Revisar qué cambió en el último commit
git dh1

# Mostrar el último commit con contexto completo
git hp
```

---

## ACTO IV: Técnicas de Colaboración - "Maestría en Sincronización de Equipo"

```bash
# Traer todo
git fa

# Ver todas las ramas remotas
git br -r

# Crear un escenario de conflicto (demo)
git co main
echo "version = 1.0" >> version.txt
git c -m "chore: bump version to 1.0"

# Simular trabajo de compañero
git co -b feature/teammate-work
echo "version = 2.0" > version.txt
git c -m "chore: bump version to 2.0"

# Intentar hacer merge
git co main
git merge feature/teammate-work
```

**PAUSA Y PREGUNTA:** *"¡Conflicto! Esto pasa en CI/CD. ¿Cómo lo resolvemos de forma segura?"*

```bash
# Mostrar el conflicto
cat version.txt

# Resolverlo
echo "version = 2.0" > version.txt
git add version.txt
git ci -m "merge: resolve version conflict"

# Limpiar ramas mergeadas
git cleanbr
```

---

## ACTO V: Magia de GitHub + DevOps - "Integración CI/CD"

```bash
# Crear un workflow de GitHub Actions
mkdir -p .github/workflows
cat > .github/workflows/terraform-validate.yml << 'EOF'
name: Terraform Validation

on:
  pull_request:
    branches: [ main ]
  push:
    branches: [ main ]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        
      - name: Terraform Format Check
        run: terraform fmt -check -recursive
        
      - name: Terraform Init
        run: terraform init -backend=false
        
      - name: Terraform Validate
        run: terraform validate
EOF

git add .github/
git ci -m "ci: add terraform validation workflow"
```

**PAUSA Y PREGUNTA:** *"¿Cómo conecta este workflow los commits de git con cambios de infraestructura? ¿Cuál es el loop de DevOps acá?"*

---

## ACTO VI: Trucos Avanzados - "Las Armas Secretas del Oso"

```bash
# 1. Rebase Interactivo (limpiar historial antes de PR)
git co -b feature/cleanup-demo
echo "test1" > test.txt && git add . && git ci -m "wip: test1"
echo "test2" >> test.txt && git add . && git ci -m "wip: test2"
echo "test3" >> test.txt && git add . && git ci -m "feat: add feature"

git l -5
# git rebase -i HEAD~3  # Abriría el editor para hacer squash

# 2. Cherry-pick (agarrar commits específicos)
git co main
git cherry-pick feature/cleanup-demo

# 3. Stash (guardar trabajo en progreso)
echo "unfinished work" > wip.tf
git stash
git s  # Limpio!
git stash list
git stash pop

# 4. Bisect (encontrar introducción de bug - concepto demo)
# git bisect start
# git bisect bad HEAD
# git bisect good v1.0.0

# 5. Reflog (recuperar commits "perdidos")
git reflog -10
```

---

## ACTO VII: Movidas Power con GitHub CLI

```bash
# Instalar gh CLI si no está presente
# gh auth login

# Crear PR desde línea de comandos
gh pr create --title "feat: add monitoring module" \
  --body "Adds CloudWatch alarms for infrastructure monitoring" \
  --base main

# Revisar estado del PR
gh pr list

# Revisar checks del PR (estado CI/CD)
gh pr checks

# Mergear cuando esté listo
# gh pr merge --squash
```

---

## LA BOLSA DE TRUCOS DEL OSO - Tarjeta de Referencia Rápida

Crear un archivo de cheatsheet:

```bash
cat > GIT_TRICKS.md << 'EOF'
# Los Trucos Git del Oso

## Operaciones Diarias
- `git s` - Revisar status
- `git c -m "msg"` - Agregar todo & commitear
- `git l` - Log con gráfico bonito
- `git who` - Ver contribuidores

## Manejo de Ramas
- `git co -b feature/name` - Crear rama feature
- `git cleanbr` - Remover ramas mergeadas
- `git br -a` - Mostrar todas las ramas

## Viaje en el Tiempo
- `git fuck` - Enmendar & force push (usar con cuidado!)
- `git dh1` - Diff contra último commit
- `git reflog` - Recuperar trabajo perdido

## Colaboración
- `git fa` - Traer todos los remotes
- `git pullff` - Pull con fast-forward solamente
- `git stash` - Guardar WIP

## Integración DevOps
- Pull Requests disparan CI/CD
- Terraform validate corre en cada PR
- Rama main = código listo para producción
- Ramas feature = desarrollo aislado

## Comandos GitFlow
- `git fs feature-name` - Iniciar feature
- `git ff` - Finalizar feature
- `git rs 1.0.0` - Iniciar release
EOF

git add GIT_TRICKS.md
git ci -m "docs: add git tricks reference"
```

---

## FINAL: Escenario Real de DevOps

```bash
# Simular un escenario de hotfix
git co main
git co -b hotfix/critical-security-patch

# Hacer el fix
echo 'variable "enable_encryption" { default = true }' > security.tf
git c -m "fix: enable encryption by default (CVE-2024-XXXX)"

# Pushear y crear PR
git push origin hotfix/critical-security-patch
gh pr create --title "HOTFIX: Enable encryption" --label "security,hotfix"

# Después que pasa el CI y la revisión
git co main
git merge --no-ff hotfix/critical-security-patch
git tag -a v1.0.1 -m "Security hotfix"
git push origin main --tags

# Este push dispara:
# 1. Pipeline CI/CD
# 2. Terraform plan
# 3. Auto-deploy a staging
# 4. Aprobación manual para producción
```

**PREGUNTA FINAL:** *"¿Cómo protege producción este workflow de git? ¿Cuál es el rol de las ramas, PRs, y CI/CD?"*

---

## Tópicos de Q&A Interactivos

Durante la sesión, entretejer estas preguntas:

1. **¿Por qué ramas feature?** (Aislamiento, trabajo paralelo, code review)
2. **¿Qué hace un buen mensaje de commit?** (Conventional commits: feat/fix/chore)
3. **¿Cuándo usamos `--force`?** (Solo en ramas personales, NUNCA en main)
4. **¿Cómo sabe GitHub Actions que debe correr?** (Webhooks en eventos push/PR)
5. **¿Cuál es la diferencia entre merge y rebase?** (Preservación de historia vs. línea de tiempo limpia)

---

Esta sesión los lleva desde los básicos de git hasta entender cómo el control de versiones es la **columna vertebral de la automatización DevOps**. Al final, van a ver git no como una herramienta de backup, sino como el **mecanismo disparador de todo su pipeline CI/CD**.
