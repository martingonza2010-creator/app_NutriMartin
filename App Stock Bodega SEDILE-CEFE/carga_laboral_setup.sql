-- Script de Base de Datos para Estudio de Carga Laboral SEDILE-CEFE
-- Ejecute este script en el editor SQL de Supabase (SQL Editor) para habilitar la persistencia en tiempo real en la nube.

-- 1. Crear la tabla de carga laboral
CREATE TABLE IF NOT EXISTS public.carga_laboral_sedile (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    fecha date NOT NULL DEFAULT CURRENT_DATE,
    turno text NOT NULL CHECK (turno IN ('Día', 'Noche')),
    area text NOT NULL, -- 'Neonatología', 'Pediatría', 'Preparación Fórmulas Lácteas', 'Preparación Suplementos Adultos', 'Distribución', 'Encargada CEFE'
    categoria text NOT NULL, -- 'Envasado / Preparación', 'Higiene y Preparación', 'Administrativo y Logístico', 'Distribución', 'Interrupciones'
    producto_unidad text NOT NULL, -- 'Vasos', 'Mamaderas', 'Jeringas', 'Botellines de 220 ml', 'Jugos en caja', 'No aplica'
    cantidad integer DEFAULT 0,
    tiempo_total_min integer DEFAULT 0,
    tiempo_extra_min integer DEFAULT 0,
    observaciones text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL
);

-- 2. Habilitar la seguridad a nivel de filas (RLS)
ALTER TABLE public.carga_laboral_sedile ENABLE ROW LEVEL SECURITY;

-- 3. Políticas de seguridad (lectura pública, escritura pública)
DROP POLICY IF EXISTS "Permitir lectura de carga laboral a todo el mundo" ON public.carga_laboral_sedile;
DROP POLICY IF EXISTS "Permitir inserción de carga laboral" ON public.carga_laboral_sedile;
DROP POLICY IF EXISTS "Permitir inserción de carga laboral a autenticados" ON public.carga_laboral_sedile;
DROP POLICY IF EXISTS "Permitir actualización de carga laboral" ON public.carga_laboral_sedile;
DROP POLICY IF EXISTS "Permitir actualización de carga laboral a autenticados" ON public.carga_laboral_sedile;
DROP POLICY IF EXISTS "Permitir eliminación de carga laboral" ON public.carga_laboral_sedile;
DROP POLICY IF EXISTS "Permitir eliminación de carga laboral a autenticados" ON public.carga_laboral_sedile;

CREATE POLICY "Permitir lectura de carga laboral a todo el mundo" 
ON public.carga_laboral_sedile FOR SELECT USING (true);

CREATE POLICY "Permitir inserción de carga laboral" 
ON public.carga_laboral_sedile FOR INSERT WITH CHECK (true);

CREATE POLICY "Permitir actualización de carga laboral" 
ON public.carga_laboral_sedile FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "Permitir eliminación de carga laboral" 
ON public.carga_laboral_sedile FOR DELETE USING (true);

-- 4. Habilitar Supabase Realtime para la tabla carga_laboral_sedile
-- (Nota: Omitido/comentado porque en su base de datos "supabase_realtime" está definida para todas las tablas por defecto)
-- ALTER publication supabase_realtime ADD TABLE public.carga_laboral_sedile;

-- 5. Trigger para actualizar automáticamente la columna 'updated_at'
CREATE OR REPLACE TRIGGER trigger_carga_laboral_updated_at
    BEFORE UPDATE ON public.carga_laboral_sedile
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- Comentario informativo
COMMENT ON TABLE public.carga_laboral_sedile IS 'Registro de tiempos y movimientos para el estudio de carga laboral de SEDILE-CEFE';
