import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = "https://muthgtxtuubcwkzjkptb.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im11dGhndHh0dXViY3dremprcHRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMzIzMTcsImV4cCI6MjA4MDkwODMxN30.uUdLWBSXK6WUrulUadBXcnhlhq2C9VGvDjaO5ogHcFE";

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

const updates = [
  // List 1
  { nombre: "Abintra", ubicacion: "Bodega B 3er piso" },
  { nombre: "Aceite MCT", ubicacion: "Bodega B 3er piso" },
  { nombre: "Aceite vegetal", ubicacion: "Bodega B 3er piso" },
  { nombre: "Adaptador enfit", ubicacion: "Bodega C 8vo piso" },
  { nombre: "Agua Mineral", ubicacion: "Bodega A 3er piso" },
  { nombre: "Alfamino", ubicacion: "Bodega B 3er piso" },
  { nombre: "Alprem", ubicacion: "Bodega B 3er piso" },
  { nombre: "Ascenda", ubicacion: "Bodega B 3er piso" },
  { nombre: "Avena", ubicacion: "Bodega B 3er piso" },
  { nombre: "Azúcar", ubicacion: "Bodega B 3er piso" },
  { nombre: "Bajada Amika", ubicacion: "Bodega C 8vo piso" },
  { nombre: "Bolsa hidratación", ubicacion: "Bodega B 3er piso" },
  { nombre: "Chuño", ubicacion: "Bodega B 3er piso" },
  { nombre: "Colado manzana", ubicacion: "Bodega B 3er piso" },
  { nombre: "Ensure Clinical", ubicacion: "Bodega B 3er piso" },
  { nombre: "Ensure Compact", ubicacion: "Bodega B 3er piso" },
  { nombre: "Ensure polvo", ubicacion: "Bodega A 3er piso" },
  { nombre: "Espesante", ubicacion: "Bodega B 3er piso" },
  { nombre: "Formula infantil sin lactosa", ubicacion: "Bodega A 3er piso" },
  { nombre: "Fortificante Materno", ubicacion: "Bodega B 3er piso" },
  { nombre: "Glucerna Triple Care Liquido", ubicacion: "Bodega B 3er piso" },
  { nombre: "Glutapak-R", ubicacion: "Bodega B 3er piso" },
  { nombre: "Jugos (DONACION)", ubicacion: "Bodega B 3er piso" },
  { nombre: "Lecha Althera", ubicacion: "Bodega B 3er piso" },
  { nombre: "Leche 12% MG", ubicacion: "Bodega B 3er piso" },
  { nombre: "Leche 26% MG", ubicacion: "Bodega B 3er piso" },
  { nombre: "Leche Nido etapa +1", ubicacion: "Bodega A 3er piso" },
  { nombre: "Monogen", ubicacion: "Bodega A 3er piso" },
  { nombre: "Nan  optipro liquida", ubicacion: "Bodega A 3er piso" },
  { nombre: "Nan expert pro comfort", ubicacion: "Bodega A 3er piso" },
  { nombre: "Nan I", ubicacion: "Bodega A 3er piso" },
  { nombre: "Nan prematuro", ubicacion: "Bodega A 3er piso" },
  { nombre: "Nat 100 fibra", ubicacion: "Bodega A 3er piso" },
  { nombre: "Neocate", ubicacion: "Bodega B 3er piso" },
  { nombre: "Nessucar", ubicacion: "Bodega A 3er piso" },
  { nombre: "Nutrilon Pepti Junior", ubicacion: "Bodega B 3er piso" },
  { nombre: "Pediasure Drink sabor vainilla", ubicacion: "Bodega B 3er piso" },
  { nombre: "Pediasure polvo", ubicacion: "Bodega A 3er piso" },
  { nombre: "Proteinex", ubicacion: "Bodega B 3er piso" },
  { nombre: "Similac Neosure", ubicacion: "Bodega A 3er piso" },
  { nombre: "Similac Rice (DONACION)", ubicacion: "Bodega A 3er piso" },
  { nombre: "Similac special Care liquido", ubicacion: "Bodega B 3er piso" },
  { nombre: "Supportan Drink", ubicacion: "Bodega B 3er piso" },
  { nombre: "Vasos 10 oz", ubicacion: "Bodega A 3er piso" },
  { nombre: "Vasos 12 oz", ubicacion: "Bodega A 3er piso" },
  { nombre: "Vasos 8 oz", ubicacion: "Bodega A 3er piso" },
  { nombre: "Vivalite gold (Fomula para Diabeticos)", ubicacion: "Bodega B 3er piso" },
  { nombre: "Vivalite UP con HMB y FOS", ubicacion: "Bodega B 3er piso" },
  { nombre: "Vivalite Whey Protein", ubicacion: "Bodega A 3er piso" },

  // List 2
  { nombre: "Diben 1,5 500 ML", ubicacion: "Bodega C 8vo piso" },
  { nombre: "Ensure Clinical RTH", ubicacion: "Bodega C 8vo piso" },
  { nombre: "Frebini original", ubicacion: "Bodega C 8vo piso" },
  { nombre: "Fresubin 2 Kcal", ubicacion: "Bodega C 8vo piso" },
  { nombre: "Fresubin Intensive", ubicacion: "Bodega C 8vo piso" },
  { nombre: "Glucerna 1.5", ubicacion: "Bodega C 8vo piso" },
  { nombre: "Jevity", ubicacion: "Bodega C 8vo piso" },
  { nombre: "Osmolite", ubicacion: "Bodega C 8vo piso" }
];

async function run() {
  console.log("Fetching current products...");
  const { data: products, error } = await supabase.from('stock_sedile').select('id, nombre');
  
  if (error) {
    console.error("Error fetching products:", error);
    return;
  }
  
  console.log(`Found ${products.length} products. Updating ubicaciones...`);
  
  for (const update of updates) {
    let product = products.find(p => p.nombre.trim().toLowerCase() === update.nombre.trim().toLowerCase());
    
    if (!product) {
      product = products.find(p => p.nombre.trim().toLowerCase().includes(update.nombre.trim().toLowerCase()));
    }
    
    if (product) {
      const { error: updateError } = await supabase
        .from('stock_sedile')
        .update({ ubicacion: update.ubicacion })
        .eq('id', product.id);
        
      if (updateError) {
        console.error(`Error updating ${product.nombre}:`, updateError);
      } else {
        console.log(`Updated ${product.nombre} -> ${update.ubicacion}`);
      }
    } else {
      console.log(`Product not found in DB: ${update.nombre}`);
    }
  }
  
  console.log("Done updating ubicaciones!");
}

run();
