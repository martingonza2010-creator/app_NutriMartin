-- 1. Crear tabla de historial
CREATE TABLE IF NOT EXISTS public.stock_history (
    id UUID DEFAULT extensions.uuid_generate_v4() PRIMARY KEY,
    stock_id UUID REFERENCES public.stock_sedile(id) ON DELETE CASCADE,
    nombre TEXT NOT NULL,
    old_stock NUMERIC,
    new_stock NUMERIC,
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    action TEXT NOT NULL
);

-- 2. Habilitar RLS (Row Level Security) para la tabla de historial
ALTER TABLE public.stock_history ENABLE ROW LEVEL SECURITY;

-- 3. Crear política para permitir la lectura a todos (o solo admin si prefieres)
-- Por ahora la dejamos pública para lectura y que solo el trigger pueda insertar
CREATE POLICY "Permitir lectura pública de historial" 
ON public.stock_history FOR SELECT 
USING (true);

-- 4. Crear la función del trigger
CREATE OR REPLACE FUNCTION public.log_stock_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        -- Solo registramos si el stock_sedile realmente cambió
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
    
    RETURN NULL; -- El trigger AFTER puede devolver NULL
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Crear el trigger en la tabla stock_sedile
DROP TRIGGER IF EXISTS trigger_log_stock_changes ON public.stock_sedile;
CREATE TRIGGER trigger_log_stock_changes
    AFTER INSERT OR UPDATE OR DELETE ON public.stock_sedile
    FOR EACH ROW
    EXECUTE FUNCTION public.log_stock_changes();
