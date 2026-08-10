import { createClient } from "@supabase/supabase-js";

// --- CONFIGURACIÓN DE STOCK SEDILE 2026 ---
const PROJECT_ID = "muthgtxtuubcwkzjkptb";
const SUPABASE_URL = `https://${PROJECT_ID}.supabase.co`;

// Clave pública anon de la base de datos Supabase
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im11dGhndHh0dXViY3dremprcHRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMzIzMTcsImV4cCI6MjA4MDkwODMxN30.uUdLWBSXK6WUrulUadBXcnhlhq2C9VGvDjaO5ogHcFE";

// Verificamos si la configuración es válida
const isValidUrl = (url?: string) => {
  if (!url) return false;
  try {
    new URL(url);
    return true;
  } catch {
    return false;
  }
};

export const isConfigured = isValidUrl(SUPABASE_URL) && SUPABASE_ANON_KEY.length > 10;

const supabaseUrl = isConfigured ? SUPABASE_URL : "https://placeholder.supabase.co";
const supabaseKey = isConfigured ? SUPABASE_ANON_KEY : "placeholder";

// Cliente Supabase unificado
export const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
    storage: localStorage,
    storageKey: `sb-${PROJECT_ID}-auth-token`
  }
});
