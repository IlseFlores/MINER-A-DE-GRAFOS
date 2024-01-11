CREATE 
    (brasil:Country {name:'Brasil'}),
    (argentina:Country {name:'Argentina'}),
    (venezuela:Country {name:'Venezuela'}),
    (colombia:Country {name:'Colombia'}),
    (guyana:Country {name:'Guyana'}),
    (surinam:Country {name:'Surinam'}),
    (guiana:Country {name:'GuyanaFrancesa'}),
    (ecuador:Country {name:'Ecuador'}),
    (peru:Country {name:'Perú'}),
    (bolivia:Country {name:'Bolivia'}),
    (paraguay:Country {name:'Paraguay'}),
    (chile:Country {name:'Chile'}),
    (urugay:Country {name:'Uruguay'}),
            (argentina)-[:COLINDA_CON]->(chile),
            (argentina)-[:COLINDA_CON]->(bolivia),
            (argentina)-[:COLINDA_CON]->(paraguay),
            (argentina)-[:COLINDA_CON]->(uruguay),
            (argentina)-[:COLINDA_CON]->(brasil),
            (bolivia)-[:COLINDA_CON]->(peru),
            (bolivia)-[:COLINDA_CON]->(brasil),
            (bolivia)-[:COLINDA_CON]->(paraguay),
            (bolivia)-[:COLINDA_CON]->(chile),
            (bolivia)-[:COLINDA_CON]->(argentina),
            (brasil)-[:COLINDA_CON]->(uruguay),
            (brasil)-[:COLINDA_CON]->(argentina),
            (brasil)-[:COLINDA_CON]->(paraguay),
            (brasil)-[:COLINDA_CON]->(bolivia),
            (brasil)-[:COLINDA_CON]->(peru),
            (brasil)-[:COLINDA_CON]->(colombia),
            (brasil)-[:COLINDA_CON]->(venezuela),
            (brasil)-[:COLINDA_CON]->(guyana),
            (brasil)-[:COLINDA_CON]->(surinam),
            (brasil)-[:COLINDA_CON]->(guiana),
            (chile)-[:COLINDA_CON]->(argentina),
            (chile)-[:COLINDA_CON]->(bolivia),
            (chile)-[:COLINDA_CON]->(peru),
            (colombia)-[:COLINDA_CON]->(ecuador),
            (colombia)-[:COLINDA_CON]->(peru),
            (colombia)-[:COLINDA_CON]->(brasil),
            (colombia)-[:COLINDA_CON]->(venezuela),
            (ecuador)-[:COLINDA_CON]->(colombia),
            (ecuador)-[:COLINDA_CON]->(peru),
            (guyana)-[:COLINDA_CON]->(venezuela),
            (guyana)-[:COLINDA_CON]->(brasil),
            (guyana)-[:COLINDA_CON]->(surinam),
            (paraguay)-[:COLINDA_CON]->(brasil),
            (paraguay)-[:COLINDA_CON]->(bolivia),
            (paraguay)-[:COLINDA_CON]->(argentina),
            (peru)-[:COLINDA_CON]->(chile),
            (peru)-[:COLINDA_CON]->(bolivia),
            (peru)-[:COLINDA_CON]->(brasil),
            (peru)-[:COLINDA_CON]->(colombia),
            (peru)-[:COLINDA_CON]->(ecuador),
            (surinam)-[:COLINDA_CON]->(guyana),
            (surinam)-[:COLINDA_CON]->(guiana),
            (surinam)-[:COLINDA_CON]->(brasil),
            (urugay)-[:COLINDA_CON]->(brasil),
            (urugay)-[:COLINDA_CON]->(argentina),
            (venezuela)-[:COLINDA_CON]->(colombia),
            (venezuela)-[:COLINDA_CON]->(brasil),
            (venezuela)-[:COLINDA_CON]->(guyana),
            (guiana)-[:COLINDA_CON]->(surinam),
            (guiana)-[:COLINDA_CON]->(brasil);
        

        

        


   


       call db.schema.visualization

       match (n) return n 

     CALL gds.graph.project(
    'myGraph',
    'Country',
    {
        COLINDA_CON : {
            orientation: 'UNDIRECTED'
        }
    }
)

CALL gds.beta.k1coloring.stream('myGraph')
YIELD nodeId, color
RETURN gds.util.asNode(nodeId).name AS name, color
ORDER BY name



CALL gds.beta.k1coloring.write('myGraph', {writeProperty: 'color'})
YIELD nodeCount, colorCount, ranIterations, didConverge

CALL gds.beta.k1coloring.mutate('myGraph', {mutateProperty: 'color'})
YIELD nodeCount, colorCount, ranIterations, didConverge

CALL gds.beta.k1coloring.stats('myGraph')
YIELD nodeCount, colorCount, ranIterations, didConverge













