-- Migration V8 (Corregido): Crear tabla para Pautas Nutricionales (Meal Plans) con manejo de errores

-- 1. Crear tabla si no existe
CREATE TABLE IF NOT EXISTS meal_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    plan JSONB NOT NULL,
    plan_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 2. Habilitar seguridad (RLS) - Idempotente
ALTER TABLE meal_plans ENABLE ROW LEVEL SECURITY;

-- 3. Eliminar políticas antiguas para evitar errores de "already exists"
DROP POLICY IF EXISTS "Usuarios pueden ver sus propios planes" ON meal_plans;
DROP POLICY IF EXISTS "Usuarios pueden insertar sus propios planes" ON meal_plans;
DROP POLICY IF EXISTS "Usuarios pueden borrar sus propios planes" ON meal_plans;

-- 4. Crear políticas con sintaxis mejorada (SELECT auth.uid())
CREATE POLICY "Usuarios pueden ver sus propios planes" ON meal_plans
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden insertar sus propios planes" ON meal_plans
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuarios pueden borrar sus propios planes" ON meal_plans
    FOR DELETE USING (auth.uid() = user_id);
