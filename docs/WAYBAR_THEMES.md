# Modelos de Waybar

`hypr_edition` incluye tres barras completas:

- **Horizon Pro:** sobria, compacta y enfocada en productividad.
- **Aero Glass:** modulos flotantes con transparencia y apariencia moderna.
- **Command Center:** telemetria visible y acceso al panel lateral de controles.

Pulsa `SUPER + SHIFT + B` o el icono de paleta para pasar al siguiente modelo. La seleccion se aplica al instante y se conserva despues de reiniciar.

## Centro de control

Pulsa `SUPER + N`, el reloj o el icono de notificaciones para abrir el panel lateral. Incluye:

- controles multimedia
- volumen por aplicacion
- brillo cuando el equipo expone un dispositivo compatible
- Wi-Fi y Bluetooth
- modo no molestar
- notificaciones agrupadas
- bloqueo y menu de energia

Las consultas de Wi-Fi, Bluetooth y brillo tienen un limite de tiempo para que el panel nunca se bloquee si una VM no expone ese hardware.

## Indicadores temporales

SwayOSD muestra un indicador flotante al cambiar volumen o brillo y desaparece automaticamente. Funcionan las teclas multimedia y la rueda del mouse sobre los modulos de Waybar.

El control de brillo solo aparece cuando Linux detecta un dispositivo compatible en `brightnessctl`. VMware normalmente presenta red Ethernet y no expone brillo, Wi-Fi ni Bluetooth reales; esos controles se activan automaticamente en hardware fisico compatible.

El clic derecho sobre el icono de notificaciones cambia el modo no molestar. El boton de energia abre en Command Center cuatro acciones grandes: bloquear, suspender, reiniciar y apagar. Tambien puede abrirse con `SUPER + SHIFT + Q`.

## Cambio desde terminal

```bash
hypr-edition-waybar-theme horizon-pro
hypr-edition-waybar-theme aero-glass
hypr-edition-waybar-theme command-center
```
