-- Database: Chandan

-- DROP DATABASE IF EXISTS "Chandan";

DROP TABLE IF EXISTS routes;

CREATE TABLE routes (
	src_id INT NOT NULL, --THE SOURCE CANNOT BE NULL
	pilot_name VARCHAR NOT NULL,
	trg_id INT
);

INSERT INTO routes (
	src_id,
	pilot_name,
	trg_id
)
VALUES
	(1, 'Michael North', 20),
	(2, 'Megan Berry', 1),
	(3, 'Sarah Berry', 1),
	(4, 'Zoe Black', 1),
	(5, 'Tim James', 1),
	(6, 'Bella Tucker', 2),
	(7, 'Ryan Metcalfe', 2),
	(8, 'Max Mills', 2),
	(9, 'Benjamin Glover', 2),
	(10, 'Carolyn Henderson', 3),
	(11, 'Nicola Kelly', 3),
	(12, 'Alexandra Climo', 3),
	(13, 'Dominic King', 3),
	(14, 'Leonard Gray', 4),
	(15, 'Eric Rampling', 4),
	(16, 'Piers Paige', 7),
	(17, 'Ryan Henderson', 7),
	(18, 'Frank Tucker', 8),
	(19, 'Nathan Ferguson', 8),
	(20, 'Kevin Rampling', 8);
	
DROP TABLE IF EXISTS cities;	

CREATE TABLE cities(
	city_id INT NOT NULL,
	city_name VARCHAR
);

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

SELECT * FROM cities LIMIT 10;

SELECT * FROM routes LIMIT 10;	

SELECT c1.city_name AS "Source-City", 
	   r1.pilot_name AS "Pilot-Name",
	   c2.city_name AS "Destination-City"
  FROM cities AS c1
  JOIN routes AS r1 ON c1.city_id = r1.src_id 
  JOIN cities AS c2 ON c2.city_id = r1.trg_id
 LIMIT 10



--START OF ALL THE RECURSIVE QUERIES WRITTEN	

WITH RECURSIVE cte_emp AS (
	SELECT  r.src_id,
			r.trg_id, 
			c1.city_name AS source, 
			c2.city_name AS target
	  FROM routes AS r
	  JOIN cities AS c1 ON r.src_id = c1.city_id
	  JOIN cities AS c2 ON r.trg_id = c2.city_id
	 WHERE r.src_id = 15
	 UNION
	SELECT  r.src_id, 
			r.trg_id, 
			c1.city_name, 
			c2.city_name
	  FROM cte_emp AS cte
	  JOIN routes  AS r   ON cte.trg_id = r.src_id
	  JOIN cities  AS c1  ON r.src_id = c1.city_id
	  JOIN cities  AS c2  ON r.trg_id = c2.city_id
-- 	WHERE lvl < 8
)

SELECT * FROM cte_emp;    

--CTE JOINED WITH ANOTHER CTE

WITH RECURSIVE cte_num AS (
	SELECT 1 AS lvl
	UNION 
	SELECT cte.lvl + 1 AS lvl
	  FROM cte_num AS cte
	 WHERE cte.lvl < 20
),
	cte_emp AS (
	SELECT  r.src_id,
			r.trg_id, 
			c1.city_name AS source, 
			c2.city_name AS target
	  FROM routes AS r
	  JOIN cities AS c1 ON r.src_id = c1.city_id
	  JOIN cities AS c2 ON r.trg_id = c2.city_id
	  JOIN cte_num AS cte2 ON cte2.lvl = r.src_id
	 WHERE r.src_id = 15
	 UNION
	SELECT  r.src_id, 
			r.trg_id, 
			c1.city_name, 
			c2.city_name
	  FROM cte_emp AS cte
	  JOIN routes  AS r   ON cte.trg_id = r.src_id
	  JOIN cities  AS c1  ON r.src_id = c1.city_id
	  JOIN cities  AS c2  ON r.trg_id = c2.city_id
	  JOIN cte_num AS cte2 ON cte2.lvl = r.src_id
-- 	WHERE lvl < 8
)

SELECT * FROM cte_emp;

--A RECURSIVE QUERY WITH ANTI JOINS

