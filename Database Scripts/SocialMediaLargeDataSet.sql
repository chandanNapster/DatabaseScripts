DROP view fixpoint_trv_friend_of;
DROP view trv_knows;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS friendOf;
DROP TABLE IF EXISTS knows;
DROP TABLE IF EXISTS likes;

TRUNCATE TABLE friendOf;


/*
----------CREATE THE friendOf TABLE------------------
*/
CREATE TABLE friendOf (
	person_id INT,
	friend_id INT
);

INSERT INTO friendOf
SELECT src, trg
  FROM (SELECT round(5000 * random()) AS src , round(5000 * random()) AS trg 
		  FROM generate_series(1,3000000)) AS t
  WHERE src != trg
    AND src != 0
	AND trg != 0
	AND src < trg;
  
  


/*
----------CREATE THE knows TABLE------------------
*/

CREATE TABLE knows (
	person_id INT,
	known_id INT
);

INSERT INTO knows
SELECT src, trg
  FROM (SELECT round(5000 * random()) AS src , round(5000 * random()) AS trg 
		  FROM generate_series(1,3000000)) AS t
  WHERE src != trg
    AND src != 0
	AND trg != 0
	AND src < trg;
  
  

SELECT * FROM knows;  
SELECT * FROM friendOf;  