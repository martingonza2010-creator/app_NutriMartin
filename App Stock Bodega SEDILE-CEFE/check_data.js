import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = "https://muthgtxtuubcwkzjkptb.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im11dGhndHh0dXViY3dremprcHRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMzIzMTcsImV4cCI6MjA4MDkwODMxN30.uUdLWBSXK6WUrulUadBXcnhlhq2C9VGvDjaO5ogHcFE";

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

async function run() {
  const { data, error } = await supabase.from('stock_sedile').select('nombre, licitacion_contrato, ubicacion').limit(5);
  if (error) {
    console.error("Error fetching:", error);
  } else {
    console.log("First 5 rows:", data);
  }
}

run();
