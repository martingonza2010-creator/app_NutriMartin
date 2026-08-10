-- 1. Asegurar columna is_hidden
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS is_hidden BOOLEAN DEFAULT FALSE;

-- 2. Índice para rendimiento
CREATE INDEX IF NOT EXISTS idx_profiles_is_hidden ON profiles(is_hidden);

-- 3. IMPORTANTE: Política RLS para permitir que el ADMIN edite
-- Primero, eliminamos políticas viejas que puedan chocar
DROP POLICY IF EXISTS "Nutricionista puede actualizar perfiles" ON profiles;

-- Creamos la política permisiva para el admin (nutricionista)
-- Asumiendo que sabes tu email de admin o tienes una forma de identificarte
-- Esta política permite UPDATE a cualquier usuario autenticado si es el nutricionista
-- OJO: Ajusta el email 'tu_email@admin.com' por el tuyo real si usas email check, 
-- O mejor aún, usamos una política basada en que el usuario autenticado pueda editar si es admin.
-- Como solución rápida y segura para tu caso de uso personal:
CREATE POLICY "Usuarios pueden actualizar su propio perfil y Admin todos"
ON profiles FOR UPDATE
USING (
  auth.uid() = id -- Usuario normal se edita a sí mismo
  OR 
  auth.email() = 'martingonzalez@gmail.com' -- O TU EMAIL DE ADMIN AQUÍ
  OR
  EXISTS ( -- O si tienes una tabla de roles/admins
    SELECT 1 FROM profiles 
    WHERE id = auth.uid() 
    AND email IN ('martingonzalez@gmail.com', 'admin@nutrimartin.cl') -- Lista blanca de admins
  )
);

-- Si prefieres algo más abierto para desarrollo (CUIDADO EN PRODUCCIÓN):
-- CREATE POLICY "Permitir update a autenticados" ON profiles FOR UPDATE USING (auth.role() = 'authenticated');
