//ArtículoGrupo
LOAD CSV WITH HEADERS FROM "file:///ArticuloGrupo.csv" AS row
CREATE (n:ArticuloGrupo)
SET n = row

CREATE INDEX index_ArticuloGrupo FOR (n:ArticuloGrupo) ON (n.id_articulogrupo);

//Articulo
LOAD CSV WITH HEADERS FROM "file:///Artículo.csv" AS row
CREATE (n:Articulo)
SET n = row


/ Esquema del grafo
call db.schema.visualization

//Muestra todas las etiquetas
call db.labels

//Muestra los tipos de relaciones
call db.relationshipTypes

//Muestra las propiedades de los nodos
call db.schema.nodeTypeProperties

//Muestra las propiedades de las relaciones
call db.schema.relTypeProperties

4. Realiza una consulta en cypher que muestre el nombre de cada super héroe,
 el número de poderes que tiene y una lista que muestre la descripción de cada poder. 
MATCH (n:SuperHero)-[r]->(m:Ability)
RETURN n.Name AS Nombre, COUNT(m), COLLECT(m.Name);

5.¿Cuál es el número de saltos que deben darse de Aquaman con los demás nodos 
alcanzables?, ¿Cómo puedes validar tu respuesta? 
MATCH (n:SuperHero{Name:'Aquaman'}) 
 MATCH (n)-[*..50]-(m)
 RETURN n.Name AS SuperHero,
    COUNT(DISTINCT m) AS NodosAlcalzables

6.Usando el algoritmo de comunidad de tu elección, modifica la estructura del 
grafo para que implementes un atributo de comunidad.
/SUPERHEROES
//LOUVAIN
 //1. subgrafo de SUPERHEROES
  CALL gds.graph.project(
    'MyUndirectedGraph',
    'SuperHero',
    {FRIEND_OF:{orientation:'UNDIRECTED'}}
  )

//2. 
CALL gds.louvain.write.estimate(
  'MyUndirectedGraph', {writeProperty:'louvain'}
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory
//3
CALL gds.louvain.stream('MyUndirectedGraph')
YIELD nodeId, communityId, intermediateCommunityIds
RETURN gds.util.asNode(nodeId).Name, communityId
ORDER BY communityId

//4
CALL gds.louvain.write('MyUndirectedGraph',
{writeProperty:'louvain'})
YIELD communityCount, modularity

7.	Usando el algoritmo de centralidad de tu elección, modifica la estructura 
del grafo para que implementes un atributo de centralidad
//NATURAL => OUT_DEGREE
  CALL gds.graph.project(
    'myGraph',
    'SuperHero',
    {COMPANION: {orientation: 'NATURAL',
                   properties: 'Weight'}
    }
                   
  )

  //3) Ejecutar el algoritmo
CALL gds.degree.stream('myGraphOD')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name as name, score AS OUT_DEGREE
ORDER BY OUT_DEGREE DESC, name ASC

//4) Crear el atributo OUT_DEGREE en los nodos
CALL gds.degree.write('myGraph', {writeProperty: 'OUT_DEGREE'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinScore,
centralityDistribution.max as MaxScore,
centralityDistribution.mean as MeanScore,
nodePropertiesWritten

8.	Usando el algoritmo de búsqueda de caminos de tu elección, modifica la estructura
 del grafo para que implementes un atributo en la relación que muestre el camino 
 entre los dos super héroes de mayor centralidad.

CALL gds.graph.project(
  'myDirectedGrap2h',
  'SuperHero',
  {FRIEND_OF:
  {
    orientation: 'NATURAL',
    Properties: 'OUT_DEGREE'
  }}
)

 MATCH (source:SuperHero{Name:'Batman'}),
(target:SuperHero{Name:'Flash'})
CALL gds.shortestPath.dijkstra.write('myDirectedGraph2',{
  sourceNode: source,
  targetNode: target,
  relationshipWeightProperty:'OUT_DEGREE',
  writeRelationshipType:'PATH_Batman_Flash',
  writeNodeIds: true,
  writeCosts: true
})
YIELD relationshipsWritten
RETURN relationshipsWritten

9.	¿Si elegimos al super héroe Atlas, cuales serían los dos amigos para recomendar 
(que actualmente no tengan la relación amigo) por centralidad?


MATCH (n:SuperHero{Name: 'Atlas'})-[:FRIEND_OF]-(m)
return m.Name

10.	¿Si elegimos al super héroe Cyborg, cuales serían los dos amigos para recomendar 
(que actualmente no tengan la relación amigo) por comunidad? 