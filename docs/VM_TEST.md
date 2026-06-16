# Guia de prueba en VM

Esta es la primera ruta de prueba real para `hypr_edition`.

Descarga CachyOS desde la pagina oficial:

```text
https://cachyos.org/download
```

Usa la ISO Desktop Edition para VMware.

## Ajustes recomendados

- 2 nucleos de CPU como minimo
- 4 GB de RAM como minimo, 8 GB recomendado
- 40 GB de disco como minimo
- UEFI activado
- aceleracion 3D activada si VMware la ofrece
- red activada durante la instalacion

## Instalar CachyOS

Durante la instalacion de CachyOS, elige primero un escritorio normal. KDE Plasma es una opcion comoda para la primera prueba porque el instalador y las herramientas del sistema son faciles de revisar.

No hace falta elegir Hyprland durante la instalacion de CachyOS todavia. El objetivo de esta primera prueba es validar nuestro instalador sobre una base CachyOS funcional.

## Preparar la VM

Despues del primer arranque:

```bash
sudo pacman -Syu
sudo pacman -S --needed git bash
```

Si el repo es privado, sigue:

```text
docs/PRIVATE_REPO_SSH.md
```

## Clonar y probar

```bash
git clone git@github.com:TU_USUARIO/hypr_edition.git
cd hypr_edition
bash scripts/validate.sh
bash scripts/preflight.sh
chmod +x install.sh
./install.sh --dry-run
```

Reemplaza `TU_USUARIO` con tu usuario u organizacion de GitHub.

## Orden de primera prueba

Empieza con la opcion `4` para crear un backup, luego usa la opcion `2` para instalar los paquetes base de Hyprland.

Usa la opcion `5` para revisar que el instalador detecte bien el sistema, `pacman`, `systemd`, helper AUR y GPU.

Si eso funciona, ejecuta la opcion `3` para copiar los dotfiles.

Usa la opcion `1` solo despues de que los pasos pequenos funcionen.

Despues de revisar el resultado en dry-run, ejecuta el instalador real:

```bash
./install.sh
```

## Que anotar

- version de la ISO de CachyOS
- ajustes de la VM
- opcion de instalacion seleccionada
- paquetes faltantes reportados por el instalador
- alternativas de paquetes elegidas, por ejemplo `rofi-wayland|rofi`
- sesion seleccionada en SDDM, por ejemplo `hypr_edition`
- comando que fallo, si alguno falla
- ultimas 20 lineas de la terminal cuando algo falle
