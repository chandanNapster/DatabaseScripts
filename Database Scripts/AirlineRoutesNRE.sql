-- Database: Chandan

-- DROP DATABASE IF EXISTS "Chandan";

DROP TABLE IF EXISTS routes;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS pilot;
DROP TABLE IF EXISTS isFriendOf;
DROP TABLE IF EXISTS passenger;
DROP TABLE IF EXISTS knows;

CREATE TABLE routes (
	src_id INT NOT NULL, --THE SOURCE CANNOT BE NULL
	pilot_id INT NOT NULL,
	trg_id INT,
    home_city_id INT NOT NULL 
);

CREATE TABLE pilot(
    pilot_id INT NOT NULL,
    pilot_name VARCHAR NOT NULL
);

	
CREATE TABLE cities(
	city_id INT NOT NULL,
	city_name VARCHAR
);

CREATE TABLE isFriendOf(
    pilot_id INT NOT NULL,
    friend_id INT
);

CREATE TABLE passenger (
    passenger_name VARCHAR NOT NULL,
    passenger_id INT NOT NULL
);

CREATE TABLE knows(
    pilot_id INT NOT NULL,
    passenger_id INT NOT NULL
);

INSERT INTO passenger(
    passenger_name,
    passenger_id
)
VALUES 
    ('Ron', 1),
    ('John', 2),
    ('Dave', 3),
    ('David', 4),
    ('Gomes', 5),
    ('Smith', 6),
    ('Silvia', 7),
    ('Clad', 8),
    ('Jonathan', 9),
    ('Edward', 10),
    ('Edard', 11),
    ('Sansa', 12),
    ('Clark', 13),
    ('Bruys',14),
    ('Nicol', 15),
    ('Robin',16);

INSERT INTO knows(
    pilot_id,
    passenger_id
)
VALUES
    (1,1),
    (1,2),
    (2,3),
    (3,4),
    (4,6),
    (5,6),
    (6,7),
    (7,8),
    (8,6),
    (9,4),
    (10,5),
    (11,7),
    (13,12),
    (14,15);

INSERT INTO isFriendOf(
    pilot_id,
    friend_id
)
VALUES 
    (1,20),
    (2,3),
    (4,5),
    (1,3),
    (3,2),
    (4,6),
    (6,9),
    (9,10),
    (10,12),
    (12,13),
    (13,15),
    (15,20),
    (10,1),
    (19,9),
    (20,2),
    (9,12),
    (9,13),
    (9,1);

INSERT INTO routes (
	src_id,
	pilot_id,
	trg_id,
    home_city_id 
)
VALUES
	(1, 1 , 20, 3),
	(2, 2, 1, 4),
	(3, 3, 1, 5),
	(4, 4, 1, 20),
	(5, 5, 1, 19),
	(6, 6, 2, 17),
	(7, 7, 2, 16),
	(8, 8, 2, 11),
	(9, 9, 2, 13),
	(10, 10, 3, 12),
	(11, 11, 3, 12),
	(12, 12, 3, 3),
	(13, 13, 3, 4),
	(14, 14, 4, 5),
	(15, 15, 4, 6),
	(16, 16, 7, 7),
	(17, 17, 7, 8),
	(18, 18, 8, 9),
	(19, 19, 8, 10),
	(20, 20, 8, 11);



INSERT INTO pilot(
    pilot_id,
    pilot_name
)
VALUES
    (1, 'Michael North' ),
    (2, 'Megan Berry'),
    (3, 'Sarah Berry'),
    (4, 'Zoe Black'),
    (5, 'Tim James'),
    (6, 'Bella Tucker'),
    (7, 'Ryan Metcalfe'),
    (8, 'Max Mills'),
    (9, 'Benjamin Glover'),
    (10, 'Carolyn Henderson'),
    (11, 'Nicola Kelly'),
    (12, 'Alexandra Climo'),
    (13, 'Dominic King'),
    (14, 'Leonard Gray'),
    (15, 'Eric Rampling'),
    (16, 'Piers Paige'),
    (17, 'Ryan Henderson'),
    (18, 'Frank Tucker'),
    (19, 'Nathan Ferguson'),
    (20, 'Kevin Rampling');



