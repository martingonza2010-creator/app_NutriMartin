import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = "https://muthgtxtuubcwkzjkptb.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im11dGhndHh0dXViY3dremprcHRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMzIzMTcsImV4cCI6MjA4MDkwODMxN30.uUdLWBSXK6WUrulUadBXcnhlhq2C9VGvDjaO5ogHcFE";

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

const updates = [
  { nombre: "Abintra", qty: 990 },
  { nombre: "Aceite MCT", qty: 0 },
  { nombre: "Aceite vegetal", qty: 0 },
  { nombre: "Adaptador enfit", qty: 6000 },
  { nombre: "Agua Mineral", qty: 899 },
  { nombre: "Alfamino", qty: 0 },
  { nombre: "Alprem", qty: 0 },
  { nombre: "Ascenda", qty: 0 },
  { nombre: "Avena", qty: 0 },
  { nombre: "Azúcar", qty: 0 },
  { nombre: "Bajada Amika", qty: 2340 },
  { nombre: "Blemil plus elemental", qty: 0 },
  { nombre: "Blemil plus hidrolizada", qty: 0 },
  { nombre: "Bolsa hidratación", qty: 0 },
  { nombre: "Chuño", qty: 0 },
  { nombre: "Colado manzana", qty: 0 },
  { nombre: "Ensure Clinical", qty: 120 },
  { nombre: "Ensure Compact", qty: 0 },
  { nombre: "Ensure polvo", qty: 60 },
  { nombre: "Espesante", qty: 12 },
  { nombre: "Formula infantil sin lactosa", qty: 0 },
  { nombre: "Fortificante Materno", qty: 0 },
  { nombre: "Frebini energy drink", qty: 24 },
  { nombre: "Fresubin 2 Kcal crema capuchino", qty: 24 },
  { nombre: "Fresubin Hepa drink", qty: 24 },
  { nombre: "Fresubin renal capuccino", qty: 24 },
  { nombre: "Glucerna Triple Care Liquido", qty: 168 },
  { nombre: "Glutapak-R", qty: 150 },
  { nombre: "Hepatic NM", qty: 0 },
  { nombre: "Jugos (DONACION)", qty: 0 },
  { nombre: "Lacsure", qty: 0 },
  { nombre: "Lecha Althera", qty: 0 },
  { nombre: "Leche 12% MG", qty: 0 },
  { nombre: "Leche 26% MG", qty: 0 },
  { nombre: "Leche Nido etapa +1", qty: 0 },
  { nombre: "Monogen", qty: 0 },
  { nombre: "Nan optipro liquida", qty: 0 },
  { nombre: "Nan 3 L Confortis", qty: 0 },
  { nombre: "Nan expert pro comfort", qty: 0 },
  { nombre: "Nan I", qty: 0 },
  { nombre: "Nan prematuro", qty: 0 },
  { nombre: "Nat 100 diabetico", qty: 112 },
  { nombre: "Nat 100 fibra", qty: 4 },
  { nombre: "Neocate", qty: 0 },
  { nombre: "Nepro AP", qty: 24 },
  { nombre: "Nessucar", qty: 108 },
  { nombre: "Nutren Senior", qty: 0 },
  { nombre: "Nutrilon Pepti Junior", qty: 25 },
  { nombre: "Pediasure Drink sabor vainilla", qty: 783 },
  { nombre: "Pediasure polvo", qty: 132 },
  { nombre: "Proteinex", qty: 369 },
  { nombre: "similac 1", qty: 0 },
  { nombre: "Similac Neosure", qty: 0 },
  { nombre: "Similac Rice (DONACION)", qty: 0 },
  { nombre: "Similac special Care liquido", qty: 0 },
  { nombre: "Similac total comfort", qty: 12 },
  { nombre: "Supportan Drink", qty: 0 },
  { nombre: "Vasos 10 oz", qty: 0 },
  { nombre: "Vasos 12 oz", qty: 0 },
  { nombre: "Vasos 8 oz", qty: 0 },
  { nombre: "VIV362386229V2", qty: 0 },
  { nombre: "Vivalite gold (Fomula para Diabeticos)", qty: 112 },
  { nombre: "Vivalite Healing", qty: 0 },
  { nombre: "Vivalite UP con HMB y FOS", qty: 0 },
  { nombre: "Vivalite Whey Protein", qty: 0 },
  { nombre: "Diben 1,5 500 ML", qty: 510 },
  { nombre: "Diben 1,5 1000 ML", qty: 544 },
  { nombre: "Ensure Clinical RTH", qty: 232 },
  { nombre: "Frebini original", qty: 0 },
  { nombre: "Fresubin 2 Kcal", qty: 1365 },
  { nombre: "Fresubin HP ENERGY", qty: 16 },
  { nombre: "Fresubin Intensive", qty: 300 },
  { nombre: "Fresubin Original", qty: 24 },
  { nombre: "Glucerna 1.5", qty: 0 },
  { nombre: "Jevity", qty: 80 },
  { nombre: "Osmolite", qty: 144 },
  { nombre: "SURVIMED", unidad: "500 ML", qty: 30 },
  { nombre: "SURVIMED", unidad: "1000 ML", qty: 0 }
];

async function run() {
  const { data: rows, error: fetchError } = await supabase.from('stock_sedile').select('*');
  if (fetchError) {
    console.error("Error fetching rows:", fetchError);
    return;
  }

  let successCount = 0;
  for (const update of updates) {
    let row;
    if (update.nombre === "SURVIMED") {
      row = rows.find(r => r.nombre === "SURVIMED" && r.unidad === update.unidad);
    } else {
      // Intentar coincidencia exacta o trim/lower
      row = rows.find(r => r.nombre.toLowerCase().trim() === update.nombre.toLowerCase().trim());
    }

    if (row) {
      const stock_sedile = Number(row.stock_sedile) || 0;
      const new_bodega = update.qty;
      const new_total = stock_sedile + new_bodega;

      const { error } = await supabase
        .from('stock_sedile')
        .update({
          stock_bodega_leches: new_bodega,
          stock_total: new_total
        })
        .eq('id', row.id);

      if (error) {
        console.error(`Error updating ${row.nombre}:`, error);
      } else {
        successCount++;
        console.log(`Updated ${row.nombre} -> Bodega: ${new_bodega}, Total: ${new_total}`);
      }
    } else {
      console.warn(`Could not find match for ${update.nombre}`);
    }
  }

  console.log(`Finished updating ${successCount} products.`);
}

run();
