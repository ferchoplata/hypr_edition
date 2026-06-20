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

## Prueba de Waybar y Command Center

- `SUPER + SHIFT + B` recorre los tres modelos sin abrir un menu externo.
- Cada modelo reinicia Waybar sin cerrar la sesion.
- `SUPER + N` abre y cierra el centro de control.
- Wi-Fi y Bluetooth reflejan su estado real.
- Audio, brillo y controles multimedia responden cuando el hardware los ofrece.
- El boton de energia abre las cuatro acciones dentro de Command Center.
- Las teclas de volumen muestran SwayOSD y modifican el nivel.
- Las teclas de brillo muestran SwayOSD cuando existe un dispositivo compatible.
- Sin adaptador Bluetooth, el panel abre sin bloquearse y Blueman no muestra un error.

## Errores conocidos revisados

- `dwindle:pseudotile` no existe en Hyprland actual; la config base usa `preserve_split` solamente.
- El aviso `Hyprland was started without start-hyprland` se corrige entrando desde la sesion `hypr_edition` creada por el instalador.
- Si `sddm.service` no existe, falta instalar `sddm`; debe estar en `packages/common.txt`.
- Si Kitty abre y se cierra, usar una config conservadora primero y validar opciones avanzadas una por una.
