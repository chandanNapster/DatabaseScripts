DROP view pg_temp_8.fixpoint_trv_friend_of;
DROP view pg_temp_8.trv_knows;
DROP view fixpoint_trv_friend_of;
DROP view trv_knows;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS friendOf;
DROP TABLE IF EXISTS knows;
DROP TABLE IF EXISTS likes;

-- TRUNCATE TABLE friendOf;


/*
----------CREATE THE friend TABLE------------------
THIS TABLE IS JUST USED TO CREATE A SERIES OF VALUES
*/
CREATE TABLE person (
	person_id SERIAL,
	salary FLOAT
);

INSERT INTO person(
	salary
)
SELECT trg
  FROM (SELECT 5000 * random() AS trg 
		  FROM generate_series(1,10000000)) AS t;
		  
-- SELECT * FROM person;		  
  
/*
THIS TABLE IS USED TO CREATE THE friendOf TABLE
*/  

CREATE TABLE friendOf (
	person_id INT,
	friend_id INT
);

INSERT INTO friendOf(
	person_id,
	friend_id
)
SELECT person_id, person_id + 1 AS friend_id
FROM person
WHERE person_id % 100 != 0;
-- WHERE CASE 
-- 		WHEN (SELECT random() FROM generate_series(1,20) LIMIT 1) < 0.1 THEN person_id % 2 != 0 
-- 		WHEN (SELECT random() FROM generate_series(1,20) LIMIT 1) > 0.1 AND (SELECT random() FROM generate_series(1,20) LIMIT 1) < 0.3 THEN person_id % 3 != 0 
-- 		WHEN (SELECT random() FROM generate_series(1,20) LIMIT 1) > 0.3 AND (SELECT random() FROM generate_series(1,20) LIMIT 1) < 0.5 THEN person_id % 5 != 0
-- 		WHEN (SELECT random() FROM generate_series(1,20) LIMIT 1) > 0.5 AND (SELECT random() FROM generate_series(1,20) LIMIT 1) < 0.7 THEN person_id % 8 != 0
-- 		WHEN (SELECT random() FROM generate_series(1,20) LIMIT 1) > 0.7 AND (SELECT random() FROM generate_series(1,20) LIMIT 1) < 0.85 THEN person_id % 13 != 0
-- 		WHEN (SELECT random() FROM generate_series(1,20) LIMIT 1) > 0.85 AND (SELECT random() FROM generate_series(1,20) LIMIT 1) < 0.95 THEN person_id % 21 != 0
-- 		WHEN (SELECT random() FROM generate_series(1,20) LIMIT 1) > 0.95 THEN person_id % 34 != 0
-- 	  END;




-- SELECT * FROM friendOf


/*
----------CREATE THE knows TABLE------------------
*/

-- DROP TABLE IF EXISTS knows;

-- CREATE OR REPLACE FUNCTION fn_get_row_count() 
-- RETURNS NUMERIC AS
-- $BODY$
-- 	DECLARE rCount INT;
-- 	BEGIN
-- 		SELECT COUNT(*) INTO rCount FROM friendOf;
-- 		RETURN rCount;
-- 	END
-- $BODY$
-- LANGUAGE plpgsql;

DROP TABLE IF EXISTS knows;

CREATE TABLE knows (
	person_id INT,
	known_id INT
);

INSERT INTO knows(
	person_id,
	known_id
)
SELECT friend_id, friend_id * 3 AS known_id
FROM friendOf