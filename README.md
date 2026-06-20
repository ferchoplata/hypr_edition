# hypr_edition

`hypr_edition` es un instalador post-instalacion para dejar Hyprland configurado sobre CachyOS o Arch Linux.

La base actual del proyecto es un instalador simple y funcional. La idea modular de una version anterior sigue viva, pero por ahora queda como roadmap y no como interfaz publica del repo. Asi evitamos prometer modulos, perfiles y restauraciones que todavia no existen en el codigo.

## Estado actual

Hoy el proyecto incluye:

- deteccion de CachyOS y Arch/Arch-based
- menu de instalacion interactivo
- listas de paquetes separadas por sistema
- backup de configuraciones existentes
- copia de dotfiles base para Hyprland, Waybar, Kitty y Rofi
- tema sobrio y autosuficiente para Kitty
- renderizado de Kitty por CPU en maquinas virtuales y por GPU en equipos fisicos
- activacion de servicios recomendados cuando existen
- reporte basico del sistema desde el menu

## Uso

Ejecutalo desde una instalacion real de CachyOS o Arch Linux:

```bash
git clone git@github.com:TU_USUARIO/hypr_edition.git
cd hypr_edition
chmod +x install.sh
./install.sh
```

Reemplaza `TU_USUARIO` con tu usuario u organizacion de GitHub.

No lo ejecutes como `root`. El script usa `sudo` cuando necesita instalar paquetes o habilitar servicios.

Si estas trabajando desde Windows, puedes editar aqui y validar Bash desde WSL. La prueba real del instalador conviene hacerla en Arch o CachyOS, idealmente dentro de una VM al principio.

Para preparar esa prueba:

- [docs/VM_TEST.md](docs/VM_TEST.md): guia de prueba en VMware/CachyOS.
- [docs/PRIVATE_REPO_SSH.md](docs/PRIVATE_REPO_SSH.md): clonar un repo privado desde la VM.

Para validar sintaxis antes de probar:

```bash
bash scripts/validate.sh
```

Para revisar paquetes y entorno sin instalar nada:

```bash
bash scripts/preflight.sh
```

Para ensayar el flujo sin aplicar cambios:

```bash
./install.sh --dry-run
```

## Estructura

```text
install.sh          Entrada principal del instalador
lib/                Funciones de deteccion, paquetes, backup y dotfiles
packages/           Listas de paquetes por perfil/base
config/             Dotfiles que se copian a ~/.config
assets/             Recursos del proyecto
scripts/            Herramientas de validacion y mantenimiento
docs/ROADMAP.md     Siguientes fases del instalador
```

## Seguridad

Antes de copiar configuraciones, el instalador crea backups en:

```text
~/.local/share/hypr_edition/backups/
```

Si un paquete no existe en los repositorios activos del sistema, el instalador lo avisa y lo omite para no detener todo el proceso.

## Direccion del proyecto

La meta sigue siendo crecer hacia una version mas modular. Cuando esa capa exista de verdad, la iremos incorporando sobre esta base funcional:

- perfiles instalables
- exportacion del sistema actual
- restauracion de backups
- soporte de modulos opcionales
