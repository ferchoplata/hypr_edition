# Repo privado por SSH

Usa esta guia cuando el repo sea privado y la VM necesite clonarlo directo desde GitHub.

## 1. Crear una llave dentro de la VM

```bash
ssh-keygen -t ed25519 -C "hypr-edition-vm"
```

Presiona Enter para aceptar la ruta por defecto.

## 2. Mostrar la llave publica

```bash
cat ~/.ssh/id_ed25519.pub
```

Copia toda la salida.

## 3. Agregarla a GitHub

Abre GitHub en el navegador:

```text
Settings > SSH and GPG keys > New SSH key
```

Usa un titulo como:

```text
hypr-edition-vm
```

Pega la llave publica y guarda.

## 4. Probar la conexion

```bash
ssh -T git@github.com
```

La primera vez, acepta el fingerprint del host.

## 5. Clonar el repo privado

```bash
git clone git@github.com:TU_USUARIO/hypr_edition.git
cd hypr_edition
```

Reemplaza `TU_USUARIO` con tu usuario u organizacion de GitHub.
