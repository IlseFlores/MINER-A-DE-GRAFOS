
//Comentario


// para limpiar la consola
:clear

//nodos
()
(variable:Label)

//Relaciones
-- -[]- --> <-- -[]-> <-[]-

//Propiedades
{} 

//
CREATE //
Persona

CREATE(n:Persona)


CREATE(n:Persona{nombre:'Juan'})

//
CREATE
(n:Persona{nombre:'Luis'}),
(m:Persona{nombre:'José',auto:'VW'}),
(n)-[:AMIGO{desde:2023}]->(m)

//
MATCH (n:Persona)
WHERE n.nombre = 'Juan'
MATCH (m:Persona{nombre:'Luis'})
CREATE (n)-[:AMIGO]->(m)

MATCH (n:Airport)
WHERE n.country

//Similitud SQL
SELECT   RETURN
FROM     MATCH
WHERE    WHERE

RETURN 48*16
RETURN "Hola Mundo"

// Historial
:history

//ayuda
:help
:help MATCH
:help RETURN
:help WHERE

//
MATCH (n)
RETURN elementId(n), n


MATCH (n)
WHERE elementId(n) = "4:dfbd6bb1-31f5-44aa-a83e-5da0faebc32c:1"
RETURN n.nombre, elementId(n)

MATCH (n)
WHERE elementId(n) = "4:dfbd6bb1-31f5-44aa-a83e-5da0faebc32c:1"
RETURN n.nombre AS Nombre, elementId(n) AS Identificador

CREATE (m:Material{descripción:'cemento'})


// Esquema del grafo
call db.schema.visualization

//Muestra todas las etiquetas
call db.labels

//Muestra los tipos de relaciones
call db.relationshipTypes

//Muestra las propiedades de los nodos
call db.schema.nodeTypeProperties

//Muestra las propiedades de las relaciones
call db.schema.relTypeProperties
//INFORMACIÓN DE LA BASES DE DATOS:
//Infomación de la base de datos
call db.info

//Información de la base de datos de los metadatos
call dbms.info

//Muestra la versión de la base de datos
call dbms.components

//Muestra el usuario de la base de datos
call dbms.showCurrentUser

//
:sysinfo

//
SHOW DATABASE
//información del servidor
SHOW SERVERS
//Rol que tiene el usuario en la base de datos
SHOW ROLES
//
SHOW PRIVILEGES

// FUNCIONES DE AGREGACIÓN
COUNT, MAX, MIN, AVG, SUM, COLLECT

//
MATCH (n:Persona)
RETURN COUNT(n) AS NumNodosPersona

MATCH (n:Persona)
RETURN COUNT(n), n.nombre

SELECT COUNT(*), n.nombre
FROM PERSONA AS n
GROUP BY n.nombre

MATCH (n:Persona) 
RETURN COLLECT (n.nombre)


//24-AGOSTO-2023

:play movies

//Análisis básico

// 1) Cuales y cuantos son los nodos (19 nodos, 9 de persona y 10 de movie)
// 2) Cuales y cuantas son las relaciones (6: Acted_in, directed, produced, wrote, follows, reviewed)
// 3) Atributos de nodos movie: released, tagline, title. Persona: born, name.
    //Tipos de atributos 
// 4) Atributos de relaciones: Acted
    //Tipos de relaciones
// 5) Propiedades de la base de datos
// 6) Esquema del grafo

MATCH (p:Person) -[r:WROTE]->(m:Movie) RETURN COUNT(r)

MATCH (p:Person) -[r:DIRECTED]->(m:Movie) RETURN COUNT(r)

MATCH (p:Person) -[r:PRODUCED]->(m:Movie) RETURN COUNT(r)

MATCH () -[r:PRODUCED]->() RETURN COUNT(r)

//Como saber si tom hanks esta en la base de datos
MATCH(p:Person) WHERE p.name = 'Tom Hanks'
RETURN p

//Consulta del actor con todas sus peliculas donde ha actuado
MATCH(p:Person) -[r:ACTED_IN]->(m:Movie) WHERE p.name = 'Tom Hanks' RETURN p,r,m

MATCH(p:Person{name: 'Tom Hanks'})-[r:ACTED_IN]->(m:Movie)RETURN p.name as ACTOR, COUNT(DISTINCT m.title) AS NumPeliculas, COLLECT(DISTINCT m.title) AS TituloPeliculas

MATCH (p:Person{name:'Tom Hanks'} )-[r:ACTED_IN]->(m:Movie) <-[:ACTED_IN]-(op:Person{name:'Kevin Bacon'} ) RETURN p,m, op

MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(op:Person) RETURN p,m,op

MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(op:Person) WHERE p.name <> op.name
 RETURN p.name AS ACTOR1,op.name AS ACTOR2, COUNT(DISTINCT m.title) AS NumPeliculas,
  COLLECT(DISTINCT m.title) AS ListaPeliculas ORDER BY NumPeliculas DESC LIMIT 3

//28-ago-23

//Para ver el esquema
call db.schema.visualization

MATCH (n)
RETURN n

//Ver el grafo completo
MATCH (n)-[r]->(m)
RETURN n,r,m

//
MATCH(n:Person{name:'Kevin Bacon'})-[r:ACTED_IN]->(m:Movie) RETURN n,m

