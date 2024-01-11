MATCH (n:Airport) WHERE n.country in 
['United Kingdom','Spain','Germany','France','Portugal','Norway','Sweden','Netherlands','Poland','Portugal','Ireland','Belgium','Finland','Denmark' ]
Return COUNT(DISTINCT(n.Label)) as Numero_Aeropuertos, n.country as Paises

MATCH (a)
WHERE NOT a.country IN  ['United Kingdom', 'Spain', 'Germany', 'France', 'Norway', 'Sweden', 'Netherlands', 'Poland', 'Portugal', 
'Ireland', 'Belgium', 'Finland', 'Denmark']
WITH a
DETACH DELETE a

//distancia (weight)
MATCH (a1:Airport)-[e:ENLACE]->(a2:Airport)
WITH
  point({longitude: a1.longitude, latitude: a1.latitude}) AS point1, 
  point({longitude: a2.longitude, latitude: a2.latitude}) AS point2,
  a1, e, a2
SET e.weight = point.distance(point1, point2) /1000
RETURN a1, a2, e.cost AS distancia_entre_aeropuertos
LIMIT 5











//DIRECTED AND UNDIRECTED
CALL gds.graph.project(
  'myDirectedGraph',
  'Airport',
  {ENLACE:
  {
    orientation: 'NATURAL',
    Properties: 'weight'
  }}
)

CALL gds.graph.project('myUndirectedGraph','Airport',{
  ENLACE:
  {
    orientation: 'UNDIRECTED',
    Properties: 'weight'
  }
}
)


//DELTA



1.  ¿Cuáles son los lugares más cercanos para visitar desde Liverpool?
MATCH (source:Airport{Label:'Liverpool'})
CALL gds.allShortestPaths.delta.write('myDirectedGraph',
{
  sourceNode: source,
  relationshipWeightProperty:'weight',
  writeRelationshipType: 'PATH_Liverpool',
  writeNodeIds: true,
  writeCosts:true
})
YIELD relationshipsWritten
RETURN relationshipsWritten

MATCH p=()-[r:PATH_Liverpool]->() RETURN p ORDER BY r.totalCost ASC LIMIT 5
 


//dijkstra
CALL gds.graph.project(
    'myGraphSK',
    'Airport',
    'ENLACE',
    {
        relationshipProperties: 'weight'
    }
)

MATCH (source:Airport{Label: 'Savonlinna'}),
(target:Airport{Label: 'Kristiansund'})
CALL gds.shortestPath.dijkstra.write('myGraphSK',{
  sourceNode: source,
  targetNode: target,
  relationshipWeightProperty:'Weight',
  writeRelationshipType:'PATH_S_to_K',
  writeNodeIds: true,
  writeCosts: true
})
YIELD relationshipsWritten
RETURN relationshipsWritten


1.	¿Cuál es la ruta más rápida para ir del aeropuerto Berlin al aeropuerto Londres?
CALL gds.graph.project(
    'myGraphSK',
    'Airport',
    'ENLACE',
    {
        relationshipProperties: 'weight'
    }
)

MATCH (source:Airport{Label: 'Berlin'}),
(target:Airport{Label: 'London'})
CALL gds.shortestPath.dijkstra.write('myGraphSK',{
  sourceNode: source,
  targetNode: target,
  relationshipWeightProperty:'weight',
  writeRelationshipType:'PATH_Berlin_to_London',
  writeNodeIds: true,
  writeCosts: true
})
YIELD relationshipsWritten
RETURN relationshipsWritten


//Random Walk
//	4. ¿Si quiero visitar destinos de una manera más aleatoria e inusual, a que lugares podría ir?
CALL gds.randomWalk.stream(
  'myDirectedGraph',
  {
    walkLength: 2,
    walksPerNode: 1,
    randomSeed: 42,
    concurrency: 1
  }
)
YIELD nodeIds, path
RETURN nodeIds, [node IN nodes(path) | node.Label] AS pages


//Minimum weight spanning tree
//5.	¿Cuáles son algunos lugares que puedo visitar partiendo desde el aeropuerto de Faro y cuantos aeropuertos son en total?

MATCH(source:Airport{Label:'Faro'})
CALL gds.beta.spanningTree.write
(

  'myUndirectedGraph', {
    sourceNode: id(source),
    relationshipWeightProperty: 'weight',
    writeProperty: 'writeCost',
    writeRelationshipType: 'MINST'
  }
)

YIELD preProcessingMillis, computeMillis, writeMillis, effectiveNodeCount
RETURN preProcessingMillis, computeMillis, writeMillis, effectiveNodeCount;

//Depth first search: 
6.	¿Quiero planear mi viaje partiendo de Madrid, que destinos porís visitar, dame una ruta?
MATCH (source:Airport{Label:'Madrid'})
CALL gds.dfs.stream('myDirectedGraph',{
  sourceNode:source,
  maxDepth: 1
})
YIELD path
RETURN path

//2
2. ¿A que destinos puedo ir partiendo de Stockholm solo tomando una escala o vuelo directo?

MATCH (source:Airport{Label:'Stockholm'})
CALL gds.dfs.stream('myDirectedGraph',{
  sourceNode:source,
  maxDepth: 2
})
YIELD path
RETURN path


