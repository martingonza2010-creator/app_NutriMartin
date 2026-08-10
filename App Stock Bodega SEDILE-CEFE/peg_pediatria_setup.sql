-- Script de Base de Datos para Control de Entrega de PEG - Pediatría
-- Ejecute este script en el editor SQL de Supabase (SQL Editor) para habilitar la persistencia en la nube y sincronización entre computadores.

-- 1. Crear la tabla de PEG Pediatría
CREATE TABLE IF NOT EXISTS public.peg_pediatria (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    paciente_cama text NOT NULL,
    cantidad_entregada numeric NOT NULL CHECK (cantidad_entregada >= 0),
    dosis_gramos_dia numeric NOT NULL CHECK (dosis_gramos_dia >= 0),
    dosis_inicio_gramos numeric NOT NULL CHECK (dosis_inicio_gramos >= 0),
    fecha_entrega text NOT NULL,
    fecha_inicio_uso text NOT NULL,
    status text NOT NULL DEFAULT 'active',
    servicio text NOT NULL,
    leftover_sobres numeric,
    discharge_date text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Habilitar la seguridad a nivel de filas (RLS)
ALTER TABLE public.peg_pediatria ENABLE ROW LEVEL SECURITY;

-- 3. Políticas de seguridad (lectura, inserción, actualización, eliminación sin restricciones para el personal)
DROP POLICY IF EXISTS "Permitir lectura de PEG a todo el mundo" ON public.peg_pediatria;
DROP POLICY IF EXISTS "Permitir inserción de PEG" ON public.peg_pediatria;
DROP POLICY IF EXISTS "Permitir actualización de PEG" ON public.peg_pediatria;
DROP POLICY IF EXISTS "Permitir eliminación de PEG" ON public.peg_pediatria;

CREATE POLICY "Permitir lectura de PEG a todo el mundo" 
ON public.peg_pediatria FOR SELECT USING (true);

CREATE POLICY "Permitir inserción de PEG" 
ON public.peg_pediatria FOR INSERT WITH CHECK (true);

CREATE POLICY "Permitir actualización de PEG" 
ON public.peg_pediatria FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "Permitir eliminación de PEG" 
ON public.peg_pediatria FOR DELETE USING (true);

-- 4. Comentario informativo
COMMENT ON TABLE public.peg_pediatria IS 'Tabla para control y seguimiento de sobres y tomas de PEG Pediatría';
