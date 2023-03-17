DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS friendOf;
DROP TABLE IF EXISTS knows;
DROP TABLE IF EXISTS likes;


CREATE TABLE person(
    person_id INT NOT NULL,
    person_name VARCHAR
);

CREATE TABLE friendOf(
    person_id INT NOT NULL,
    friend_id INT
);

CREATE TABLE knows(
    person_id INT NOT NULL,
    known_id INT NOT NULL
);

CREATE TABLE likes(
    person_id INT NOT NULL,
    liked_id INT NOT NULL
);

INSERT INTO person(
    person_id ,
    person_name
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
    (20, 'Kevin Rampling'),
    (21,    'Ron Smith'),
    (22,    'John Davis'),
    (23,    'Dave Johnson'),
    (24,    'David Stark'),
    (25,    'Gomes Till'),
    (26,    'Smith Smith'),
    (27,    'Silvia Gomez'),
    (28,    'Clad Mark'),
    (29,    'Jonathan Todd'),
    (30,    'Edward Tony'),
    (31,    'Edard Stark'),
    (32,    'Sansa Stark'),
    (33,    'Clark Smoll'),
    (34,    'Bruys Wayne'),
    (35,    'Nicol Kirp'),
    (36,    'Robin Tart');

INSERT INTO friendOf(
    person_id,
    friend_id
)   
VALUES
    (1,2),
    (2,3),
    (3,4),
    (4,5),
    (5,6),
    (6,7),
    (7,8),
    (8,9),
    (9,10),
    (10,11);

INSERT INTO knows(
    person_id,
    known_id
)
VALUES
    (1,12),
    (2,13),
    (3,14),
    (4,15),
    (5,16),
    (6,17),
    (7,18),
    (8,19),
    (9,20),
    (10,21),
    (12,22),
    (22,23),
    (23,24),
    (13,25),
    (25,26),
    (14,27),
    (15,28);


--ONE WAY TO DO NRE
WITH RECURSIVE cte_nre AS (

	SELECT 	fo.person_id,
			fo.friend_id,
			k.known_id
  	  FROM 	friendOf 	AS 	fo
	  JOIN	knows	 	AS 	k ON fo.person_id = k.person_id
	 WHERE	fo.person_id = 3
	 UNION
	SELECT  fo.person_id,
			fo.friend_id,
			k.known_id 
	  FROM	friendOf 	AS  fo
	  JOIN	knows	 	AS	k	ON fo.person_id = k.person_id 
	  JOIN  cte_nre  	AS  c	ON c.friend_id = fo.person_id
)

SELECT * FROM cte_nre;

--ANOTHER WAY

WITH RECURSIVE cte_nre AS (

	SELECT 	fo.person_id,
			fo.friend_id
  	  FROM 	friendOf 	AS 	fo
	 WHERE	fo.person_id = 3 
	   AND	EXISTS (SELECT 1 FROM knows AS k WHERE k.person_id = fo.person_id)
	 UNION
	SELECT  fo.person_id,
			fo.friend_id 
	  FROM	friendOf 	AS  fo
	  JOIN  cte_nre  	AS  c	ON c.friend_id = fo.person_id
	 WHERE	EXISTS (SELECT 1 FROM knows AS k WHERE k.person_id = fo.person_id)
)

SELECT * FROM cte_nre;

--JUST TO CALCULATE THE KNOWS+ RELATIONSHIP
WITH RECURSIVE cte_knows AS (
	SELECT k.person_id,
		   k.known_id
	  FROM knows AS k
	 WHERE k.person_id = 11
	 UNION
	SELECT k.person_id,
		   k.known_id
	  FROM knows 	 AS k
	  JOIN cte_knows AS c1 ON c1.known_id = k.person_id

)

SELECT * FROM cte_knows;


--NESTED (a[b+])+


WITH RECURSIVE 
cte_knows AS (
	SELECT k.person_id,
		   k.known_id
	  FROM knows AS k
-- 	 WHERE k.person_id = 22
	 UNION
	SELECT k.person_id,
		   k.known_id
	  FROM knows 	 AS k
	  JOIN cte_knows AS c1 ON c1.known_id = k.person_id

),
cte_nre AS (

	SELECT 	fo.person_id,
			fo.friend_id
  	  FROM 	friendOf 	AS 	fo
	 WHERE	fo.person_id = 10 
	   AND	EXISTS (SELECT 1 FROM cte_knows AS inc WHERE fo.person_id = inc.person_id)
	 UNION
	SELECT  fo.person_id,
			fo.friend_id 
	  FROM	friendOf 	AS  fo
	  JOIN  cte_nre  	AS  c	ON c.friend_id = fo.person_id
	 WHERE	EXISTS (SELECT 1 FROM cte_knows inc WHERE fo.person_id = inc.person_id)
)

SELECT * FROM cte_nre;

--ANOTHER WAY TO DO (a[b]+)+
WITH RECURSIVE 
cte_knows AS (
	SELECT k.person_id,
		   k.known_id
	  FROM knows AS k
-- 	 WHERE k.person_id = 22
	 UNION
	SELECT k.person_id,
		   k.known_id
	  FROM knows 	 AS k
	  JOIN cte_knows AS c1 ON c1.known_id = k.person_id

),
cte_nre AS (

	SELECT 	fo.person_id,
			fo.friend_id
  	  FROM 	friendOf 	AS 	fo
	  JOIN  cte_knows	AS  cte ON cte.person_id = fo.person_id
	 WHERE	fo.person_id = 1 
	   
	 UNION
	SELECT  fo.person_id,
			fo.friend_id 
	  FROM	friendOf 	AS  fo
	  JOIN  cte_knows	AS  cte ON cte.person_id = fo.person_id
	  JOIN  cte_nre  	AS  c	ON c.friend_id = fo.person_id
)

SELECT * FROM cte_nre;

