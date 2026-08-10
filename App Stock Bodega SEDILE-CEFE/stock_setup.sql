-- Script de Base de Datos para STOCK SEDILE 2026
-- Ejecute este script en el editor SQL de Supabase (SQL Editor) para habilitar la persistencia en tiempo real en la nube.

-- 1. Crear la tabla de stock
CREATE TABLE IF NOT EXISTS public.stock_sedile (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    codigo text,
    nombre text NOT NULL,
    unidad text,
    stock_sedile numeric DEFAULT 0,
    uso_diario numeric DEFAULT 0,
    stock_total numeric DEFAULT 0,
    categoria text DEFAULT 'Lácteos/Polvos', -- 'Lácteos/Polvos', 'RTH (Enteral)', 'Insumos'
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL
);

-- 2. Habilitar la seguridad a nivel de filas (RLS)
ALTER TABLE public.stock_sedile ENABLE ROW LEVEL SECURITY;

-- 3. Crear políticas para que los usuarios autenticados y no autenticados puedan ver el stock
CREATE POLICY "Permitir lectura a todo el mundo" 
ON public.stock_sedile 
FOR SELECT 
USING (true);

-- Política para inserción (solo usuarios autenticados)
CREATE POLICY "Permitir inserción a usuarios autenticados" 
ON public.stock_sedile 
FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Política para actualización (todos los autenticados para que el admin pueda actualizar)
CREATE POLICY "Permitir actualización a usuarios autenticados" 
ON public.stock_sedile 
FOR UPDATE 
TO authenticated 
USING (true)
WITH CHECK (true);

-- Política para eliminación
CREATE POLICY "Permitir eliminación a usuarios autenticados" 
ON public.stock_sedile 
FOR DELETE 
TO authenticated 
USING (true);

-- 4. Habilitar Supabase Realtime para la tabla stock_sedile
ALTER publication supabase_realtime ADD TABLE public.stock_sedile;

-- 5. Trigger para actualizar automáticamente la columna 'updated_at'
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS trigger AS $$
BEGIN
    new.updated_at = timezone('utc'::text, now());
    return new;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_stock_updated_at
    BEFORE UPDATE ON public.stock_sedile
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- Comentario informativo sobre la tabla
COMMENT ON TABLE public.stock_sedile IS 'Tabla de inventario de bodega de fórmulas y suministros - STOCK SEDILE 2026';
