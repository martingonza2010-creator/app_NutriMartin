-- ==========================================
-- SCRIPT DE CONFIGURACIÓN SUPABASE - NUTRIMARTIN
-- Autor: NutriMartin Dev
-- ==========================================

-- 1. Habilitar extensiones necesarias
create extension if not exists "uuid-ossp";

-- ==========================================
-- TABLA: PROFILES (Perfiles de Usuarios)
-- ==========================================
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  email text,
  display_name text,
  photo_url text,
  role text default 'user', -- 'admin' o 'user'
  
  -- Datos Antropométricos y Metas
  current_weight numeric,
  current_height numeric,
  current_waist numeric,
  current_fat numeric,
  current_muscle numeric,
  target_calories numeric default 2000,
  
  -- Resumen Diario (Caché para Admin Dashboard)
  last_log_date date,
  current_calories numeric default 0,
  current_water numeric default 0,
  current_protein numeric default 0,
  current_carbs numeric default 0,
  current_fat_diet numeric default 0, -- Grasa de la dieta, distinto a grasa corporal
  
  -- Datos Clínicos
  clinical_notes text,
  latest_exams jsonb, -- Guardamos el último examen completo aquí para acceso rápido
  
  updated_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Habilitar RLS
alter table public.profiles enable row level security;

-- POLÍTICAS DE SEGURIDAD (RLS) PARA PROFILES

-- 1. Lectura:
--    - El usuario puede ver su propio perfil.
--    - El ADMIN (email específico) puede ver TODOS los perfiles.
create policy "Usuarios ven su propio perfil" 
on public.profiles for select 
using ( auth.uid() = id );

create policy "Admin ve todos los perfiles" 
on public.profiles for select 
using ( auth.jwt() ->> 'email' = 'martingonza2010@gmail.com' );

-- 2. Escritura (Insert/Update):
--    - El usuario puede editar su propio perfil.
create policy "Usuarios editan su propio perfil" 
on public.profiles for insert 
with check ( auth.uid() = id );

create policy "Usuarios actualizan su propio perfil" 
on public.profiles for update 
using ( auth.uid() = id );

--    - El Admin puede actualizar notas clínicas de cualquiera.
create policy "Admin actualiza notas clínicas" 
on public.profiles for update 
using ( auth.jwt() ->> 'email' = 'martingonza2010@gmail.com' );


-- ==========================================
-- TABLA: DAILY_LOGS (Registros Diarios)
-- ==========================================
create table if not exists public.daily_logs (
  id text primary key, -- Formato: UID_YYYY-MM-DD
  user_id uuid references auth.users not null,
  date date not null,
  
  items jsonb default '[]'::jsonb, -- Array de alimentos
  
  water_glasses numeric default 0,
  water_intake numeric default 0,
  
  urine_color numeric,
  bristol_score numeric,
  
  weight numeric, -- Registro histórico de peso ese día
  fat_percent numeric,
  muscle_percent numeric,
  
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Habilitar RLS
alter table public.daily_logs enable row level security;

-- POLÍTICAS DE SEGURIDAD (RLS) PARA DAILY_LOGS

-- 1. Lectura:
--    - Usuario ve sus logs.
--    - Admin ve logs de todos (para gráficos de progreso).
create policy "Usuarios ven sus logs" 
on public.daily_logs for select 
using ( auth.uid() = user_id );

create policy "Admin ve todos los logs" 
on public.daily_logs for select 
using ( auth.jwt() ->> 'email' = 'martingonza2010@gmail.com' );

-- 2. Escritura:
--    - Usuario crea/edita sus propios logs.
create policy "Usuarios gestionan sus logs" 
on public.daily_logs for all 
using ( auth.uid() = user_id );


-- ==========================================
-- TABLA: MEAL_PLANS (Pautas Nutricionales)
-- ==========================================
create table if not exists public.meal_plans (
  id text primary key,
  user_id uuid references auth.users not null,
  plan jsonb not null, -- Estructura completa de la pauta
  created_at timestamp with time zone default timezone('utc'::text, now())
);

alter table public.meal_plans enable row level security;

create policy "Usuarios ven sus pautas" 
on public.meal_plans for select 
using ( auth.uid() = user_id );

-- Admin puede crear pautas para usuarios (Futura implementación)
create policy "Admin gestiona pautas" 
on public.meal_plans for all 
using ( auth.jwt() ->> 'email' = 'martingonza2010@gmail.com' );


-- ==========================================
-- TABLA: BIOCHEMICAL_EXAMS (Exámenes)
-- ==========================================
create table if not exists public.biochemical_exams (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  date date not null,
  
  creatinine numeric,
  urea numeric,
  got_ast numeric,
  gpt_alt numeric,
  glucose numeric,
  hba1c numeric,
  cholesterol_total numeric,
  ldl numeric,
  hdl numeric,
  triglycerides numeric,
  
  is_altered boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

alter table public.biochemical_exams enable row level security;

create policy "Usuarios ven sus examenes" 
on public.biochemical_exams for select 
using ( auth.uid() = user_id );

create policy "Admin ve examenes" 
on public.biochemical_exams for select 
using ( auth.jwt() ->> 'email' = 'martingonza2010@gmail.com' );

create policy "Usuarios suben examenes" 
on public.biochemical_exams for insert 
with check ( auth.uid() = user_id );


-- ==========================================
-- STORAGE (Para fotos de comidas)
-- ==========================================
-- Nota: Esto usualmente se configura en la UI de Storage, pero aquí simulamos la politica
-- Bucket id: 'meal-photos'

-- Policy para Storage (necesita crearse desde UI o SQL específico de storage)
-- insert into storage.buckets (id, name) values ('meal-photos', 'meal-photos');
-- create policy "Cualquiera puede ver fotos" on storage.objects for select using ( bucket_id = 'meal-photos' );
-- create policy "Usuarios suben fotos propias" on storage.objects for insert with check ( bucket_id = 'meal-photos' and auth.uid() = owner );