INSERT INTO cities(
	city_id,
	city_name
)
VALUES
	(1, 'Nice'),
	(2, 'Grenoble'),
	(3, 'Paris'),
	(4, 'Rome'),
	(5, 'Berlin'),
	(6, 'Amsterdam'),
	(7, 'London'),
	(8, 'Munich'),
	(9, 'Delhi'),
	(10, 'Bangalore'),
	(11, 'Pune'),
	(12, 'Auckland'),
	(13, 'Wellington'),
	(14, 'Dunedin'),
	(15, 'Christchurch'),
	(16, 'Sophia'),
	(17, 'Henderson'),
	(18, 'New York'),
	(19, 'Hamilton'),
	(20, 'Jaipur');

--SIMPLE DATA EXTRACTION QUERY    
SELECT c1.city_name AS "Source-City", 
	   r1.pilot_id,
	   c2.city_name AS "Destination-City"
  FROM cities AS c1
  JOIN routes AS r1 ON c1.city_id = r1.src_id 
  JOIN cities AS c2 ON c2.city_id = r1.trg_id
 LIMIT 10


--SIMPLE QUERY
SELECT 	src.city_name, 
		p.pilot_name, 
		trg.city_name, 
		r.home_city_id, 
		hme.city_name AS "Pilot-Home" 
  FROM cities AS src
  JOIN routes AS r		ON src.city_id = r.src_id 
  JOIN cities AS trg	ON trg.city_id = r.trg_id
  JOIN cities AS hme	ON r.home_city_id = hme.city_id
  JOIN pilot  AS p		ON r.pilot_id = p.pilot_id

--START OF ALL THE RECURSIVE QUERIES WRITTEN	

WITH RECURSIVE cte_nre AS (

	SELECT 	src.city_name AS src_city, 
			r.pilot_name, 
			trg.city_name AS trg_city, 
			r.home_city_id
  	  FROM 	cities AS src
  	  JOIN	routes AS r		ON src.city_id = r.src_id 
  	  JOIN 	cities AS trg	ON trg.city_id = r.trg_id
  	 WHERE 	src.city_id = 15
	 UNION
	SELECT 	src.city_name, 
			r.pilot_name, 
			trg.city_name, 
			r.home_city_id
  	  FROM 	cities AS src
  	  JOIN	routes AS r		ON src.city_id = r.src_id 
  	  JOIN 	cities AS trg	ON trg.city_id = r.trg_id
	  JOIN  cte_nre AS cn	ON cn.trg_city = src.city_name
)

SELECT * FROM cte_nre;

--IS FRIEND OF RELATIONSHIP
WITH RECURSIVE cte_nre AS (
	SELECT 	ifo.pilot_id,
			ifo.friend_id
  	  FROM 	isFriendOf	AS ifo
	 WHERE  ifo.pilot_id = 1
	 UNION
	SELECT  ifo.pilot_id,
			ifo.friend_id
  	  FROM 	isFriendOf	AS ifo
	  JOIN  cte_nre 	AS c1 ON c1.friend_id = ifo.pilot_id
	
)

SELECT * FROM cte_nre;



SELECT 	ifo.pilot_id,
		ifo.friend_id
  FROM isFriendOf	AS ifo


--BRANCHED QUERY
WITH RECURSIVE cte_nre AS (
	SELECT 	ifo.pilot_id,
			ifo.friend_id,
			k.passenger_id,
			k.pilot_id
  	  FROM 	isFriendOf	AS ifo									--(x)-[:isFriendOf]->(y)
	  JOIN 	knows		AS k	ON ifo.pilot_id = k.pilot_id    --(x)-[:knows]->(z)
	 WHERE  ifo.pilot_id = 1
	 UNION
	SELECT  ifo.pilot_id,
			ifo.friend_id,
			k.passenger_id,
			k.pilot_id
  	  FROM 	isFriendOf	AS ifo
	  JOIN 	knows		AS k	ON ifo.pilot_id = k.pilot_id
	  JOIN  cte_nre 	AS c1 	ON c1.friend_id = ifo.pilot_id
)

SELECT * FROM cte_nre;  

--SIMPLE DATA EXTRACTION QUERIES
Select * from isFriendOf;
Select * from knows;
Select * from pilot;
Select * from passenger;