//$ActorName
MATCH(n:Person{})-[r:ACTED_IN]->(m:Movie) 
WHERE n.name = $ActorName
RETURN n,r,m

//Tom 5 pesonas con mas OUT_DEGREE
MATCH(n:Person)-[r]->(m:Movie) 
RETURN n.name, COUNT(DISTINCT r) AS OUT_DEGREE
 ORDER BY OUT_DEGREE DESC LIMIT 5

 MATCH(n:Person)-[r]->(m:Movie) 
 WHERE n.name=$ActorName
RETURN n.name, COUNT(DISTINCT r) AS OUT_DEGREE
 ORDER BY OUT_DEGREE DESC LIMIT 5

 //Que me de un nodo y contar los nodos alcanzables a 1 salto y a dos saltos
 //En browser la lista de nodos alcanzables R[T,V,S]  [Z,....]

 // 31/ago/2023

 MATCH (p:Person{name=$ActorName}) 
 MATCH (p)-[*1..$Saltos]-(n)
 RETURN p.name AS PERSONA 
    COUNT(DISTINCT n) AS NodosAlcalzables

MATCH(p:Person)-[r]-(m:Movie) 
WHERE n.name=$ActorName
RETURN p.name, COUNT(DISTINCT r) AS OUT_DEGREE
 ORDER BY OUT_DEGREE ASC LIMIT 5

 //
 MATCH(n:Person{name:'Kevin Bacon'})
MATCH (n)-[*1..1]-(p) 
RETURN COUNT (DISTINCT p)
UNION ALL
MATCH(n:Person{name:'Kevin Bacon'})
MATCH (n)-[*1..2]-(p) 
RETURN COUNT (DISTINCT p) 
UNION ALL
MATCH(n:Person{name:'Kevin Bacon'})
MATCH (n)-[*1..3]-(p) 
RETURN COUNT (DISTINCT p)
UNION ALL
MATCH(n:Person{name:'Kevin Bacon'})
MATCH (n)-[*1..4]-(p) 
RETURN COUNT (DISTINCT p) 
UNION ALL
MATCH(n:Person{name:'Kevin Bacon'})
MATCH (n)-[*1..5]-(p) 
RETURN COUNT (DISTINCT p)
UNION ALL
MATCH(n:Person{name:'Kevin Bacon'})
MATCH (n)-[*1..6]-(p) 
RETURN COUNT (DISTINCT p)
UNION ALL   
MATCH(n:Person{name:'Tom Hanks'})
MATCH (n)-[*1..1]-(p)
RETURN COUNT (DISTINCT p) 
UNION ALL
MATCH(n:Person{name:'Tom Hanks'})
MATCH (n)-[*1..2]-(p) 
RETURN COUNT (DISTINCT p)
UNION ALL
MATCH(n:Person{name:'Tom Hanks'})
MATCH (n)-[*1..3]-(p) 
RETURN COUNT (DISTINCT p)
UNION ALL
MATCH(n:Person{name:'Tom Hanks'})
MATCH (n)-[*1..4]-(p) 
RETURN COUNT (DISTINCT p)
UNION ALL
MATCH(n:Person{name:'Tom Hanks'})
MATCH (n)-[*1..5]-(p) 
RETURN COUNT (DISTINCT p)
UNION ALL
MATCH(n:Person{name:'Tom Hanks'})
MATCH (n)-[*1..6]-(p) 
RETURN COUNT (DISTINCT p)


//Tarea
MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle'
RETURN p.name AS Actor

MATCH (p:Person)-[:DIRECTED]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN  p.name AS Director

MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN m.title AS Movie

MATCH (u:User)-[:RATED]-(m:Movie)
WHERE m.title = 'Apollo 13'
RETURN count(*) AS `Number of reviewers`

MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN  p.name AS Actor, p.born as `Year Born` ORDER BY p.born DESC LIMIT 1

//REFACTORED
MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN  p.name AS Actor, p.born as `Year Born` ORDER BY p.born DESC LIMIT 1
//
MATCH (p:Person)-[r:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle' AND
p.name = 'Meg Ryan'
RETURN  r.role AS Role

MATCH (m:Movie)
WHERE m.released STARTS WITH '1995'
RETURN  m.title as Movie, m.imdbRating as Rating ORDER BY m.imdbRating DESC LIMIT 1

MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks' AND
'Drama' IN m.genres
RETURN m.title AS Movie

MATCH (u:User)-[r:RATED]-(m:Movie)
WHERE m.title = 'Apollo 13' AND
r.rating = 5
RETURN u.name as Reviewer

//Add labels
MATCH (p:Person)
WHERE exists ((p)-[:ACTED_IN]-())
SET p:Actor

//PROFILE 
PROFILE MATCH (p:Actor)-[:ACTED_IN]-()
WHERE p.born < '1950'
RETURN p.name
//
MATCH (m:Movie)
WHERE 'Italian' IN m.languages
RETURN m.title

//unwind
MATCH (m:Movie)
UNWIND m.languages AS language
WITH  language, collect(m) AS movies
MERGE (l:Language {name:language})
WITH l, movies
UNWIND movies AS m
WITH l,m
MERGE (m)-[:IN_LANGUAGE]->(l);
MATCH (m:Movie)
SET m.languages = null

//
//refactor code
MATCH (m:Movie)
UNWIND m.genres AS genre
MERGE (g:Genre {name: genre})
MERGE (m)-[:IN_GENRE]->(g)
SET m.genres = null;

//revised query
//refactor code
MATCH (m:Movie)
UNWIND m.genres AS genre
MERGE (g:Genre {name: genre})
MERGE (m)-[:IN_GENRE]->(g)
SET m.genres = null;

//revised query
MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)--(g:Genre)
WHERE p.name = 'Tom Hanks' AND
g.name = 'Drama'
RETURN m.title AS Movie
//
MATCH (n:Actor)-[:ACTED_IN]->(m:Movie)
CALL apoc.merge.relationship(n,
  'ACTED_IN_' + left(m.released,4),
  {},
  {},
  m ,
  {}
) YIELD rel
RETURN count(*) AS `Number of relationships merged`;

