# Cohen Autos — Guía para poner esto en línea

Tenés 3 carpetas/archivos:
- `schema.sql` → se pega una sola vez en Supabase
- `site/index.html` → la página pública (catálogo)
- `admin/index.html` → el panel de administración

Ambos sitios son independientes: se deployan por separado, en dominios distintos si querés, y los dos hablan con la misma base de datos de Supabase.

## Paso 1 — Crear el proyecto en Supabase
1. Andá a https://supabase.com y creá una cuenta (gratis).
2. Creá un **New project**. Elegí nombre, contraseña de base de datos (guardala) y región (la más cercana a Argentina es `São Paulo`).
3. Esperá 1-2 minutos a que se termine de crear.

## Paso 2 — Cargar el esquema
1. En el menú lateral, entrá a **SQL Editor** → **New query**.
2. Pegá todo el contenido de `schema.sql` y tocá **Run**.
3. Andá a **Storage** y confirmá que se creó el bucket `car-photos` (marcado como público). Si no aparece, creálo a mano: **New bucket** → nombre `car-photos` → activar "Public bucket".

## Paso 3 — Obtener tus claves
1. En el menú lateral: **Project Settings** → **API**.
2. Copiá:
   - **Project URL** (algo como `https://xxxxx.supabase.co`)
   - **anon public key** (una key larga)

## Paso 4 — Completar los archivos
Abrí `site/index.html` y `admin/index.html`, y en ambos reemplazá:
```js
const SUPABASE_URL = "https://TU-PROYECTO.supabase.co";
const SUPABASE_ANON_KEY = "TU-ANON-KEY";
```
con los valores del Paso 3 (van iguales en los dos archivos).

En `admin/index.html` también completá:
```js
const SITE_URL = "https://tu-pagina.netlify.app"; // la URL de tu página pública, una vez que la subas
const ADMIN_PASS = "auto2026"; // cambiala por tu clave
```

## Paso 5 — Subir cada sitio (el método más simple: Netlify Drop)
1. Andá a https://app.netlify.com/drop
2. Arrastrá la carpeta `site` completa → te da una URL pública (ej: `cohen-autos.netlify.app`). Esa es tu página.
3. Repetí el proceso arrastrando la carpeta `admin` → te da otra URL distinta (ej: `cohen-autos-panel.netlify.app`). Ese es tu panel.
4. Volvé a `admin/index.html`, completá `SITE_URL` con la URL real que te dio Netlify para `site`, y volvé a arrastrar la carpeta `admin` para actualizarla.

Con cuenta gratis de Netlify podés después ponerle un dominio propio a cada sitio (por ejemplo `cohenautos.com` a la página y `panel.cohenautos.com` al admin) desde **Site settings > Domain management**.

## Notas importantes
- La clave del panel (`ADMIN_PASS`) es una protección simple, no un login real. Cualquiera que la sepa puede entrar. Sirve para arrancar; si en algún momento querés algo más serio, se puede sumar un login de verdad con Supabase Auth.
- Las fotos se suben directo a Supabase Storage — no hay límite artificial de tu lado, pero Supabase free tier tiene 1GB de almacenamiento incluido.
- Cualquier cambio de diseño o de funcionalidad que hagamos después, se edita en estos mismos archivos y se vuelve a arrastrar a Netlify (o se conecta a GitHub para que se actualice solo — lo vemos cuando quieras dar ese paso).
