-- =========================================================
-- SCRIPT DE ACTUALIZACIÓN: INBOX DE FEEDBACK CLÍNICO
-- Objetivo: Crear tabla para historial de mensajes del nutri
-- =========================================================

CREATE TABLE IF NOT EXISTS public.clinical_feedback (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    message text NOT NULL,
    is_dismissed boolean DEFAULT false,
    created_at timestamptz DEFAULT now()
);

-- Habilitar RLS
ALTER TABLE public.clinical_feedback ENABLE ROW LEVEL SECURITY;

-- Políticas de Seguridad
CREATE POLICY "Usuarios pueden ver su propio feedback" 
ON public.clinical_feedback FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Nutri (Admin) puede insertar feedback" 
ON public.clinical_feedback FOR INSERT 
WITH CHECK (true); -- La validación de Admin se hace a nivel de App

CREATE POLICY "Usuarios pueden marcar su feedback como leído" 
ON public.clinical_feedback FOR UPDATE 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Notificar recarga de configuración
NOTIFY pgrst, 'reload config';
