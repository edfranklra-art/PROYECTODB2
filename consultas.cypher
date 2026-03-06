// Consulta 1: Ruta más corta por Distancia
MATCH (start:Almacen {id: 'A1'}), (end:PuntoEntrega {id: 'PE1'})
MATCH path = shortestPath((start)-[:CONECTA_A*]->(end))
WITH path, reduce(total = 0, r IN relationships(path) | total + r.distancia) AS distancia_total
RETURN [n IN nodes(path) | n.id] AS ruta, distancia_total;

// Consulta 2: Ruta más rápida por Tiempo
MATCH (start:Almacen {id: 'A1'}), (end:PuntoEntrega {id: 'PE1'})
MATCH path = shortestPath((start)-[:CONECTA_A*]->(end))
WITH path, reduce(total = 0, r IN relationships(path) | total + r.tiempo_estimado) AS tiempo_total
RETURN [n IN nodes(path) | n.id] AS ruta_rapida, tiempo_total;

// Consulta 3: Costo Dinámico (Distancia × Tráfico)
MATCH (start:Almacen {id: 'A1'}), (end:PuntoEntrega {id: 'PE1'})
MATCH path = shortestPath((start)-[:CONECTA_A*]->(end))
WITH path, reduce(totalCosto = 0, r IN relationships(path) | totalCosto + (r.distancia * (1 + r.nivel_trafico))) AS costo_total
RETURN costo_total;

// Consulta 4: Restricción de Carga (Filtrado)
MATCH (start:Almacen {id: 'A1'}), (end:PuntoEntrega {id: 'PE2'})
MATCH path = shortestPath((start)-[:CONECTA_A*]->(end))
WHERE ALL(r IN relationships(path) WHERE r.peso_maximo >= 40)
RETURN [n IN nodes(path) | n.id] AS ruta_valida;

// Consulta 5: Multi-Parada (Expandir camino)
MATCH (n:Almacen {id: 'A1'})
MATCH path = (n)-[:CONECTA_A*1..10]->()
RETURN path;