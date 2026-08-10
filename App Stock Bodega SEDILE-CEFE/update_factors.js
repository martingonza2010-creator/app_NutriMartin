import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = "https://muthgtxtuubcwkzjkptb.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im11dGhndHh0dXViY3dremprcHRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMzIzMTcsImV4cCI6MjA4MDkwODMxN30.uUdLWBSXK6WUrulUadBXcnhlhq2C9VGvDjaO5ogHcFE";

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

const updates = [
  { nombre: "Abintra", factor_empaque: "CAJA 30 UD" },
  { nombre: "Aceite MCT", factor_empaque: "1 UD" },
  { nombre: "Aceite vegetal", factor_empaque: "1 UD" },
  { nombre: "Adaptador enfit", factor_empaque: "CAJA 30 UD" },
  { nombre: "Agua Mineral", factor_empaque: "DISPLAY 12 UD" },
  { nombre: "Alfamino", factor_empaque: "CAJA 12 UD" },
  { nombre: "Alprem", factor_empaque: "CAJA 32 UD" },
  { nombre: "Ascenda", factor_empaque: "DISPLAY 6 UD" },
  { nombre: "Avena", factor_empaque: "1 UD" },
  { nombre: "Azúcar", factor_empaque: "1 UD" },
  { nombre: "Bajada Amika", factor_empaque: "CAJA 30 UD" },
  { nombre: "Bolsa hidratación", factor_empaque: "CAJA 30 UD" },
  { nombre: "Chuño", factor_empaque: "1 UD" },
  { nombre: "Colado manzana", factor_empaque: "CAJA 12 UD" },
  { nombre: "Ensure Clinical", factor_empaque: "CAJA 30 UD" },
  { nombre: "Ensure Compact", factor_empaque: "CAJA 24 UD" },
  { nombre: "Ensure polvo", factor_empaque: "CAJA 12 UD" },
  { nombre: "Espesante", factor_empaque: "CAJA 6 UD" },
  { nombre: "Formula infantil sin lactosa", factor_empaque: "CAJA 12 UD" },
  { nombre: "Fortificante Materno", factor_empaque: "CAJA 72 UD" },
  { nombre: "Frebini energy drink", factor_empaque: "CAJA 4 UD" },
  { nombre: "Fresubin 2 Kcal crema capuchino", factor_empaque: "CAJA 4 UD" },
  { nombre: "Fresubin Hepa drink", factor_empaque: "CAJA 4 UD" },
  { nombre: "Fresubin renal capuccino", factor_empaque: "CAJA 4 UD" },
  { nombre: "Glucerna Triple Care Liquido", factor_empaque: "DISPLAY 32 UD" },
  { nombre: "Glutapak-R", factor_empaque: "CAJA 50 UD" },
  { nombre: "Hepatic NM", factor_empaque: "CAJA 15 UD" },
  { nombre: "Jugos (DONACION)", factor_empaque: "DISPLAY 6 UD" },
  { nombre: "Leche Althera", factor_empaque: "CAJA 12 UD" },
  { nombre: "Leche 12% MG", factor_empaque: "1 UD" },
  { nombre: "Leche 26% MG", factor_empaque: "1 UD" },
  { nombre: "Leche Nido etapa +1", factor_empaque: "CAJA 6 UD" },
  { nombre: "Monogen", factor_empaque: "CAJA 6 UD" },
  { nombre: "Nan  optipro liquida", factor_empaque: "CAJA 48 UD" },
  { nombre: "Nan 3 L Confortis", factor_empaque: "CAJA 12 UD" },
  { nombre: "Nan expert pro comfort", factor_empaque: "CAJA 12 UD" },
  { nombre: "Nan I", factor_empaque: "CAJA 12 UD" },
  { nombre: "Nan prematuro", factor_empaque: "CAJA 12 UD" },
  { nombre: "Nat 100 fibra", factor_empaque: "CAJA 8 UD" },
  { nombre: "Neocate", factor_empaque: "CAJA 4 UD" },
  { nombre: "Nessucar", factor_empaque: "CAJA 12 UD" },
  { nombre: "Nutrilon Pepti Junior", factor_empaque: "CAJA 24 UD" },
  { nombre: "Pediasure Drink sabor vainilla", factor_empaque: "CAJA 24 UD" },
  { nombre: "Pediasure polvo", factor_empaque: "CAJA 6 UD" },
  { nombre: "Proteinex", factor_empaque: "CAJA 12 UD" },
  { nombre: "similac 1", factor_empaque: "CAJA 12 UD" },
  { nombre: "Similac Neosure", factor_empaque: "CAJA 12 UD" },
  { nombre: "Similac Rice (DONACION)", factor_empaque: "CAJA 6 UD" },
  { nombre: "Similac special Care liquido", factor_empaque: "CAJA 6 UD" },
  { nombre: "Similac total comfort", factor_empaque: "CAJA 12 UD" },
  { nombre: "Supportan Drink", factor_empaque: "CAJA 4 UD" },
  { nombre: "Vasos 10 oz", factor_empaque: "CAJA 1000 UD" },
  { nombre: "Vasos 12 oz", factor_empaque: "CAJA 1000 UD" },
  { nombre: "Vasos 8 oz", factor_empaque: "CAJA 1000 UD" },
  { nombre: "Vivalite gold (Fomula para Diabeticos)", factor_empaque: "CAJA 6 UD" },
  { nombre: "Vivalite UP con HMB y FOS", factor_empaque: "CAJA 6 UD" },
  { nombre: "Vivalite Whey Protein", factor_empaque: "CAJA 6 UD" },
  
  // Image 2 (RTH / Enteral)
  { nombre: "Diben 1,5 500 ML", factor_empaque: "CAJA 15 UD" },
  { nombre: "Diben 1,5 1000 ML", factor_empaque: "CAJA 8 UD" },
  { nombre: "Ensure Clinical RTH", factor_empaque: "CAJA 8 UD" },
  { nombre: "Frebini original", factor_empaque: "CAJA 15 UD" },
  { nombre: "Fresubin 2 Kcal", factor_empaque: "CAJA 15 UD" },
  { nombre: "Fresubin HP ENERGY", factor_empaque: "CAJA 8 UD" },
  { nombre: "Fresubin Intensive", factor_empaque: "CAJA 15 UD" },
  { nombre: "Fresubin Original", factor_empaque: "CAJA 15 UD" },
  { nombre: "Glucerna 1.5", factor_empaque: "CAJA 8 UD" },
  { nombre: "Jevity", factor_empaque: "CAJA 8 UD" },
  { nombre: "Osmolite", factor_empaque: "CAJA 8 UD" },
  { nombre: "SURVIMED", factor_empaque: "CAJA 15 UD" },
  { nombre: "SURVIMED", factor_empaque: "CAJA 8 UD" } // NOTE: duplicate name in image. Will do a LIKE match later if needed.
];

async function run() {
  console.log("Fetching current products...");
  const { data: products, error } = await supabase.from('stock_sedile').select('id, nombre');
  
  if (error) {
    console.error("Error fetching products:", error);
    return;
  }
  
  console.log(`Found ${products.length} products. Updating factors...`);
  
  for (const update of updates) {
    // try exact match first
    let product = products.find(p => p.nombre.trim().toLowerCase() === update.nombre.trim().toLowerCase());
    
    // if not found, try includes
    if (!product) {
      product = products.find(p => p.nombre.trim().toLowerCase().includes(update.nombre.trim().toLowerCase()));
    }
    
    if (product) {
      const { error: updateError } = await supabase
        .from('stock_sedile')
        .update({ factor_empaque: update.factor_empaque })
        .eq('id', product.id);
        
      if (updateError) {
        console.error(`Error updating ${product.nombre}:`, updateError);
      } else {
        console.log(`Updated ${product.nombre} -> ${update.factor_empaque}`);
      }
    } else {
      console.log(`Product not found in DB: ${update.nombre}`);
    }
  }
  
  console.log("Done updating factors!");
}

run();
