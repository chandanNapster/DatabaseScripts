LOAD CSV WITH HEADERS FROM "file:///routes.csv" AS row
RETURN row


--THE CYPHER SCRIPT TO CREATE VARIOUS CITY NODES

LOAD CSV WITH HEADERS FROM "file:///cities.csv" AS row
WITH row.city_id AS city_id,
     row.city_name AS city_name
CREATE (city:CITY{city_id:toInteger(city_id), city_name:city_name}) 

--THE CYPHER SCRIPT TO CREATE VARIOUS ROUTES
LOAD CSV WITH HEADERS FROM "file:///routes.csv" AS row
WITH toInteger(row.src_id) AS src_id,
     toInteger(row.trg_id) AS trg_id,
     row.pilot_name AS pilot_name
MATCH (s:CITY), (t:CITY)
WHERE s.city_id = src_id
  AND t.city_id = trg_id
CREATE (s)-[:HAS_FLIGHT_TO{pilot_name:pilot_name}]->(t)  

--A VERY BASIC QUERY
MATCH (a)-[:HAS_FLIGHT_TO*]->(b) 
WHERE a.city_id = 15 
RETURN *


/*
THIS IS THE SCRIPT TO LOAD FRIEND OF AND KNOWS GDB
*/

-- CREATE PILOT NODES WITH PROP.
LOAD CSV WITH HEADERS FROM "file:///pilot.csv" AS row
WITH toInteger(row.pilot_id) AS pilot_id,
    row.pilot_name AS pilot_name
CREATE (p:PILOT{pilot_id:pilot_id, pilot_name:pilot_name})

--CREATE PASSENGER NODES WITH PROP.
LOAD CSV WITH HEADERS FROM "file:///passenger.csv" AS row
WITH toInteger(row.passenger_id) AS pass_id,
    row.passenger_name AS pass_name
CREATE (pass:PASSENGER{passenger_id:pass_id, passenger_name:pass_name})

--CREATE THE EDGE FRIEND OF BETWEEN PILOTS

LOAD CSV WITH HEADERS FROM "file:///isfriendof.csv" AS row
WITH toInteger(row.pilot_id) AS pilot_id,
    toInteger(row.friend_id) AS friend_id
MATCH (p:PILOT), (f:PILOT)
WHERE p.pilot_id = pilot_id
AND   f.pilot_id = friend_id
CREATE (p)-[:IS_FRIEND_OF]->(f)

--CREATE THE EDGE KNOWS BETWEEN PILOTS AND PASSENGERS
LOAD CSV WITH HEADERS FROM "file:///knows.csv" AS row
WITH toInteger(row.pilot_id) AS pilot_id,
    toInteger(row.passenger_id) AS pass_id
MATCH (p:PILOT), (pa:PASSENGER)
WHERE p.pilot_id = pilot_id
  AND pa.passenger_id = pass_id
CREATE (p)-[:KNOWS]->(pa)  