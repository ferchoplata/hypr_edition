# Notas de prueba

Usa este archivo como plantilla cuando pruebes el instalador en CachyOS o Arch.

## Entorno

- Fecha:
- Sistema:
- ISO:
- VM:
- CPU:
- RAM:
- Disco:
- Escritorio instalado inicialmente:

## Validacion previa

```bash
bash scripts/validate.sh
```

Resultado:

```text

```

## Preflight

```bash
bash scripts/preflight.sh
```

Resultado:

```text

```

## Dry-run

```bash
./install.sh --dry-run
```

Opcion probada:

Resultado:

```text

```

## Instalacion real

```bash
./install.sh
```

Opcion probada:

Resultado:

```text

```

## Fallos o ajustes necesarios

-

## Errores conocidos revisados

- `dwindle:pseudotile` no existe en Hyprland actual; la config base usa `preserve_split` solamente.
- El aviso `Hyprland was started without start-hyprland` se corrige entrando desde la sesion `hypr_edition` creada por el instalador.
- Si `sddm.service` no existe, falta instalar `sddm`; debe estar en `packages/common.txt`.
- Si Kitty abre y se cierra, usar una config conservadora primero y validar opciones avanzadas una por una.
