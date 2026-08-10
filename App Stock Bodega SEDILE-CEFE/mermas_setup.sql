-- Script de Base de Datos para Registro de Mermas SEDILE-CEFE
-- Ejecute este script en el editor SQL de Supabase (SQL Editor) para habilitar la persistencia en tiempo real en la nube.

-- 1. Crear la tabla de mermas
CREATE TABLE IF NOT EXISTS public.mermas_sedile (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    fecha date NOT NULL DEFAULT CURRENT_DATE,
    seccion text NOT NULL CHECK (seccion IN ('Enterales', 'Pediatría', 'Neonatología')),
    motivo text NOT NULL CHECK (motivo IN ('Acumulación', 'Alta informada', 'Alta no informada', 'Deceso', 'Devolución para reutilizar', 'Rechazo de suplemento')),
    producto_unidad text NOT NULL,
    cantidad integer NOT NULL CHECK (cantidad > 0),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL
);

-- 2. Habilitar la seguridad a nivel de filas (RLS)
ALTER TABLE public.mermas_sedile ENABLE ROW LEVEL SECURITY;

-- 3. Políticas de seguridad (lectura pública, escritura pública)
DROP POLICY IF EXISTS "Permitir lectura de mermas a todo el mundo" ON public.mermas_sedile;
DROP POLICY IF EXISTS "Permitir inserción de mermas" ON public.mermas_sedile;
DROP POLICY IF EXISTS "Permitir inserción de mermas a autenticados" ON public.mermas_sedile;
DROP POLICY IF EXISTS "Permitir actualización de mermas" ON public.mermas_sedile;
DROP POLICY IF EXISTS "Permitir actualización de mermas a autenticados" ON public.mermas_sedile;
DROP POLICY IF EXISTS "Permitir eliminación de mermas" ON public.mermas_sedile;
DROP POLICY IF EXISTS "Permitir eliminación de mermas a autenticados" ON public.mermas_sedile;

CREATE POLICY "Permitir lectura de mermas a todo el mundo" 
ON public.mermas_sedile FOR SELECT USING (true);

CREATE POLICY "Permitir inserción de mermas" 
ON public.mermas_sedile FOR INSERT WITH CHECK (true);

CREATE POLICY "Permitir actualización de mermas" 
ON public.mermas_sedile FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "Permitir eliminación de mermas" 
ON public.mermas_sedile FOR DELETE USING (true);

-- 4. Habilitar Supabase Realtime (si no está activa a nivel global)
-- (Nota: Omitido/comentado porque en su base de datos "supabase_realtime" suele estar definida para todas las tablas por defecto)
-- ALTER publication supabase_realtime ADD TABLE public.mermas_sedile;

-- 5. Trigger para actualizar automáticamente la columna 'updated_at'
CREATE OR REPLACE TRIGGER trigger_mermas_updated_at
    BEFORE UPDATE ON public.mermas_sedile
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- Comentario informativo
COMMENT ON TABLE public.mermas_sedile IS 'Registro de mermas y desperdicios de nutrición para el estudio administrativo de SEDILE-CEFE';
