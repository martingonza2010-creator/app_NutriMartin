import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = "https://muthgtxtuubcwkzjkptb.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im11dGhndHh0dXViY3dremprcHRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMzIzMTcsImV4cCI6MjA4MDkwODMxN30.uUdLWBSXK6WUrulUadBXcnhlhq2C9VGvDjaO5ogHcFE";

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

const updates = [
  { nombre: "Abintra", licitacion: "2258-266-LQ25" },
  { nombre: "Aceite MCT", licitacion: "AMBAS" },
  { nombre: "Aceite vegetal", licitacion: "NO LICITADO" },
  { nombre: "Adaptador enfit", licitacion: "2258-31-LQ25" },
  { nombre: "Agua Mineral", licitacion: "NO LICITADO" },
  { nombre: "Alfamino", licitacion: "NO ADJUDICADO" },
  { nombre: "Alprem", licitacion: "AMBAS" },
  { nombre: "Ascenda", licitacion: "1122317-10-LR25" },
  { nombre: "Avena", licitacion: "NO LICITADO" },
  { nombre: "Azúcar", licitacion: "NO LICITADO" },
  { nombre: "Bajada Amika", licitacion: "2258-31-LQ25" },
  { nombre: "Blemil plus elemental", licitacion: "1122317-10-LR25" },
  { nombre: "Blemil plus hidrolizada", licitacion: "1122317-10-LR25" },
  { nombre: "Bolsa hidratación", licitacion: "2258-31-LQ25" },
  { nombre: "Chuño", licitacion: "NO LICITADO" },
  { nombre: "Colado manzana", licitacion: "2258-266-LQ25" },
  { nombre: "Ensure Clinical", licitacion: "AMBAS" },
  { nombre: "Ensure Compact", licitacion: "2258-266-LQ25" },
  { nombre: "Ensure polvo", licitacion: "2258-266-LQ25" },
  { nombre: "Espesante", licitacion: "AMBAS" },
  { nombre: "Formula infantil sin lactosa", licitacion: "2258-266-LQ25" },
  { nombre: "Fortificante Materno", licitacion: "AMBAS" },
  { nombre: "Frebini energy drink", licitacion: "1122317-10-LR25" },
  { nombre: "Fresubin 2 Kcal crema capuchino", licitacion: "1122317-10-LR25" },
  { nombre: "Fresubin Hepa drink", licitacion: "1122317-10-LR25" },
  { nombre: "Fresubin renal capuccino", licitacion: "1122317-10-LR25" },
  { nombre: "Glucerna Triple Care Liquido", licitacion: "AMBAS" },
  { nombre: "Glutapak-R", licitacion: "AMBAS" },
  { nombre: "Hepatic NM", licitacion: "1122317-10-LR25" },
  { nombre: "Jugos (DONACION)", licitacion: "NO LICITADO" },
  { nombre: "Lacsure", licitacion: "1122317-10-LR25" },
  { nombre: "Lecha Althera", licitacion: "NO LICITADO" },
  { nombre: "Leche 12% MG", licitacion: "NO LICITADO" },
  { nombre: "Leche 26% MG", licitacion: "NO LICITADO" },
  { nombre: "Leche Nido etapa +1", licitacion: "2258-266-LQ25" },
  { nombre: "Monogen", licitacion: "1122317-10-LR25" },
  { nombre: "Nan  optipro liquida", licitacion: "1122317-10-LR25" },
  { nombre: "Nan 3 L Confortis", licitacion: "1122317-10-LR25" },
  { nombre: "Nan expert pro comfort", licitacion: "1122317-10-LR25" },
  { nombre: "Nan I", licitacion: "1122317-10-LR25" },
  { nombre: "Nan prematuro", licitacion: "1122317-10-LR25" },
  { nombre: "Nat 100 diabetico", licitacion: "1122317-10-LR25" },
  { nombre: "Nat 100 fibra", licitacion: "2258-266-LQ25" },
  { nombre: "Neocate", licitacion: "2258-266-LQ25" },
  { nombre: "Nepro AP", licitacion: "1122317-10-LR25" },
  { nombre: "Nessucar", licitacion: "AMBAS" },
  { nombre: "Nutren Senior", licitacion: "1122317-10-LR25" },
  { nombre: "Nutrilon Pepti Junior", licitacion: "2258-266-LQ25" },
  { nombre: "Pediasure Drink sabor vainilla", licitacion: "AMBAS" },
  { nombre: "Pediasure polvo", licitacion: "AMBAS" },
  { nombre: "Proteinex", licitacion: "AMBAS" },
  { nombre: "similac 1", licitacion: "2258-266-LQ25" },
  { nombre: "Similac Neosure", licitacion: "2258-266-LQ25" },
  { nombre: "Similac Rice (DONACION)", licitacion: "2258-266-LQ26" },
  { nombre: "Similac special Care liquido", licitacion: "2258-266-LQ27" },
  { nombre: "Similac total comfort", licitacion: "AMBAS" },
  { nombre: "Supportan Drink", licitacion: "2258-266-LQ27" },
  { nombre: "Vasos 10 oz", licitacion: "NO LICITADO" },
  { nombre: "Vasos 12 oz", licitacion: "NO LICITADO" },
  { nombre: "Vasos 8 oz", licitacion: "NO LICITADO" },
  { nombre: "VIV362386229V2", licitacion: "1122317-10-LR25" },
  { nombre: "Vivalite gold (Fomula para Diabeticos)", licitacion: "2258-266-LQ27" },
  { nombre: "Vivalite Healing", licitacion: "1122317-10-LR25" },
  { nombre: "Vivalite UP con HMB y FOS", licitacion: "2258-266-LQ27" },
  { nombre: "Vivalite Whey Protein", licitacion: "2258-266-LQ27" },

  // Image 2
  { nombre: "Diben 1,5 500 ML", licitacion: "AMBAS" },
  { nombre: "Diben 1,5 1000 ML", licitacion: "AMBAS" },
  { nombre: "Ensure Clinical RTH", licitacion: "AMBAS" },
  { nombre: "Frebini original", licitacion: "2258-266-LQ27" },
  { nombre: "Fresubin 2 Kcal", licitacion: "AMBAS" },
  { nombre: "Fresubin HP ENERGY", licitacion: "AMBAS" },
  { nombre: "Fresubin Intensive", licitacion: "AMBAS" },
  { nombre: "Fresubin Original", licitacion: "1122317-10-LR25" },
  { nombre: "Glucerna 1.5", licitacion: "2258-266-LQ27" },
  { nombre: "Jevity", licitacion: "AMBAS" },
  { nombre: "Osmolite", licitacion: "2258-266-LQ27" },
  { nombre: "SURVIMED", licitacion: "1122317-10-LR25" }
];

async function run() {
  console.log("Fetching current products...");
  const { data: products, error } = await supabase.from('stock_sedile').select('id, nombre');
  
  if (error) {
    console.error("Error fetching products:", error);
    return;
  }
  
  console.log(`Found ${products.length} products. Updating licitaciones...`);
  
  for (const update of updates) {
    let product = products.find(p => p.nombre.trim().toLowerCase() === update.nombre.trim().toLowerCase());
    
    if (!product) {
      product = products.find(p => p.nombre.trim().toLowerCase().includes(update.nombre.trim().toLowerCase()));
    }
    
    if (product) {
      const { error: updateError } = await supabase
        .from('stock_sedile')
        .update({ licitacion_contrato: update.licitacion })
        .eq('id', product.id);
        
      if (updateError) {
        console.error(`Error updating ${product.nombre}:`, updateError);
      } else {
        console.log(`Updated ${product.nombre} -> ${update.licitacion}`);
      }
    } else {
      console.log(`Product not found in DB: ${update.nombre}`);
    }
  }
  
  console.log("Done updating licitaciones!");
}

run();
