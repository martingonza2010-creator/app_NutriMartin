-- 1. Tablas de Exámenes Biocalimáticos (Historial)
CREATE TABLE IF NOT EXISTS biochemical_exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    date TEXT NOT NULL,
    creatinine FLOAT,
    urea FLOAT,
    got_ast FLOAT,
    gpt_alt FLOAT,
    glucose FLOAT,
    hba1c FLOAT,
    cholesterol_total FLOAT,
    ldl FLOAT,
    hdl FLOAT,
    triglycerides FLOAT,
    is_altered BOOLEAN DEFAULT false,
    other_exams TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 2. Biblioteca de Planes Alimentarios
CREATE TABLE IF NOT EXISTS meal_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    plan JSONB NOT NULL,
    plan_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 3. Asegurar columnas de Perfil (Auditoría)
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS last_log_date TEXT,
ADD COLUMN IF NOT EXISTS target_calories INTEGER DEFAULT 2000,
ADD COLUMN IF NOT EXISTS current_calories INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS current_water INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS current_protein FLOAT DEFAULT 0,
ADD COLUMN IF NOT EXISTS current_carbs FLOAT DEFAULT 0,
ADD COLUMN IF NOT EXISTS current_fat_diet FLOAT DEFAULT 0,
ADD COLUMN IF NOT EXISTS last_meal_name TEXT,
ADD COLUMN IF NOT EXISTS last_meal_time TEXT,
ADD COLUMN IF NOT EXISTS latest_exams JSONB,
ADD COLUMN IF NOT EXISTS clinical_notes TEXT;

-- Habilitar RLS (Seguridad)
ALTER TABLE biochemical_exams ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_plans ENABLE ROW LEVEL SECURITY;

-- Políticas para biochemical_exams
CREATE POLICY "Usuarios pueden ver sus propios exámenes" ON biochemical_exams
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Usuarios pueden insertar sus propios exámenes" ON biochemical_exams
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Políticas para meal_plans
CREATE POLICY "Usuarios pueden ver sus propios planes" ON meal_plans
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Usuarios pueden insertar sus propios planes" ON meal_plans
    FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Usuarios pueden borrar sus propios planes" ON meal_plans
    FOR DELETE USING (auth.uid() = user_id);
