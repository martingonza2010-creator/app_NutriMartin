const fs = require('fs');

let content = fs.readFileSync('App.tsx', 'utf8');

// 1. State updates
content = content.replace(
  "const [editingId, setEditingId] = useState<string | null>(null);",
  "const [isGlobalEditMode, setIsGlobalEditMode] = useState(false);"
);
content = content.replace(
  "const [editingFields, setEditingFields] = useState<Partial<StockItem>>({});",
  "const [globalEdits, setGlobalEdits] = useState<Record<string, Partial<StockItem>>>({});"
);

// 2. Remove startEditing and replace saveInlineEdit
const startEditingStr = `  // Iniciar Edición Inline
  const startEditing = (item: StockItem) => {
    setEditingId(item.id);
    setEditingFields({ ...item });
  };`;

content = content.replace(startEditingStr, "");

const saveInlineStart = `  // Guardar Cambios Inline
  const saveInlineEdit = async (id: string) => {`;
const toggleVisStart = `  // Cambiar visibilidad (Ocultar / Mostrar producto)`;

const beforeSaveInline = content.substring(0, content.indexOf(saveInlineStart));
const afterSaveInline = content.substring(content.indexOf(toggleVisStart));

const newSaveGlobal = `  // Guardar Datos Masivos
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

`;

content = beforeSaveInline + newSaveGlobal + afterSaveInline;

// 3. Add Top Buttons
const btnStart = `{/* Acciones de exportación seguras */}
              {isAdmin ? (
                <>
                  <button`;

const btnNew = `{/* Acciones de exportación seguras */}
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
                    className={\`flex items-center gap-1.5 px-4 py-2.5 rounded-xl text-xs font-bold transition-all shadow-sm active:scale-95 \${
                      isGlobalEditMode 
                        ? 'bg-emerald-600 hover:bg-emerald-500 text-white border border-emerald-600' 
                        : 'bg-indigo-600 hover:bg-indigo-500 text-white border border-indigo-600'
                    }\`}
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
                  )}

                  <button`;

content = content.replace(btnStart, btnNew);

// 4. Change table body logic
content = content.replace(
  "const isEditing = editingId === item.id;",
  "const isEditing = isGlobalEditMode;"
);

// 5. Replace fields inputs
const fields = ["codigo", "licitacion_contrato", "factor_empaque", "ubicacion", "area", "nombre", "unidad"];
for (const field of fields) {
  content = content.replace(
    new RegExp(`value=\\{editingFields\\.${field} \\|\\| ''\\}`, "g"),
    `value={globalEdits[item.id]?.${field} ?? item.${field} ?? ''}`
  );
  content = content.replace(
    new RegExp(`value=\\{editingFields\\.${field} \\|\\| 'clinica'\\}`, "g"), // for area select
    `value={globalEdits[item.id]?.${field} ?? item.${field} ?? 'clinica'}`
  );
  content = content.replace(
    new RegExp(`onChange=\\{\\(e\\) => setEditingFields\\(\\{ \\.\\.\\.editingFields, ${field}: e\\.target\\.value \\}\\)\\}`, "g"),
    `onChange={(e) => handleGlobalEdit(item.id, '${field}', e.target.value)}`
  );
}

// 6. Delete the inline action buttons (Save/Cancel inside Nombre)
const inlineActionsStart = `{/* Acciones en menú */}
                                {!isHistoryMode && (
                                  <div className="flex items-center gap-1">
                                    {isEditing ? (
                                      <>
                                        <button
                                          onClick={() => saveInlineEdit(item.id)}
                                          className="p-1 hover:bg-emerald-100 rounded-lg text-emerald-600 transition-colors"
                                          title="Guardar cambios"
                                        >
                                          <Check className="w-4 h-4" />
                                        </button>
                                        <button
                                          onClick={() => setEditingId(null)}
                                          className="p-1 hover:bg-slate-100 rounded-lg text-slate-400 transition-colors"
                                          title="Cancelar"
                                        >
                                          <X className="w-4 h-4" />
                                        </button>
                                      </>
                                    ) : isAdmin ? (`;

const inlineActionsEnd = `                                        </div>
                                      )}
                                    </div>
                                  </div>
                                )}
                              </div>
                            </td>
                          )}`;

const newInlineActions = `{/* Acciones en menú */}
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
                                )}
                              </div>
                            </td>
                          )}`;

const startIndex = content.indexOf(inlineActionsStart);
if (startIndex !== -1) {
  const endIndex = content.indexOf(inlineActionsEnd, startIndex);
  if (endIndex !== -1) {
    const beforeBlock = content.substring(0, startIndex);
    const afterBlock = content.substring(endIndex + inlineActionsEnd.length);
    content = beforeBlock + newInlineActions + afterBlock;
  }
}

// 7. Remove the "Editar" option from 3 dots menu inside the inlineActionsStart block
// Wait, the "Editar" option was inside the 3 dots. Let's see what was originally there.
// Ah, the 3 dots originally had "Editar", "Mostrar/Ocultar", "Eliminar". My newInlineActions only has "Mostrar" and "Eliminar". 
// So the "Editar" button is successfully wiped out by replacing the whole block.

fs.writeFileSync('App.tsx', content, 'utf8');
