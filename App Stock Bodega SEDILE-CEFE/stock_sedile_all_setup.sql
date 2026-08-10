-- Script de Base de Datos para STOCK SEDILE 2026 y Registro Histórico

-- ==========================================
-- 1. CREACIÓN DE TABLA PRINCIPAL Y SEGURIDAD
-- ==========================================
CREATE TABLE IF NOT EXISTS public.stock_sedile (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    codigo text,
    nombre text NOT NULL,
    unidad text,
    stock_sedile numeric DEFAULT 0,
    uso_diario numeric DEFAULT 0,
    stock_total numeric DEFAULT 0,
    categoria text DEFAULT 'Lácteos/Polvos',
    oculto boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL
);

-- Asegurar que la columna oculto exista si la tabla ya existía
ALTER TABLE public.stock_sedile ADD COLUMN IF NOT EXISTS oculto boolean DEFAULT false;

-- Habilitar RLS
ALTER TABLE public.stock_sedile ENABLE ROW LEVEL SECURITY;

-- Limpiar políticas anteriores si existían para evitar errores
DROP POLICY IF EXISTS "Permitir lectura a todo el mundo" ON public.stock_sedile;
DROP POLICY IF EXISTS "Permitir inserción a usuarios autenticados" ON public.stock_sedile;
DROP POLICY IF EXISTS "Permitir actualización a usuarios autenticados" ON public.stock_sedile;
DROP POLICY IF EXISTS "Permitir eliminación a usuarios autenticados" ON public.stock_sedile;

-- Políticas de Seguridad
CREATE POLICY "Permitir lectura a todo el mundo" ON public.stock_sedile FOR SELECT USING (true);
CREATE POLICY "Permitir inserción a usuarios autenticados" ON public.stock_sedile FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Permitir actualización a usuarios autenticados" ON public.stock_sedile FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Permitir eliminación a usuarios autenticados" ON public.stock_sedile FOR DELETE TO authenticated USING (true);

-- Habilitar Supabase Realtime
-- (Asumimos que supabase_realtime ya existe. Intentaremos agregarlo de forma segura)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'stock_sedile'
  ) THEN
    -- Try to add, catching error if it's FOR ALL TABLES
    BEGIN
      ALTER PUBLICATION supabase_realtime ADD TABLE public.stock_sedile;
    EXCEPTION WHEN OTHERS THEN
      -- Do nothing, it might be FOR ALL TABLES already
    END;
  END IF;
END
$$;

-- Trigger Updated At
CREATE OR REPLACE FUNCTION public.handle_updated_at() RETURNS trigger AS $$
BEGIN
    new.updated_at = timezone('utc'::text, now());
    return new;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_stock_updated_at ON public.stock_sedile;
CREATE TRIGGER trigger_stock_updated_at
    BEFORE UPDATE ON public.stock_sedile
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ==========================================
-- 2. CREACIÓN DEL HISTORIAL DE MOVIMIENTOS
-- ==========================================

CREATE TABLE IF NOT EXISTS public.stock_history (
    id UUID DEFAULT extensions.uuid_generate_v4() PRIMARY KEY,
    stock_id UUID REFERENCES public.stock_sedile(id) ON DELETE CASCADE,
    nombre TEXT NOT NULL,
    old_stock NUMERIC,
    new_stock NUMERIC,
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    action TEXT NOT NULL
);

ALTER TABLE public.stock_history ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Permitir lectura pública de historial" ON public.stock_history;
CREATE POLICY "Permitir lectura pública de historial" ON public.stock_history FOR SELECT USING (true);

CREATE OR REPLACE FUNCTION public.log_stock_changes() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        IF OLD.stock_sedile IS DISTINCT FROM NEW.stock_sedile THEN
            INSERT INTO public.stock_history (stock_id, nombre, old_stock, new_stock, action)
            VALUES (NEW.id, NEW.nombre, OLD.stock_sedile, NEW.stock_sedile, 'UPDATE');
        END IF;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO public.stock_history (stock_id, nombre, old_stock, new_stock, action)
        VALUES (NEW.id, NEW.nombre, 0, NEW.stock_sedile, 'INSERT');
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO public.stock_history (stock_id, nombre, old_stock, new_stock, action)
        VALUES (OLD.id, OLD.nombre, OLD.stock_sedile, 0, 'DELETE');
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_log_stock_changes ON public.stock_sedile;
CREATE TRIGGER trigger_log_stock_changes
    AFTER INSERT OR UPDATE OR DELETE ON public.stock_sedile
    FOR EACH ROW EXECUTE FUNCTION public.log_stock_changes();
