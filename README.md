# hypr_edition

Instalador post-instalacion para dejar Hyprland configurado en CachyOS y Arch Linux.

La primera meta del proyecto es funcionar bien sobre CachyOS, porque ya trae una base moderna y comoda. El instalador tambien detecta Arch Linux para instalar dependencias extra cuando la base es mas minima.

## Estado actual

Version inicial en desarrollo.

Incluye:

- Deteccion de CachyOS y Arch/Arch-based.
- Menu de instalacion.
- Listas de paquetes separadas por sistema.
- Omision segura de paquetes que no existan en los repositorios activos.
- Backup automatico de configuraciones existentes.
- Configuracion inicial de Hyprland, Waybar, Kitty y Rofi.

## Uso

En CachyOS o Arch Linux:

```bash
git clone https://github.com/tu-usuario/hypr_edition.git
cd hypr_edition
chmod +x install.sh
./install.sh
```

No ejecutes el instalador como root. El script pedira `sudo` cuando necesite instalar paquetes o activar servicios.

## Estructura

```text
install.sh          Entrada principal del instalador
lib/                Funciones del instalador
packages/           Listas de paquetes
config/             Dotfiles que se copian a ~/.config
docs/ROADMAP.md     Proximos pasos del proyecto
```

## Seguridad

Antes de copiar configuraciones, el instalador crea backups en:

```text
~/.local/share/hypr_edition/backups/
```
