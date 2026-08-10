-- Script de Migración SQL para Rediseño de Carga Laboral SEDILE-CEFE
-- Ejecute este script en el editor SQL de Supabase (SQL Editor) para habilitar el registro consolidado por turno.

-- Agregar columnas para el registro consolidado por turno
ALTER TABLE public.carga_laboral_sedile
ADD COLUMN IF NOT EXISTS is_consolidado boolean DEFAULT true,
ADD COLUMN IF NOT EXISTS dotacion_teorica integer DEFAULT 10,
ADD COLUMN IF NOT EXISTS dotacion_real integer DEFAULT 10,
ADD COLUMN IF NOT EXISTS motivos_ausencia text[] DEFAULT '{}'::text[],
ADD COLUMN IF NOT EXISTS litros_lacteos numeric DEFAULT 0,
ADD COLUMN IF NOT EXISTS litros_enterales numeric DEFAULT 0,
ADD COLUMN IF NOT EXISTS pacientes_atendidos integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS productos_entregados integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS incidentes_detectados text[] DEFAULT '{}'::text[];

-- Comentarios explicativos para cada columna
COMMENT ON COLUMN public.carga_laboral_sedile.is_consolidado IS 'Indica si es un registro de turno consolidado (nuevo formato) o registro por lote antiguo';
COMMENT ON COLUMN public.carga_laboral_sedile.dotacion_teorica IS 'Dotación nominal programada para el turno (por defecto 10)';
COMMENT ON COLUMN public.carga_laboral_sedile.dotacion_real IS 'Número de técnicos/auxiliares efectivamente presentes en el turno';
COMMENT ON COLUMN public.carga_laboral_sedile.motivos_ausencia IS 'Lista de motivos de ausencias registrados (ej. Licencia médica, Vacaciones)';
COMMENT ON COLUMN public.carga_laboral_sedile.litros_lacteos IS 'Cantidad total en litros de fórmulas lácteas preparadas en el turno';
COMMENT ON COLUMN public.carga_laboral_sedile.litros_enterales IS 'Cantidad total en litros de soporte enteral/soporte adultos preparado';
COMMENT ON COLUMN public.carga_laboral_sedile.pacientes_atendidos IS 'Volumen total de pacientes atendidos/visitados en el turno';
COMMENT ON COLUMN public.carga_laboral_sedile.productos_entregados IS 'Volumen total de productos de nutrición entregados en el turno';
COMMENT ON COLUMN public.carga_laboral_sedile.incidentes_detectados IS 'Lista de incidentes/cuellos de botella registrados (ej. Altas no informadas)';