//Buscar el diametro del nodo
MATCH (start:Person), (end:Movie)
WITH start, end
WHERE id(start) < id(end) 
MATCH path = shortestPath((start)-[*]-(end))
RETURN MAX(length(path)) AS diameter;

//?escala de los grafos
//4-sep-23
//Diametro del grafo == 3
MATCH(start),(end)
WHERE start <> end 
WITH start, end, shortestPath((start)-[*]->(end)) AS path//almacena 
WITH start, end, length(path) AS distance
WHERE distance IS NOT NULL //va a haber distancias imposibles or lo que quitaremos los nulos
RETURN distance
ORDER BY distance DESC
LIMIT 1

//Diametro del grafo == 10
MATCH(start),(end)
WHERE start <> end 
WITH start, end, shortestPath((start)-[*]-(end)) AS path//almacena 
WITH start, end, length(path) AS distance
WHERE distance IS NOT NULL //va a haber distancias imposibles or lo que quitaremos los nulos
RETURN distance
ORDER BY distance DESC
LIMIT 1


//07-09-2023
//centralidad



// Degree centrality
// 1) Crear un subgrafo
  // NATURAL (default) OUT_DEGREE
  //REVERSE IN_DEGREE
  //UNDIRECTED DEGREE
//creando un subgrafo

//REVERSE => IN_DEGREE
  CALL gds.graph.project(
    'myGraphID',
    'Villian',
    {COMPANION: {orientataion: 'REVERSE',
                   properties: 'Weight'}
    }
                   
  )

