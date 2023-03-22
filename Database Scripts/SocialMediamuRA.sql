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
    (36,    'Robin Tart'),
    (38,    'Eric Clapton'),
    (39,    'Jim Morrison'),
    (40,    'Haliey Barrey');

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
    (10,11),
    (11,12),
    (12,13),
    (13,14),
    (14,15);

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
    (11,29),
    (12,22),
    (22,23),
    (23,24),
    (13,25),
    (25,26),
    (14,27),
    (15,28);

INSERT INTO likes(
    person_id,
    liked_id
)    
VALUES
    (12,2),
    (13,3),
    (14,4)
    (15,5),
    (16,6),
    (11,31),
    (12,32),
    (13,33),
    (14,34),
    (17,35),
    (18,36),
    (19,37),
    (20,38),
    (21,39),
    (22,40);



--RECURSIVE QUERIES
/*THE FOLLOWING QUERY IS AN EXAMPLE OF (friendOf.[knows+])+
 THIS IS DONE BY ONLY USING NATURAL JOINS LIKE THE ONES DONE FOR muRA
*/

-- DROP VIEW trv_friend_of;
-- DROP VIEW trv_knows;

CREATE OR REPLACE TEMPORARY RECURSIVE VIEW trv_knows (person_id, known_id) AS
	SELECT f.person_id AS source, f.known_id AS conn
	  FROM knows AS f

	 UNION 
	
    SELECT f.conn AS conn, f.known_id
	  FROM (SELECT f.person_id AS conn, f.known_id  FROM knows AS f) AS f
   NATURAL
	  JOIN trv_knows; 

CREATE OR REPLACE TEMPORARY RECURSIVE VIEW trv_friend_of (person_name ,person_id, friend_id, known_id) AS
	SELECT  t.person_name, f.source, f.friend_id AS conn, k.known_id
	  FROM (SELECT person_id AS source, friend_id FROM friendOf) AS f
   NATURAL
      JOIN (SELECT person_id AS source, person_name FROM person ) AS t 
   NATURAL
      JOIN (SELECT person_id AS source, known_id FROM trv_knows) AS k
      
	 UNION
	
	SELECT  pr.person_name, f.conn AS conn, f.friend_id, k.known_id
	  FROM (SELECT person_id AS conn, friend_id  FROM friendOf) AS f
   NATURAL
	  JOIN (SELECT person_id AS conn, person_name FROM person) AS pr
   NATURAL
      JOIN (SELECT person_id AS conn, known_id FROM trv_knows) AS k
   NATURAL
	  JOIN trv_friend_of; 


SELECT * FROM trv_friend_of;  


/*

THIS IS AN ALTERNATIVE APPROACH TO FORMULATE (a.[b+])+
*/

-- DROP VIEW trv_friend_of;
-- DROP VIEW trv_knows;


CREATE OR REPLACE TEMPORARY RECURSIVE VIEW trv_knows (person_id, known_id) AS

	SELECT k.person_id, k.known_id
	  FROM knows AS k
	  
	 UNION 
	
	SELECT k.person_id, k.known_id
	  FROM trv_knows 	AS t
	  JOIN knows		AS k	ON t.known_id = k.person_id;
	  
CREATE OR REPLACE TEMPORARY RECURSIVE VIEW trv_friend_of (person_name, person_id, friend_id, known_id) AS
	
	SELECT p.person_name, f.person_id, f.friend_id, k.known_id
	  FROM friendOf 	AS f
	  JOIN person		AS p	ON f.person_id = p.person_id
	  JOIN trv_knows	AS k	ON f.person_id = k.person_id
-- 	 WHERE f.person_id = 1  
	 
     UNION
	 
	SELECT p.person_name, f.person_id, f.friend_id, k.known_id
	  FROM trv_friend_of	AS t
	  JOIN friendOf			AS f	ON t.friend_id = f.person_id
	  JOIN person			AS p	ON f.person_id = p.person_id
	  JOIN trv_knows		AS k	ON f.person_id = k.person_id;



-- SELECT * FROM trv_knows;
SELECT * FROM trv_friend_of;

/*
    I AM UNABLE TO ENFORCE FILTERS BASED ON THE NATURAL JOIN APPROACH I TRIED THE mu RA SOLUTION
    BUT THIS STILL DOES NOT WORKS.
*/

CREATE OR REPLACE TEMPORARY RECURSIVE VIEW trv_knows (person_id, known_id) AS
	SELECT f.person_id AS source, f.known_id AS conn
	  FROM knows AS f

	 UNION 
	
    SELECT f.conn AS conn, f.known_id
	  FROM (SELECT f.person_id AS conn, f.known_id  FROM knows AS f) AS f
   NATURAL
	  JOIN trv_knows; 

CREATE OR REPLACE TEMPORARY RECURSIVE VIEW trv_friend_of (person_name ,person_id, friend_id, known_id) AS
	SELECT  t.person_name, f.source, f.friend_id AS conn, k.known_id
	  FROM (SELECT person_id AS source, friend_id FROM friendOf) AS f
   NATURAL
      JOIN (SELECT source, person_name 
  			  FROM (SELECT * 
		              FROM (SELECT person_id AS source, person_name 
				              FROM person
			   			   ) AS t
					 WHERE t.person_name = 'Michael North'
	   			   ) AS t2 
		   ) AS t 
   NATURAL
      JOIN (SELECT person_id AS source, known_id FROM trv_knows) AS k
      
	 UNION
	
	SELECT  pr.person_name, f.conn AS conn, f.friend_id, k.known_id
	  FROM (SELECT person_id AS conn, friend_id  FROM friendOf) AS f
   NATURAL
	  JOIN (SELECT person_id AS conn, person_name FROM person) AS pr
   NATURAL
      JOIN (SELECT person_id AS conn, known_id FROM trv_knows) AS k
   NATURAL
	  JOIN trv_friend_of; 


SELECT * FROM trv_friend_of;  

/*THIS IS JUST A WAY TO SPECIFY THE FILTERS IN THE NATURAL JOIN APPROACH*/
SELECT source, person_name 
  FROM (SELECT * 
		  FROM (SELECT person_id AS source, person_name 
				  FROM person
			   ) AS t
		WHERE t.person_name = 'Michael North'
	   ) AS t2