WITH RECURSIVE 
cte_num AS (
	SELECT 1 AS lvl
	 UNION 
	SELECT cte.lvl + 1 AS lvl
	  FROM cte_num AS cte
	 WHERE cte.lvl < 20
),
cte_emp AS (
	SELECT  r.src_id,
			r.trg_id, 
			c1.city_name AS source, 
			c2.city_name AS target,
            cte2.lvl     AS LEVELS
	  FROM routes AS r
	  JOIN cities AS c1    ON r.src_id = c1.city_id
	  JOIN cities AS c2    ON r.trg_id = c2.city_id
	  JOIN cte_num AS cte2 ON cte2.lvl = r.src_id
	 WHERE NOT EXISTS (SELECT * 
					     FROM cities AS c3 
					    WHERE c3.city_id IN (15,12,13,10,20,11,8,1,5) 
                          AND c1.city_id = c3.city_id)
	 UNION
	SELECT  r.src_id, 
			r.trg_id, 
			c1.city_name AS source, 
			c2.city_name AS target,
            cte2.lvl     AS LEVELS
	  FROM cte_emp AS cte
	  JOIN routes  AS r    ON cte.trg_id = r.src_id
	  JOIN cities  AS c1   ON r.src_id = c1.city_id
	  JOIN cities  AS c2   ON r.trg_id = c2.city_id
	  JOIN cte_num AS cte2 ON cte2.lvl = r.src_id
	 WHERE NOT EXISTS (SELECT * 
					     FROM cities AS c3 
					    WHERE c3.city_id IN (15,12,13,10,20,11,8,1,5) 
                          AND c1.city_id = c3.city_id)
)

SELECT * FROM cte_emp;

--URL DETAILING THE LIMITATIONS OF RECURSION
--A RECURSION VARIABLE CANNOT BE USED MORE THAN ONCE IN THE RECURSIVE PART OF THE QUERY
--https://docs.teradata.com/r/V0f5TNULG3KyqagJFs3fJA/iNX9KP9RrA~ZjubBH852Ow


--10 FEBURARY 2023
--RECURSIVE QUERIES WRITTEN

--THIS QUERY IS JUST A VERY BASIC RECURSIVE QUERY
WITH RECURSIVE cte_num AS (
	SELECT 1 AS n
	UNION
	SELECT cte.n + 1 AS n
	FROM cte_num AS cte
	WHERE n < 10
)

SELECT * FROM cte_num;


--THE MAIN THING TO UNDERSTAND IN THIS QUERY IS THAT IN THE RECURSIVE PARTS THE COLUMNS MUST COME FOR THE ROUTES RELATION
-- AND NOT FROM THE cte	RELATION 
WITH RECURSIVE cte_routes AS (
	SELECT r.src_id, r.trg_id  
	  FROM routes AS r
	 WHERE r.src_id = 15
	 UNION
	SELECT r.src_id, r.trg_id
	  FROM cte_routes AS cte
	  JOIN routes     AS r   ON cte.trg_id = r.src_id
)

SELECT * FROM cte_routes;

--ANOTHER WAY TO EXPRESS THE RECURSIVE QUERY
--IN THIS QUERY I AM USING THE TARGET CITY NAME AS THE COLUMN FOR RECURSION

WITH RECURSIVE cte_routes AS (
	SELECT c1.city_name AS source_city, c2.city_name AS target_city  
	  FROM routes AS r
	  JOIN cities AS c1 ON r.src_id = c1.city_id
	  JOIN cities AS c2 ON r.trg_id = c2.city_id
	 WHERE r.src_id = 15
	    OR r.src_id = 10
	 UNION
	SELECT c1.city_name, c2.city_name
	  FROM cities      AS c1
	  JOIN routes      AS r    ON r.src_id = c1.city_id
	  JOIN cities      AS c2   ON r.trg_id = c2.city_id	
	  JOIN cte_routes  AS cte  ON cte.target_city = c1.city_name
)

SELECT * FROM cte_routes;

--ANOTHER WAY TO WRITE A QUERY

WITH RECURSIVE cte_routes AS (
	SELECT c1.city_name AS source_city, c2.city_name AS target_city  
	  FROM routes AS r
	  JOIN cities AS c1 ON r.src_id = c1.city_id
	  JOIN cities AS c2 ON r.trg_id = c2.city_id
	 WHERE c1.city_id = 10 
	    OR c1.city_id = 15
	 UNION
	SELECT c1.city_name, c2.city_name
	  FROM cities      AS c1
	  JOIN routes      AS r    ON r.src_id = c1.city_id
	  JOIN cities      AS c2   ON r.trg_id = c2.city_id	
	  JOIN cte_routes  AS cte  ON cte.target_city = c1.city_name
)

SELECT * FROM cte_routes;