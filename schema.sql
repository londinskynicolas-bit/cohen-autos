-- ==========================================================
-- COHEN AUTOS — Esquema de base de datos para Supabase
-- Pegá todo este archivo en: Supabase > SQL Editor > New query > Run
-- ==========================================================

-- Tabla de autos
create table if not exists cars (
  id uuid primary key default gen_random_uuid(),
  marca text not null,
  modelo text not null,
  anio int,
  km int default 0,
  precio numeric default 0,
  condicion text default 'usado',      -- 'usado' | 'nuevo'
  transmision text default 'manual',   -- 'manual' | 'automatico'
  color text,
  fotos text[] default '{}',           -- URLs de las fotos subidas a Storage
  descripcion text,
  created_at timestamptz default now()
);

-- Tabla de configuración (por ahora solo el número de WhatsApp)
create table if not exists settings (
  id int primary key default 1,
  whatsapp text default ''
);
insert into settings (id, whatsapp) values (1, '')
on conflict (id) do nothing;

-- Seguridad a nivel de fila (RLS)
alter table cars enable row level security;
alter table settings enable row level security;

-- Lectura pública (para que la página muestre los autos a cualquiera)
drop policy if exists "public read cars" on cars;
create policy "public read cars" on cars for select using (true);

drop policy if exists "public read settings" on settings;
create policy "public read settings" on settings for select using (true);

-- Escritura desde el panel
-- NOTA: por ahora el panel se protege solo con una clave simple del lado del
-- navegador (no es un login real). Estas políticas permiten escribir con la
-- misma clave "anon" que usa la página pública. Es un punto de partida
-- razonable para arrancar; más adelante podemos sumar un login real de
-- Supabase Auth y restringir esto solo a usuarios autenticados.
drop policy if exists "public write cars" on cars;
create policy "public write cars" on cars for insert with check (true);

drop policy if exists "public update cars" on cars;
create policy "public update cars" on cars for update using (true);

drop policy if exists "public delete cars" on cars;
create policy "public delete cars" on cars for delete using (true);

drop policy if exists "public update settings" on settings;
create policy "public update settings" on settings for update using (true);

-- ==========================================================
-- Storage: bucket para las fotos de los autos
-- Hacé esto en Supabase > Storage > New bucket:
--   Nombre: car-photos
--   Public bucket: SÍ (activado)
-- Después volvé acá y corré esto para permitir subir/leer fotos:
-- ==========================================================
insert into storage.buckets (id, name, public)
values ('car-photos', 'car-photos', true)
on conflict (id) do nothing;

drop policy if exists "public read car photos" on storage.objects;
create policy "public read car photos"
on storage.objects for select
using ( bucket_id = 'car-photos' );

drop policy if exists "public upload car photos" on storage.objects;
create policy "public upload car photos"
on storage.objects for insert
with check ( bucket_id = 'car-photos' );

drop policy if exists "public delete car photos" on storage.objects;
create policy "public delete car photos"
on storage.objects for delete
using ( bucket_id = 'car-photos' );
