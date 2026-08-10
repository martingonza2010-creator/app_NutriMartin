import re

with open("App.tsx", "r", encoding="utf-8") as f:
    content = f.read()

# 1. State changes
content = content.replace(
    "const [editingId, setEditingId] = useState<string | null>(null);",
    "const [isGlobalEditMode, setIsGlobalEditMode] = useState(false);"
)
content = content.replace(
    "const [editingFields, setEditingFields] = useState<Partial<StockItem>>({});",
    "const [globalEdits, setGlobalEdits] = useState<Record<string, Partial<StockItem>>>({});"
)

# 2. Add saveGlobalEdits function instead of saveInlineEdit
save_inline_edit_pattern = re.compile(r"// Guardar Cambios Inline\s+const saveInlineEdit = async.*?};\s+// Cambiar visibilidad", re.DOTALL)

save_global_edits = """// Guardar Datos Masivos
  const saveGlobalEdits = async () => {
    if (Object.keys(globalEdits).length === 0) {
      setIsGlobalEditMode(false);
      return;
    }
    setSyncing(true);
    let updatedList = [...items];
    const updates = [];

    // Actualización optimista local
    for (const [id, changes] of Object.entries(globalEdits)) {
      const originalIndex = updatedList.findIndex(item => item.id === id);
      if (originalIndex !== -1) {
        updatedList[originalIndex] = { ...updatedList[originalIndex], ...changes };
        // preparar para supabase
        const it = updatedList[originalIndex];
        updates.push({
          id: it.id,
          codigo: it.codigo,
          nombre: it.nombre,
          unidad: it.unidad,
          stock_sedile: it.stock_sedile,
          stock_bodega_leches: it.stock_bodega_leches,
          uso_diario: it.uso_diario,
          stock_total: it.stock_total,
          categoria: it.categoria,
          factor_empaque: it.factor_empaque || '',
          licitacion_contrato: it.licitacion_contrato || '',
          ubicacion: it.ubicacion || '',
          area: it.area || 'clinica'
        });
      }
    }

    setItems(updatedList);
    setGlobalEdits({});
    setIsGlobalEditMode(false);

    if (isConfigured) {
      try {
        const { error } = await supabase.from('stock_sedile').upsert(updates);
        if (!error) {
          showToast("Datos actualizados correctamente", "success");
        } else {
          console.error("Error guardando edición masiva:", error);
          showToast("Error al guardar datos masivos", "error");
          fetchStockData(false);
        }
      } catch (err) {
        console.error("Excepción en guardado masivo:", err);
        fetchStockData(false);
      }
    } else {
      localStorage.setItem('stock_sedile_cache', JSON.stringify(updatedList));
      showToast("Datos guardados localmente", "success");
    }
    setSyncing(false);
  };

  // Helper para manejar cambios en la cuadrícula global
  const handleGlobalEdit = (id: string, field: string, value: string) => {
    setGlobalEdits(prev => ({
      ...prev,
      [id]: {
        ...(prev[id] || {}),
        [field]: value
      }
    }));
  };

  // Cambiar visibilidad"""

content = save_inline_edit_pattern.sub(save_global_edits, content)

# 3. Remove startEditing function
start_editing_pattern = re.compile(r"// Iniciar edici.*?};", re.DOTALL)
content = start_editing_pattern.sub("", content)

# 4. Replace buttons in header
buttons_pattern = re.compile(r"{/\* Acciones de export.*?\s+{isAdmin \? \(\s+<>")

