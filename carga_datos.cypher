// ==========================================
// SCRIPT DE CARGA DE DATOS - LOGISTICA
// ==========================================

// 1. Crear Índices para optimizar el rendimiento
CREATE INDEX IF NOT EXISTS FOR (n:Almacen) ON (n.id);
CREATE INDEX IF NOT EXISTS FOR (n:PuntoEntrega) ON (n.id);
CREATE INDEX IF NOT EXISTS FOR (n:Interseccion) ON (n.id);

// 2. Cargar Nodos (Almacenes, Intersecciones, Puntos de Entrega)
UNWIND [
  {id: 'A1', nombre: 'Almacén Central', tipo: 'Almacen'},
  {id: 'I1', nombre: 'Intersección Norte', tipo: 'Interseccion'},
  {id: 'I2', nombre: 'Intersección Sur', tipo: 'Interseccion'},
  {id: 'I3', nombre: 'Intersección Este', tipo: 'Interseccion'},
  {id: 'PE1', nombre: 'Cliente A', tipo: 'PuntoEntrega'},
  {id: 'PE2', nombre: 'Cliente B', tipo: 'PuntoEntrega'},
  {id: 'PE3', nombre: 'Cliente C', tipo: 'PuntoEntrega'}
] AS nodo
CALL {
  WITH nodo
  MERGE (n:Almacen {id: nodo.id}) WHERE nodo.tipo = 'Almacen'
  MERGE (n:Interseccion {id: nodo.id}) WHERE nodo.tipo = 'Interseccion'
  MERGE (n:PuntoEntrega {id: nodo.id}) WHERE nodo.tipo = 'PuntoEntrega'
  SET n.nombre = nodo.nombre
} IN TRANSACTIONS OF 100 ROWS;

// 3. Cargar Relaciones (Rutas entre nodos)
UNWIND [
  {origen: 'A1', destino: 'I1', distancia: 10, tiempo_estimado: 15, nivel_trafico: 0.2, peso_maximo: 50},
  {origen: 'A1', destino: 'I2', distancia: 15, tiempo_estimado: 20, nivel_trafico: 0.5, peso_maximo: 30},
  {origen: 'I1', destino: 'I3', distancia: 5, tiempo_estimado: 8, nivel_trafico: 0.1, peso_maximo: 50},
  {origen: 'I1', destino: 'PE1', distancia: 8, tiempo_estimado: 12, nivel_trafico: 0.8, peso_maximo: 20},
  {origen: 'I2', destino: 'I3', distancia: 12, tiempo_estimado: 18, nivel_trafico: 0.6, peso_maximo: 40},
  {origen: 'I3', destino: 'PE2', distancia: 6, tiempo_estimado: 10, nivel_trafico: 0.3, peso_maximo: 50},
  {origen: 'I3', destino: 'PE3', distancia: 9, tiempo_estimado: 14, nivel_trafico: 0.4, peso_maximo: 45}
] AS ruta
MATCH (o:Almacen {id: ruta.origen}), (d:Interseccion {id: ruta.destino})
MERGE (o)-[r:CONECTA_A]->(d)
SET r.distancia = ruta.distancia, 
    r.tiempo_estimado = ruta.tiempo_estimado, 
    r.nivel_trafico = ruta.nivel_trafico, 
    r.peso_maximo = ruta.peso_maximo;

// Nota: Para relaciones entre Intersecciones y Puntos de Entrega, 
// ajusta los MATCH según tu grafo.