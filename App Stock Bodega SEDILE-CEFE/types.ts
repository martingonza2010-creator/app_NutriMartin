export interface StockItem {
  id: string;
  codigo: string;
  nombre: string;
  unidad: string;
  stock_sedile: number;
  uso_diario: number;
  stock_total: number;
  categoria: string;
  oculto?: boolean;
  created_at?: string;
  updated_at?: string;
  user_id?: string;
  factor_empaque?: string;
  area?: string;
  stock_bodega_leches?: number;
  licitacion_contrato?: string;
  ubicacion?: string;
}

export type CategoryType = 'Lácteos/Polvos' | 'RTH (Enteral)' | 'Espesantes/Módulos' | 'Insumos';

export interface AuthUser {
  uid: string;
  displayName: string;
  email: string;
  photoURL?: string;
}

export enum ViewState {
  PUBLIC = 'PUBLIC',
  ADMIN = 'ADMIN'
}

export interface StockHistoryItem {
  id: string;
  stock_id: string;
  nombre: string;
  old_stock: number;
  new_stock: number;
  changed_at: string;
  action: string;
}