new_buttons = """{/* Acciones de exportación seguras */}
              {isAdmin ? (
                <>
                  <button
                    onClick={() => {
                      if (isGlobalEditMode) {
                        saveGlobalEdits();
                      } else {
                        setIsGlobalEditMode(true);
                      }
                    }}
                    className={`flex items-center gap-1.5 px-4 py-2.5 rounded-xl text-xs font-bold transition-all shadow-sm active:scale-95 ${
                      isGlobalEditMode 
                        ? 'bg-emerald-600 hover:bg-emerald-500 text-white border border-emerald-600' 
                        : 'bg-indigo-600 hover:bg-indigo-500 text-white border border-indigo-600'
                    }`}
                  >
                    {isGlobalEditMode ? <Check className="w-3.5 h-3.5" /> : <Edit3 className="w-3.5 h-3.5" />}
                    {isGlobalEditMode ? 'Guardar Datos' : 'Editar Datos'}
                  </button>

                  {isGlobalEditMode && (
                    <button
                      onClick={() => {
                        setIsGlobalEditMode(false);
                        setGlobalEdits({});
                      }}
                      className="flex items-center gap-1.5 px-4 py-2.5 rounded-xl bg-slate-50 hover:bg-slate-100 border border-slate-200 text-slate-700 text-xs font-bold transition-all shadow-sm active:scale-95"
                    >
                      <X className="w-3.5 h-3.5" /> Cancelar
                    </button>
                  )}"""

content = buttons_pattern.sub(new_buttons, content)

# 5. Fix table cells
# Replace "const isEditing = editingId === item.id;" with "const isEditing = isGlobalEditMode;"
content = content.replace("const isEditing = editingId === item.id;", "const isEditing = isGlobalEditMode;")

# In table cells, we need to change editingFields.X to globalEdits[item.id]?.X ?? item.X
# And onChange to handleGlobalEdit(item.id, 'X', e.target.value)

fields_to_fix = [
  "codigo", "licitacion_contrato", "factor_empaque", "ubicacion", "area", "nombre", "unidad"
]

for field in fields_to_fix:
    # Fix value
    content = re.sub(
        rf"value={{editingFields\.{field} \|\| ''}}",
        f"value={{globalEdits[item.id]?.{field} ?? item.{field} ?? ''}}",
        content
    )
    # Fix onChange
    content = re.sub(
        rf"onChange={{\(e\) => setEditingFields\({{ \.\.\.editingFields, {field}: e\.target\.value }}\)}}",
        f"onChange={{(e) => handleGlobalEdit(item.id, '{field}', e.target.value)}}",
        content
    )

# Fix the Check/X inline buttons in Nombre cell and the 'Editar' option in 3 dots
# Look for the section:
# {isEditing ? (
#   <>
#     <button
#       onClick={() => saveInlineEdit(item.id)}

# It's better to just regex remove the inline save/cancel buttons since it's global edit now.
# Replace the whole action block in Nombre cell
actions_block_pattern = re.compile(r"{/\* Acciones en men.*?}\)}", re.DOTALL)

new_actions_block = """{/* Acciones en menú */}
                                {!isHistoryMode && isAdmin && !isGlobalEditMode && (
                                  <div className="flex items-center gap-1">
                                    <div className="relative">
                                      <button
                                        onClick={() => setActiveMenuId(activeMenuId === item.id ? null : item.id)}
                                        className="p-1 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg opacity-0 group-hover:opacity-100 transition-all"
                                      >
                                        <MoreVertical className="w-4 h-4" />
                                      </button>
                                      
                                      {activeMenuId === item.id && (
                                        <div className="absolute left-1/2 -translate-x-1/2 top-full mt-1 w-32 bg-white rounded-lg shadow-xl border border-slate-200 z-[60] overflow-hidden animate-scale-in">
                                          <button
                                            onClick={() => { toggleVisibility(item.id, item.oculto); setActiveMenuId(null); }}
                                            className="w-full text-left px-3 py-2 text-xs font-semibold text-slate-700 hover:bg-slate-50 flex items-center gap-2"
                                          >
                                            {item.oculto ? <Eye className="w-3.5 h-3.5" /> : <EyeOff className="w-3.5 h-3.5" />}
                                            {item.oculto ? 'Mostrar' : 'Ocultar'}
                                          </button>
                                          <button
                                            onClick={() => { handleDeleteProduct(item.id); setActiveMenuId(null); }}
                                            className="w-full text-left px-3 py-2 text-xs font-semibold text-rose-600 hover:bg-rose-50 flex items-center gap-2"
                                          >
                                            <Trash2 className="w-3.5 h-3.5" /> Eliminar
                                          </button>
                                        </div>
                                      )}
                                    </div>
                                  </div>
                                )}"""

content = actions_block_pattern.sub(new_actions_block, content)

with open("App.tsx", "w", encoding="utf-8") as f:
    f.write(content)