//2) Calculamos la memoria requerida
CALL gds.degree.write.estimate(
  'myGraphID',
  {writeProperty: 'Degree'}
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

//3) Ejecutar el algoritmo
CALL gds.degree.stream('myGraphID')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name as name, score AS IN_DEGREE
ORDER BY IN_DEGREE DESC, name ASC

//4) Crear el atributo IN_DEGREE en los nodos
CALL gds.degree.write('myGrapgID', {writeProperty: 'IN_DEGREE'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinScore,
centralityDistribution.max as MaxScore,
centralityDistribution.mean as MeanScore,
nodePropertiesWritten

MATCH (v_Villian) RETURN v.Name, v_IN_DEGREE AS IN_DEGREE

//NATURAL => OUT_DEGREE
  CALL gds.graph.project(
    'myGraphOD',
    'Villian',
    {COMPANION: {orientataion: 'NATURAL',
                   properties: 'Weight'}
    }
                   
  )

  //3) Ejecutar el algoritmo
CALL gds.degree.stream('myGraphOD')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name as name, score AS OUT_DEGREE
ORDER BY OUT_DEGREE DESC, name ASC

//4) Crear el atributo OUT_DEGREE en los nodos
CALL gds.degree.write('myGraphOD', {writeProperty: 'OUT_DEGREE'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinScore,
centralityDistribution.max as MaxScore,
centralityDistribution.mean as MeanScore,
nodePropertiesWritten


//UNDIRECTED DEGREE
//1)  
CALL gds.graph.project(
    'myGraphD',
    'Villian',
    {COMPANION: {orientation: 'UNDIRECTED',
                   properties: 'Weight'}
    }
                   
  )

 //3) Ejecutar el algoritmo
 CALL gds.degree.stream('myGraphD')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name as name, score AS DEGREE
ORDER BY DEGREE DESC, name ASC

//4) Crear el atributo OUT_DEGREE en los nodos
CALL gds.degree.write('myGraphD', {writeProperty: 'DEGREE'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinScore,
centralityDistribution.max as MaxScore,
centralityDistribution.mean as MeanScore,
nodePropertiesWritten


//SUPERHERO
//REVERSE => IN_DEGREE
  CALL gds.graph.project(
    'myGraphID2',
    'SuperHero',
    {COMPANION: {orientation: 'REVERSE',
                   properties: 'Weight'}
    }
                   
  )

//2) Calculamos la memoria requerida
CALL gds.degree.write.estimate(
  'myGraphID',
  {writeProperty: 'Degree'}
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

//3) Ejecutar el algoritmo
CALL gds.degree.stream('myGraphID2')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name as name, score AS IN_DEGREE
ORDER BY IN_DEGREE DESC, name ASC

//4) Crear el atributo IN_DEGREE en los nodos
CALL gds.degree.write('myGraphID2', {writeProperty: 'IN_DEGREE'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinScore,
centralityDistribution.max as MaxScore,
centralityDistribution.mean as MeanScore,
nodePropertiesWritten
//falta correr
//NATURAL => OUT_DEGREE

  CALL gds.graph.project(
    'myGraphOD2',
    'SuperHero',
    {COMPANION: {orientataion: 'NATURAL',
                   properties: 'Weight'}
    }
                   
  )

  //3) Ejecutar el algoritmo
CALL gds.degree.stream('myGraphOD2')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name as name, score AS OUT_DEGREE
ORDER BY OUT_DEGREE DESC, name ASC

//4) Crear el atributo OUT_DEGREE en los nodos
CALL gds.degree.write('myGraphOD2', {writeProperty: 'OUT_DEGREE'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinScore,
centralityDistribution.max as MaxScore,
centralityDistribution.mean as MeanScore,
nodePropertiesWritten

//UNDIRECTED DEGREE
//1)  
CALL gds.graph.project(
    'myGraphD2',
    'SuperHero',
    {COMPANION: {orientation: 'UNDIRECTED',
                   properties: 'Weight'}
    }
                   
  )

 //3) Ejecutar el algoritmo
 CALL gds.degree.stream('myGraphD2')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name as name, score AS DEGREE
ORDER BY DEGREE DESC, name ASC

//4) Crear el atributo OUT_DEGREE en los nodos
CALL gds.degree.write('myGraphD2', {writeProperty: 'DEGREE'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinScore,
centralityDistribution.max as MaxScore,
centralityDistribution.mean as MeanScore,
nodePropertiesWritten

//11-09-2023
//PageRank

//1. crear un subgrafo
  CALL gds.graph.project(
    'myGraph',
    'Villian',//ETIQUETA DE LOS NODOS
    'COMPANION',//ETIQUETA DE LA RELACIÓN
    {relationshipProperties:'Weight'}
  )
//2. Calcular la memoria (producción)
CALL gds.pageRank.write.estimate(
  'myGraph',{
    writeProperty: 'pageRank',
    maxIterations: 20,
    dampingFactor: 0.85
  }
)
YIELD nodeCount, relationshipCount, bytesMin,
bytesMax, requiredMemory

//3. Ejecutar el algoritmo
CALL gds.pageRank.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Name as Name,
score
ORDER BY score DESC, Name ASC

//4. Crear el atributo
  CALL gds.pageRank.write('myGraph',{
    maxIterations: 20,
    dampingFactor: 0.85,
    writeProperty: 'pageRank'
  })
  YIELD nodePropertiesWritten, ranIterations

  //BETWEENESS CENTRALITY
  //1. crear un subgrafo
  CALL gds.graph.project('myGraphBC', 'Villian', 
  "COMPANION", {relationshipProperties:"Weight"})
  //2. Calcular la memoria (producción)
  CALL gds.BETWEENESS.write.estimate(
    'myGraph',
    {relationshipProperty:'betweeness'}
  )
  YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory
  //3. Ejecutar el algoritmo
  CALL gds.betweeness.stream('myGraphBC')
  YIELD nodeId, score
  RETURN gds.util.asNode(nodeId).Name as Name, score
  ORDER BY score DESC

  //4. Crear el atributo (grabar el atributo)
  CALL gds.betweenness.write(
    'myGraphBC',
    {writeProperty:'betweenness'}
  )
  YIELD centralityDistribution, nodePropertiesWritten
  RETURN centralityDistribution.min,
  centralityDistribution.max,
  nodePropertiesWritten

  //closeness centrality
  //1. creamos el subgrafo
   CALL gds.graph.project('myGraphBC', 'Villian', 
  "COMPANION", {relationshipProperties:"Weight"})
  // 2 .
  //el algoritmo es beta por lo que no tiene garantía de producción

  //3. aplicamos el algoritmo
  CALL gds.beta.closeness.stream('myGraphBC')
  YIELD nodeId, score
  RETURN gds.util.asNode(nodeId).Name as Name,score
  ORDER BY score DESC

//4. grabar el atributo
CALL gds.beta.closeness.write('myGraphBC', { writeProperty: 'centrality' })
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

  
MATCH(v:Villian)RETURN v.Name, v.closeness ORDER BY v.closeness DESC LIMIT 5

MATCH (v:Villian) RETURN COUNT(v.Name), v.betweenness ORDER BY v.betweenness

MATCH(v:Villian)RETURN v.Name, v.betweenness ORDER BY v.betweenness DESC 

// 5-oct

//Louvain
  //1. subgrafo de villanos
  CALL gds.graph.project(
    'MyUndirectedGraph',
    'Villian',
    {COMPANION:{orientation:'UNDIRECTED'}}
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

MATCH(n:Villian) RETURN n.louvain, COLLECT(n.Name)
//SUPERHEROES
 //1. subgrafo de SUPERHEROES
  CALL gds.graph.project(
    'MyUndirectedGraphSH',
    'SuperHero',
    {FRIEND_OF:{orientation:'UNDIRECTED'}}
  )

//2. 
CALL gds.louvain.write.estimate(
  'MyUndirectedGraphSH', {writeProperty:'louvain'}
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory
//3
CALL gds.louvain.stream('MyUndirectedGraphSH')
YIELD nodeId, communityId, intermediateCommunityIds
RETURN gds.util.asNode(nodeId).Name, communityId
ORDER BY communityId

//4
CALL gds.louvain.write('MyUndirectedGraphSH',
{writeProperty:'louvain'})
YIELD communityCount, modularity

 //1. subgrafo de villanos (DIRIGIDO)
  CALL gds.graph.project(
    'MydirectedGraph',
    'Villian',
    {COMPANION:{orientation:'DIRECTED'}}
  )

//2. 
CALL gds.louvain.write.estimate(
  'MydirectedGraph', {writeProperty:'louvainDIRECTED'}
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

//3
CALL gds.louvain.stream('MydirectedGraph')
YIELD nodeId, communityId, intermediateCommunityIds
RETURN gds.util.asNode(nodeId).Name, communityId
ORDER BY communityId

//4
CALL gds.louvain.write('MydirectedGraph',
{writeProperty:'louvainDIRECTED'})
YIELD communityCount, modularity

//GRAFO completo

//1. subgrafo de todo el grafo (DIRIGIDO)
  CALL gds.graph.project(
    'MydirectedGraph',
    'Villian',
    {COMPANION:{orientation:'DIRECTED'}}
  )

//2. 
CALL gds.louvain.write.estimate(
  'MydirectedGraph', {writeProperty:'louvainDIRECTED'}
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

//3
CALL gds.louvain.stream('MydirectedGraph')
YIELD nodeId, communityId, intermediateCommunityIds
RETURN gds.util.asNode(nodeId).Name, communityId
ORDER BY communityId

//4
CALL gds.louvain.write('MydirectedGraph',
{writeProperty:'louvainDIRECTED'})
YIELD communityCount, modularity

////////////////
// Combinar en un nuevo nodo 'SuperHero' y 'Villian', renombrarlo como 'SyV' y que deje como una etiqueta su nombre aterior del nodo,
// y crear la relación 'RELATED', sustituirla por las antiguas relaciones 'COMPANION', 'FRIEND_OF' y 'ENEMY_OF'
// calcular Louvain Dirigido (NATURAL)

// Combinar 'SuperHero' y 'Villain' en un nuevo nodo 'SyV'
MATCH (s:SuperHero) OR (v:Villain)
WITH COLLECT(s + v) AS nodos, LABELS(s)[0] AS etiqueta_anterior
FOREACH (nodo IN nodos |
  SET nodo:SyV,
      nodo.nombre_anterior = etiqueta_anterior,
      nodo.etiqueta_anterior = etiqueta_anterior,
      nodo:etiqueta_anterior = NULL
)

// Crear la relación 'RELATED' y eliminar las antiguas relaciones
MATCH (syv1:SyV), (syv2:SyV)
WHERE syv1 <> syv2
CREATE (syv1)-[:RELATED]->(syv2)
WITH syv1, syv2
MATCH (syv1)-[r:COMPANION|FRIEND_OF|ENEMY_OF]->(syv2)
DELETE r

// Calcular Louvain Dirigido (NATURAL)
CALL gds.graph.create('syv-graph',
  'SyV',
  {
    RELATED: {
      type: 'RELATED',
      orientation: 'UNDIRECTED'
    }
  }
)

CALL gds.louvain.write('syv-graph', {
  writeProperty: 'louvain',
  relationshipWeightProperty: 'weight'
})

CALL gds.louvain.stream('syv-graph')
YIELD nodeId, communityId
WITH nodeId, communityId
MATCH (syv:SyV) WHERE id(syv) = nodeId
SET syv.louvain = communityId
////////////////

//09-octubre-23
//LABEL PROPAGATION
//Aplicado a sets de datos mucho mas grandes
//sirve para agrupar comunidades


  labelPropagation


  //1. 
  CALL gds.graph.project(
    'MyUndirectedGraph',
    'Villian',
    {COMPANION:{orientation:'UNDIRECTED'}}
  )

  //2. 
CALL gds.labelPropagation.write.estimate(
  'MyUndirectedGraph', {writeProperty:'labelPropagation'}
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

//3
CALL gds.labelPropagation.stream('MyUndirectedGraph')
YIELD nodeId, communityId AS labelPropagation
RETURN gds.util.asNode(nodeId).Name AS Name, labelPropagation
ORDER BY labelPropagation, Name

//4
CALL gds.labelPropagation.write('MyUndirectedGraph',
{writeProperty:'labelPropagation'})
YIELD communityCount, ranIterations, didConverge

MATCH(v:Villian) RETURN v.labelPropagation, COUNT(v.Name), COLLECT(v.Name) ORDER BY COUNT(v.Name) DESC


//SUPERHEROES
 //1. 
  CALL gds.graph.project(
    'MyUndirectedGraphsup',
    'SuperHero',
    {FRIEND_OF:{orientation:'UNDIRECTED'}}
  )

  //2. 
CALL gds.labelPropagation.write.estimate(
  'MyUndirectedGraphsup', {writeProperty:'labelPropagation'}
)
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

//3
CALL gds.labelPropagation.stream('MyUndirectedGraphsup')
YIELD nodeId, communityId AS labelPropagation
RETURN gds.util.asNode(nodeId).Name AS Name, labelPropagation
ORDER BY labelPropagation, Name

//4
CALL gds.labelPropagation.write('MyUndirectedGraphsup',
{writeProperty:'labelPropagation'})
YIELD communityCount, ranIterations, didConverge

MATCH(v:Villian) RETURN v.labelPropagation, COUNT(v.Name), COLLECT(v.Name) ORDER BY COUNT(v.Name) DESC


//WEAKLY CONNECTED COMPONENTS
//(SE supone que debería trabjar con grafos no dirigidos)
//identifica las componentes fuertemente conectadas


//STRONGLY CONNECTED COMPONENTS
//VILLANOS (DIRECTED)
 
CALL gds.graph.project('MyDirected', 'Villian', 'COMPANION')

CALL gds.alpha.scc.stream('MyDirected', {})
YIELD nodeId, componentId
RETURN gds.util.asNode(nodeId).Name AS Name, componentId AS Component
ORDER BY Component DESC

CALL gds.alpha.scc.write('MyDirected', {
  writeProperty: 'componentId'
})
YIELD setCount, maxSetSize, minSetSize;

MATCH (v:Villian)
RETURN v.componentId AS Component, count(*) AS ComponentSize
ORDER BY ComponentSize DESC
LIMIT 1


//Algoritmo Weakly Connected Components

    //1.
CALL gds.graph.project(
  'myGraphW',
  'Villian',
  'COMPANION'
)

//2.
CALL gds.wcc.stream('myGraphWEEK')
YIELD nodeId,componentId
RETURN gds.util.asNode(nodeId).Name AS Name,componentId
ORDER BY componentId, Name

//3.
CALL gds.wcc.write('myGraphWEEK', { writeProperty: 'WEEK' })
YIELD nodePropertiesWritten, componentCount;


    MATCH (v:Villian)
    RETURN v.componentId, COUNT(v.Name),COLLECT(v.Name) ORDER BY COUNT(v.Name) DESC

    //K-1 Coloriing

//23-oct-2023

//Para instalar el ejemplo de northwind
:play northwind-graph
//crear por cada registro un nodo
LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/products.csv" AS row
CREATE (n:Product)
SET n = row,
n.unitPrice = toFloat(row.unitPrice),
n.unitsInStock = toInteger(row.unitsInStock), n.unitsOnOrder = toInteger(row.unitsOnOrder),
n.reorderLevel = toInteger(row.reorderLevel), n.discontinued = (row.discontinued <> "0")
  
LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/categories.csv" AS row
CREATE (n:Category)
SET n = row

LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/suppliers.csv" AS row
CREATE (n:Supplier)
SET n = row

CREATE INDEX FOR (p:Product) ON (p.productID)

CREATE INDEX FOR (p:Product) ON (p.productName)

CREATE INDEX FOR (c:Category) ON (c.categoryID)

CREATE INDEX FOR (s:Supplier) ON (s.supplierID)

MATCH (p:Product),(c:Category)
WHERE p.categoryID = c.categoryID
CREATE (p)-[:PART_OF]->(c)

MATCH (p:Product),(s:Supplier)
WHERE p.supplierID = s.supplierID
CREATE (s)-[:SUPPLIES]->(p)

MATCH (s:Supplier)-->(:Product)-->(c:Category)
RETURN s.companyName as Company, collect(distinct c.categoryName) as Categories

LOAD CSV WITH HEADERS FROM "https://data.neo4j.com/northwind/order-details.csv" AS row
MATCH (p:Product), (o:Order)
WHERE p.productID = row.productID AND o.orderID = row.orderID
CREATE (o)-[details:ORDERS]->(p)
SET details = row,
details.quantity = toInteger(row.quantity)


MATCH (p:Product{productName:'Chai'})RETURN p //Para que aparezca chai


MATCH (p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)
WHERE p.productName = 'Chai'
RETURN p.productName, op.productName, COUNT(o.orderID) AS CuentaOrdenes
ORDER BY CuentaOrdenes DESC
Limit 3

MATCH(c:Category)<-[:PART_OF]-(p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)-[:PART_OF]->(cop:Category) 
WHERE p.productName = 'Chai' AND op<>p AND (op)-[:PART_OF]->(c) 
RETURN c.categoryName, p.productName, op.productName,cop.categoryName, count(o.orderID)ORDER BY count(o.orderID)DESC LIMIT 5

MATCH(s1:Supplier)-[:SUPPLIES]->(p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)<-[:SUPPLIES]-(s2:Supplier) 
WHERE p.productName = 'Tofu' AND op<>p AND (op)<-[:SUPPLIES]-(s1) 
RETURN s1.supplierID, p.productName, op.productName,s2.supplierID

MATCH(s1:Supplier)-[:SUPPLIES]->(p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)<-[:SUPPLIES]-(s2:Supplier) 
WHERE p.productName = 'Chai' AND s1.companyName='Exotic Liquids' AND op<>p AND (op)<-[:SUPPLIES]-(s1) 
RETURN s1.supplierID, p.productName, op.productName,s2.supplierID

//similaridad
  //1
  call gds.graph.project(
    'mygraphp',
    ['Product', 'Order'],
    {ORDERS:{properties:'quantity'}}
  )

  //2
  CALL gds.nodeSimilarity.write.estimate(
    'myGraphp',{writeRelationshipType: 'SIMILAR', writeProperty:'score'}
  )
  YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

  //3
  CALL gds.nodeSimilarity.stream('mygraphp')
  YIELD node1, node2, similarity
  RETURN gds.util.asNode(node1).orderID as Order1,
  gds.util.asNode(node2).orderID as Order2, similarity
  ORDER BY similarity DESC, Order1, Order2

  MATCH (o:Order{orderID:"10271"})-[r:ORDERS]->(p:Product) RETURN o,r,p

  //4
  CALL gds.nodeSimilarity.mutate('mygraphp', {
    mutateRelationshipType: 'SIMILAR',
    mutateProperty: 'score'
})
YIELD nodesCompared, relationshipsWritten

CALL gds.nodeSimilarity.write('mygraphp', {
    writeRelationshipType: 'SIMILAR',
    writeProperty: 'score'
})
YIELD nodesCompared, relationshipsWritten


MATCH (p:Product)<-[:ORDERS]-(o:Order)-[:ORDERS]->(op:Product)<-[:ORDERS]-(o2:Order)<-[r:SIMILAR]-(o:Order)
WHERE p.productName = 'Chai' AND r.score>0.5 AND r.score < 1 AND op>p
RETURN DISTINCT p.productName,op.productName AS productos, COUNT(o.orderID) AS CuentaOrdenes

//caminos

//delta: 
//undirected
CALL gds.graph.project('myUndirectedGraph','Villian',{
  COMPANION:
  {
    orientation: 'UNDIRECTED',
    Properties: 'Weight'
  }
}
)
//directed
CALL gds.graph.project(
  'myDirectedGraph',
  'Villian',
  {COMPANION:
  {
    orientation: 'NATURAL',
    Properties: 'Weight'
  }}
)

//Lex Luthor
MATCH (source:Villian{Name:'Lex Luthor'})
CALL gds.allShortestPaths.delta.write('myDirectedGraph',
{
  sourceNode: source,
  relationshipWeightProperty:'Weight',
  writeRelationshipType: 'PATH_Lex_Luthor',
  writeNodeIds: true,
  writeCosts:true
})
YIELD relationshipsWritten
RETURN relationshipsWritten
//undrected
MATCH (source:Villian{Name:'Lex Luthor'})
CALL gds.allShortestPaths.delta.write('myUndirectedGraph',
{
  sourceNode: source,
  relationshipWeightProperty:'Weight',
  writeRelationshipType: 'PATH_Lex_Luthor_Undirected',
  writeNodeIds: true,
  writeCosts:true
})
YIELD relationshipsWritten
RETURN relationshipsWritten

//Siniestro
MATCH (source:Villian{Name:'Siniestro'})
CALL gds.allShortestPaths.delta.write('myDirectedGraph1',
{
  sourceNode: source,
  relationshipWeightProperty:'Weight',
  writeRelationshipType: 'PATH_Siniestro',
  writeNodeIds: true,
  writeCosts:true
})
YIELD relationshipsWritten
RETURN relationshipsWritten
//undrected
MATCH (source:Villian{Name:'Siniestro'})
CALL gds.allShortestPaths.delta.write('myUndirectedGraph1',
{
  sourceNode: source,
  relationshipWeightProperty:'Weight',
  writeRelationshipType: 'PATH_Siniestro_Undirected',
  writeNodeIds: true,
  writeCosts:true
})
YIELD relationshipsWritten
RETURN relationshipsWritten


//crear la nueva relación
//dijkstra
MATCH (source:Villian{Name:'Viper'}),
(target:Villian{Name:'Lex Luthor'})
CALL gds.shortestPath.dijkstra.write('myDirectedGraph',{
  sourceNode: source,
  targetNode: target,
  relationshipWeightProperty:'Weight',
  writeRelationshipType:'PATH_Viper_to_Lex_Luthor',
  writeNodeIds: true,
  writeCosts: true
})
YIELD relationshipsWritten
RETURN relationshipsWritten


// Relación de viper a lex luthor unDirected

MATCH (source:Villian{Name:'Viper'}),(target:Villian{Name:'Lex Luthor'})
CALL gds.shortestPath.dijkstra.write('myUndirectedGraph',
    {
        sourceNode: source,
        targetNode: target,
        relationshipWeightProperty: 'Weight',
        writeRelationshipType: 'PATH_Und_Viper_to_Lex_Luthor',
        writeNodeIds: true,
        writeCosts: true
    })
YIELD relationshipsWritten
RETURN relationshipsWritten

//SINIESTRO Y GRODD
MATCH (source:Villian{Name:'Siniestro'}),
(target:Villian{Name:'Grodd'})
CALL gds.shortestPath.dijkstra.write('myDirectedGraph',{
  sourceNode: source,
  targetNode: target,
  relationshipWeightProperty:'Weight',
  writeRelationshipType:'PATH_siniestro_to_grodd',
  writeNodeIds: true,
  writeCosts: true
})
YIELD relationshipsWritten
RETURN relationshipsWritten


// Relación de viper a lex luthor unDirected

MATCH (source:Villian{Name:'Siniestro'}),(target:Villian{Name:'Grodd'})
CALL gds.shortestPath.dijkstra.write('myUndirectedGraph',
    {
        sourceNode: source,
        targetNode: target,
        relationshipWeightProperty: 'Weight',
        writeRelationshipType: 'PATH_Und_Siniestro_to_Grodd',
        writeNodeIds: true,
        writeCosts: true
    })
YIELD relationshipsWritten
RETURN relationshipsWritten

//randomwalk
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
RETURN nodeIds, path

//CON DIRECCIÓN, TIPO DE NODO VILLIAN
// Y FORZANDO A PASAR PORN DOS NODOS
MATCH(v:Villian)
WHERE v.Name IN ['Lex Luthor, 'Siniestro]
WITH COLLECT(v) as sourceNodes
CALL gds.randomWalk.stream(
  'myDirectedGraph',
  {
    sourceNodes: sourceNodes,
    walkLength: 4,
    walks,
  }
)

//4
//minimum weight spanning tree
//lista de caminos baratos
//undirected
CALL gds.graph.project('myUndirectedGraph','Villian',{
  COMPANION:
  {
    orientation: 'UNDIRECTED',
    Properties: 'Weight'
  }
}
)
//directed
CALL gds.graph.project(
  'myDirectedGraph',
  'Villian',
  {COMPANION:
  {
    orientation: 'NATURAL',
    Properties: 'Weight'
  }}
)
//

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

//Grodd
MATCH(source:Villian{Name:'Grodd'})
CALL gds.beta.spanningTree.write
(

  'myUndirectedGraph', {
    sourceNode: id(source),
    relationshipWeightProperty: 'Weight',
    writeProperty: 'writeCost',
    writeRelationshipType: 'GRODS'
  }
)

YIELD preProcessingMillis, computeMillis, writeMillis, effectiveNodeCount
RETURN preProcessingMillis, computeMillis, writeMillis, effectiveNodeCount;

//Bizarro
MATCH(source:Villian{Name:'Bizarro'})
CALL gds.beta.spanningTree.write
(

  'myUndirectedGraph', {
    sourceNode: id(source),
    relationshipWeightProperty: 'Weight',
    writeProperty: 'writeCost',
    writeRelationshipType: 'BIZARRIST'
  }
)

YIELD preProcessingMillis, computeMillis, writeMillis, effectiveNodeCount
RETURN preProcessingMillis, computeMillis, writeMillis, effectiveNodeCount;

//5
//DEPTH FIRST SEARCH
//ARBOLITO
//LE ESPECIFICAS EL NIVEL DE PROFUNDIDAD
//GRAFO DIRIGIDO
MATCH (source:Villian{Name:'Viper'})
CALL gds.dfs.stream('myDirectedGraph',{
  sourceNode: source,
  maxDepth: 1
})
YIELD path
RETURN path

//2
MATCH (source:Villian{Name:'Viper'})
CALL gds.dfs.stream('myDirectedGraph',{
  sourceNode: source,
  maxDepth: 2
})
YIELD path
RETURN path

//3
MATCH (source:Villian{Name:'Viper'})
CALL gds.dfs.stream('myDirectedGraph',{
  sourceNode: source,
  maxDepth: 3
})
YIELD path
RETURN path

//Braniac
MATCH(source:Villian{Name:'Braniac'})
CALL gds.beta.spanningTree.write
(

  'myUndirectedGraph', {
    sourceNode: id(source),
    relationshipWeightProperty: 'Weight',
    writeProperty: 'writeCost',
    writeRelationshipType: 'BRANIAC'
  }
)

YIELD preProcessingMillis, computeMillis, writeMillis, effectiveNodeCount
RETURN preProcessingMillis, computeMillis, writeMillis, effectiveNodeCount;

//1
MATCH (source:Villian{Name:'Braniac'})
CALL gds.dfs.stream('myDirectedGraph',{
  sourceNode: source,
  maxDepth: 1
})
YIELD path
RETURN path
//2
MATCH (source:Villian{Name:'Braniac'})
CALL gds.dfs.stream('myDirectedGraph',{
  sourceNode: source,
  maxDepth: 2
})
YIELD path
RETURN path
//2nd
MATCH (source:Villian{Name:'Braniac'})
CALL gds.dfs.stream('myUndirectedGraph',{
  sourceNode: source,
  maxDepth: 2
})
YIELD path
RETURN path
//3
MATCH (source:Villian{Name:'Braniac'})
CALL gds.dfs.stream('myDirectedGraph',{
  sourceNode: source,
  maxDepth: 3
})
YIELD path
RETURN path



//joker
MATCH (source:Villian{Name:$Villian})
CALL gds.dfs.stream('myDirectedGraph',{
  sourceNode: source,
  maxDepth: 1
})
YIELD path
RETURN path

//Distancias
// 1. Obtener distancia entre los nodos 'Guadalajara' y 'Puerto Vallarta'
MATCH (a1:Airport{Label:'Guadalajara'})-[:ENLACE]->(a2:Airport{Label:'Puerto Vallarta'})
WITH
  point({longitude: a1.longitude, latitude: a1.latitude}) AS aeropuertoGuadalajara,
  point({longitude: a2.longitude, latitude: a2.latitude}) AS aeropuertoPuertoVallarta
RETURN round(point.distance(aeropuertoGuadalajara, aeropuertoPuertoVallarta)) AS travelDistance

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