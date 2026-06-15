# Simple Edition

Simple Edition es un instalador modular para preparar un sistema personal basado en CachyOS o Arch Linux.

La idea principal es mantener el sistema en modulos pequenos. Cada modulo puede instalar, respaldar y, cuando sea seguro, desinstalar su parte.

## Uso

En CachyOS o Arch Linux:

```bash
cd simple-edition
chmod +x simple.sh modules/*/*.sh
./simple.sh
```

Desde Windows esta carpeta sirve para editar el proyecto. Para ejecutar el instalador de verdad, copiala a una instalacion Linux o a una maquina virtual con CachyOS/Arch.

## Estructura

```text
simple-edition/
  simple.sh
  lib/
  modules/
  profiles/
  backups/
  exports/
  logs/
```

## Perfiles

- `cachyos-hyprland`: perfil principal recomendado.
- `arch-hyprland`: perfil compatible para Arch puro.

## Exportar

La opcion `Exportar sistema actual` genera un archivo `.tar.gz` con listas de paquetes y configuraciones conocidas para reconstruir el sistema mas adelante.

## Primera prueba

La guia para probarlo en una maquina virtual esta en `docs/first-vm-test.md`.

## Modulos iniciales

- `base`: herramientas esenciales del sistema.
- `aur`: instala `yay` si no existe.
- `audio`: PipeWire, WirePlumber y control de volumen.
- `bluetooth`: BlueZ y Blueman.
- `drivers`: firmware, microcode y soporte grafico base.
- `git`: Git, GitHub CLI y LazyGit.
- `login-sddm`: login manager SDDM con tema Simple Future.
- `apps`: navegador, editor, multimedia, archivos y utilidades de terminal.
- `terminal`: Kitty, Zsh, Starship y Fastfetch.
- `theme-simple-future`: tema futurista sobrio para Kitty, Waybar, Rofi y SwayNC.
- `hyprland`: compositor, atajos, autostart y configuracion visual base.

## Enfoque

La base principal sera CachyOS, pero el instalador se mantiene compatible con Arch puro siempre que sea razonable.
