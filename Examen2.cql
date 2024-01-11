//Ilse Regina Flores Reyes
//ArtículoGrupo
LOAD CSV WITH HEADERS FROM "file:///Persona.csv" AS row
CREATE (n:Persona)
SET n = row

CREATE INDEX index_Persona FOR (n:Persona) ON (n.IdPersona);

//Importar las relaciones

MERGE (n)-[:RELACION]->(m)
LOAD CSV FROM "file:///Relaciones.csv" AS row
MATCH (n:Persona {IdPersona: row[0]}), (m:Persona {IdPersona: row[1]})
MERGE (n)-[r:RELACION]->(m)
SET r.Peso =toInteger(row[2])

//Diagrama del grafo
call db.schema.visualization


4.	Realiza una consulta en cypher que muestre el nombre de las personas
 que viven en las colonias MODERNA y MONRAZ. Los datos para mostrar son la
  colonia, el total de personas y como lista el nombre de las personas
MATCH (n:Persona) WHERE n.Colonia = "MONRAZ" OR n.Colonia = "MODERNA" 
RETURN n.Colonia, COUNT(n), COLLECT (n.Persona)

5.	¿Cuál es el número de saltos que deben darse de GALA PERALTA 
con las demás personas alcanzables?, ¿Cómo puedes validar tu respuesta? 
MATCH (n:Persona{Persona:'GALA PERALTA'}) 
 MATCH (n)-[*..3]-(m)
 RETURN n.Persona AS Persona,
    COUNT(DISTINCT m) AS NodosAlcalzables

6.	Usando el algoritmo de comunidad Louvain, modifica la estructura del grafo 
para que implementes un nuevo atributo de comunidad con el nombre del algoritmo. 

 //LOUVAIN
 //1. subgrafo de SUPERHEROES
  CALL gds.graph.project(
    'MyUndirectedGraph',
    'Persona',
    {RELACION:{orientation:'UNDIRECTED'}}
  )

//2. 
CALL gds.louvain.write.estimate(
  'MyUndirectedGraph', {writeProperty:'louvain'}
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory
//3
CALL gds.louvain.stream('MyUndirectedGraph')
YIELD nodeId, communityId, intermediateCommunityIds
RETURN gds.util.asNode(nodeId).Persona, communityId
ORDER BY communityId

//4
CALL gds.louvain.write('MyUndirectedGraph',
{writeProperty:'louvain'})
YIELD communityCount, modularity

7.	Usando el algoritmo de centralidad PageRank, modifica la estructura 
del grafo para que implementes un atributo de centralidad con el nombre del algoritmo.



    CALL gds.graph.project(
                "myGraphPR", 
                "Persona",
                "RELACION", 
                {relationshipProperties:'Peso'}

            )


    CALL gds.pageRank.stream("myGraphPR")
            YIELD nodeId, score 
            RETURN gds.util.asNode(nodeId).Persona AS Name,
            score
            ORDER BY score DESC, Name ASC 

    CALL gds.pageRank.write(
                "myGraphP",{
                    maxIterations: 20,
                    dampingFactor: 0.85,
                    writeProperty: "pageRank1"
                }
            )
            YIELD nodePropertiesWritten, ranIterations

  8. Usando el algoritmo de búsqueda de caminos Minimum Weight Spanning Tree, 
  modifica la estructura del grafo para que muestre el camino desde la persona 
  con mayor PageRank a las demás personas alcanzables
  CALL gds.graph.project('myUndirectedGraph','Persona',{
  RELACION:
  {
    orientation: 'UNDIRECTED',
    Properties: 'Peso'
  }
}
)
MATCH(source:Persona{Persona:'AITOR DEL JORDÁN'})
CALL gds.beta.spanningTree.write
(

  'myUndirectedGraph', {
    sourceNode: id(source),
    relationshipWeightProperty: 'Peso',
    writeProperty: 'writeCost',
    writeRelationshipType: 'ST'
  }
)

YIELD preProcessingMillis, computeMillis, writeMillis, effectiveNodeCount
RETURN preProcessingMillis, computeMillis, writeMillis, effectiveNodeCount;
 

 9.	Si elegimos a HUMBERTO PERA, ¿cuáles serían los tres amigos para recomendar
 (que actualmente no tengan la relación amigo) por similaridad? 
 
    CALL gds.graph.project(
        'myGraphsimilar',
        ['Persona','Persona'],
        {RELACION:{properties:'Peso'}}
    )

CALL gds.nodeSimilarity.stream('myGraphsimilar')
YIELD node1, node2, similarity
WITH gds.util.asNode(node1) AS person1, gds.util.asNode(node2) AS person2, similarity
WHERE person1.Persona = 'HUMBERTO PERA'
RETURN person1.Persona AS Person1, person2.Persona AS Person2, similarity
ORDER BY similarity DESCENDING, Person1, Person2




 10.	Si elegimos a FLORENCIA ARMAS, ¿cuáles serían los tres amigos para recomendar
  (que actualmente no tengan la relación amigo) por comunidad? Evidencia código cypher 
  y la captura de pantalla de la respuesta [10 puntos]
  // 10.
MATCH(n:Persona{Persona:'FLORENCIA ARMAS'}) RETURN n.louvain
match(n:Persona) WHERE n.louvain = 450 RETURN n.Persona

