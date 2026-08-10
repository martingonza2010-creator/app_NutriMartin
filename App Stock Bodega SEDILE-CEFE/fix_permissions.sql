-- Corrección de Permisos para Modo "Sin Login" (Anon)
-- Como la app usa un PIN interno y no el login de Supabase, 
-- necesitamos permitir que la llave 'anon' pueda escribir en la base de datos.

-- 1. Eliminar políticas restrictivas anteriores
DROP POLICY IF EXISTS "Permitir inserción a usuarios autenticados" ON public.stock_sedile;
DROP POLICY IF EXISTS "Permitir actualización a usuarios autenticados" ON public.stock_sedile;
DROP POLICY IF EXISTS "Permitir eliminación a usuarios autenticados" ON public.stock_sedile;

-- 2. Crear políticas permisivas para que la app (anon) pueda funcionar
CREATE POLICY "Permitir inserción" ON public.stock_sedile FOR INSERT WITH CHECK (true);
CREATE POLICY "Permitir actualización" ON public.stock_sedile FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Permitir eliminación" ON public.stock_sedile FOR DELETE USING (true);
