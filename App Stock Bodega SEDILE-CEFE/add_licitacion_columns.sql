-- Agregar las nuevas columnas para Licitación/Contrato y Ubicación

ALTER TABLE public.stock_sedile 
ADD COLUMN IF NOT EXISTS licitacion_contrato TEXT,
ADD COLUMN IF NOT EXISTS ubicacion TEXT;

-- Opcional: Agregar comentarios a las columnas
COMMENT ON COLUMN public.stock_sedile.licitacion_contrato IS 'Licitación o Contrato asociado al producto';
COMMENT ON COLUMN public.stock_sedile.ubicacion IS 'Ubicación física en bodega o estante';
