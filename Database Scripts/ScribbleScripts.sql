CREATE TEMPORARY RECURSIVE VIEW fixpoint_relation1_X1 (b, a) AS
    SELECT b, a 
	  FROM (SELECT b, a 
		      FROM (SELECT * 
				      FROM (SELECT b, col1 
						      FROM (SELECT * 
								      FROM (SELECT src AS b, trg AS col1, predicate 
										      FROM yagofacts_with_id) AS t 
								   WHERE predicate = '<Test>') AS t) AS t1 
				   NATURAL 
					  JOIN (SELECT col1, a 
							  FROM (SELECT * 
									  FROM (SELECT src AS col1, trg AS a, predicate 
											  FROM yagofacts_with_id) AS t 
									 WHERE predicate = '<isLoc>') AS t) AS t2) AS t) AS const
  UNION 
    SELECT b, a 
	  FROM (SELECT a, b 
			  FROM (SELECT * 
					  FROM (SELECT b, a AS col2 
							  FROM fixpoint_relation1_X1) AS t 
					NATURAL JOIN const_subquery2) AS t) AS rec
					
					
--WITH A FILTER NAMED AS CHANDAN
CREATE TEMPORARY RECURSIVE VIEW fixpoint_relation1_X1 (src, a) AS
    SELECT src, a 
	  FROM (SELECT src, a 
			  FROM (SELECT * 
					  FROM (SELECT src, col1 
							  FROM (SELECT * 
									  FROM (SELECT * 
											  FROM (SELECT src, trg AS col1 
													  FROM yagofacts_with_id) AS t 
											 WHERE src = '<Chandan>') AS t 
									WHERE predicate = '<Test>') AS t) AS t1 
					NATURAL JOIN (SELECT col1, a 
								    FROM (SELECT * 
										    FROM (SELECT src AS col1, trg AS a, predicate 
												    FROM yagofacts_with_id) AS t 
										  WHERE predicate = '<isLoc>') AS t) AS t2) AS t) AS const
  UNION 
    SELECT src, a 
	  FROM (SELECT a, src 
			  FROM (SELECT * 
					  FROM (SELECT src, a AS col2 
							  FROM fixpoint_relation1_X1) AS t 
					NATURAL JOIN const_subquery2) AS t) AS rec