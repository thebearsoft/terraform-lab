# Asciinema Video Generation Guide

## Overview
Este directorio contiene scripts listos para generar videos con asciinema para cada segmento de los episodios de entrenamiento.

## CLI Commands para generar videos con asciinema

### Recording Individual Scripts

Para grabar cada script como un video de asciinema:

```bash
# Episode 1a - Manual Pain
asciinema rec episodio-01a-dolor-manual.cast -c "./episodio-01a-dolor-manual.sh"

# Episode 1b - IaC Alternative  
asciinema rec episodio-01b-alternativa-iac.cast -c "./episodio-01b-alternativa-iac.sh"

# Episode 1c - First Commands
asciinema rec episodio-01c-primeros-comandos.cast -c "./episodio-01c-primeros-comandos.sh"
```

### Recording with Custom Settings

Para control más granular sobre la grabación:

```bash
# With custom title and slower playback
asciinema rec episodio-01a-dolor-manual.cast \
  --title "Episodio 1a: El Dolor Manual" \
  --command "./episodio-01a-dolor-manual.sh"

# With idle time limit (cuts long pauses)
asciinema rec episodio-01b-alternativa-iac.cast \
  --title "Episodio 1b: La Alternativa IaC" \
  --idle-time-limit 2 \
  --command "./episodio-01b-alternativa-iac.sh"

# With environment variables for typing speed
DEMO_MAGIC_NO_WAIT=1 TYPE_SPEED=20 \
asciinema rec episodio-01c-primeros-comandos.cast \
  --title "Episodio 1c: Primeros Comandos" \
  --command "./episodio-01c-primeros-comandos.sh"
```

### Playing Back Recordings

Para reproducir los videos grabados:

```bash
asciinema play episodio-01a-dolor-manual.cast
asciinema play episodio-01b-alternativa-iac.cast  
asciinema play episodio-01c-primeros-comandos.cast
```

### Converting to GIF (Optional)

Si necesitas GIFs para documentación:

```bash
# Install agg first: npm install -g @asciinema/agg
agg episodio-01a-dolor-manual.cast episodio-01a-dolor-manual.gif
agg episodio-01b-alternativa-iac.cast episodio-01b-alternativa-iac.gif
agg episodio-01c-primeros-comandos.cast episodio-01c-primeros-comandos.gif
```

### Uploading to asciinema.org (Optional)

Para compartir los videos:

```bash
asciinema upload episodio-01a-dolor-manual.cast
asciinema upload episodio-01b-alternativa-iac.cast
asciinema upload episodio-01c-primeros-comandos.cast
```

## Script Structure

Cada script sigue el patrón:
- **Título comentado**: Descripción del segmento
- **Echo statements**: Narrativa y explicación
- **Comandos demostrativos**: Creación de archivos, cat, ls, etc.
- **Cleanup**: Remover archivos temporales

## Usage Notes

1. **Ubicación**: Ejecutar desde el directorio `terraform-demo/walkthrough-videos/asciinema-videos/`
2. **Dependencias**: Los scripts asumen que estás en el repositorio terraform-demo
3. **Timing**: Usar `sleep` statements si necesitas pausas dramáticas
4. **Interactividad**: Los scripts son no-interactivos para grabación automática

## Next Steps

Para generar scripts de otros episodios, seguí el mismo patrón:
- Extraer code blocks del markdown del episodio
- Crear scripts individuales (a, b, c, etc.)
- Hacer ejecutables con `chmod +x`
- Grabar con asciinema usando los comandos de arriba