--FUNCTIONS 
--BASIC FUNCTIONS 
 CREATE OR REPLACE FUNCTION fn_add_ints(int, int) 
 RETURNS int AS
 '
 	SELECT $1 + $2;
 '
 LANGUAGE SQL 
 
 SELECT fn_add_ints(1,2)


--FUNCTIONS 
--WITH BODY AND $ QUOTES
 CREATE OR REPLACE FUNCTION fn_add_ints(int, int) 
 RETURNS int AS
 $BODY$
 	SELECT $1 + $2;
 $BODY$
 
 LANGUAGE SQL 

 --UPDATE 
 CREATE OR REPLACE FUNCTION fn_update_employee_state() 
 RETURNS void AS
 $BODY$
 	UPDATE sales_person
	SET state = 'PA'
	WHERE state is null
 $BODY$
 
 LANGUAGE SQL 
 
 --AGGREGATES
 CREATE OR REPLACE FUNCTION fn_max_product_price() 
 RETURNS NUMERIC AS
 $BODY$
 	SELECT MAX(price)
	  FROM item 
 $BODY$
 
 LANGUAGE SQL 

 --AGGREGATES 2 
 CREATE OR REPLACE FUNCTION fn_get_value_inventory() 
 RETURNS NUMERIC AS
 $BODY$
 	SELECT SUM(price)
	  FROM item 
 $BODY$
 
 LANGUAGE SQL 

 --AGGREGATES 3
 CREATE OR REPLACE FUNCTION fn_number_customer() 
 RETURNS NUMERIC AS
 $BODY$
 	SELECT COUNT(*)
	  FROM customer 
 $BODY$
 
 LANGUAGE SQL

 --FUNCTIONS 
 CREATE OR REPLACE FUNCTION fn_get_number_customers_from_state(state_name char(2)) 
 RETURNS NUMERIC AS
 $BODY$
 	SELECT COUNT(*)
	  FROM customer
	  WHERE state = state_name
 $BODY$
 
 LANGUAGE SQL 

 --FUNCTIONS 
 CREATE OR REPLACE FUNCTION fn_get_number_orders_from_customer(cF VARCHAR, cL VARCHAR) 
 RETURNS NUMERIC AS
 $BODY$
 	SELECT COUNT(*) 
   	  FROM sales_order AS so
      JOIN customer	AS c ON c.id = so.cust_id 
     WHERE c.first_name = cF AND c.last_name = cL
 $BODY$
 
 LANGUAGE SQL 
 
 SELECT fn_get_number_orders_from_customer('Michael', 'Jackson')

 --GET ROW FROM A TABLE
 --FUNCTIONS 
 CREATE OR REPLACE FUNCTION fn_get_last_order() 
 RETURNS sales_order AS
 $BODY$
 	SELECT *
	  FROM sales_order
  ORDER BY time_order_taken DESC
     LIMIT 1
 $BODY$
 
 LANGUAGE SQL 

 --IN A TABLE FORMAT
 SELECT (fn_get_last_order()).*

 --FUNCTIONS 
 CREATE OR REPLACE FUNCTION fn_get_employees_location(loc VARCHAR) 
 RETURNS SETOF sales_person AS
 $BODY$
 	SELECT *
 	  FROM sales_person
 	 WHERE state = loc
 $BODY$
 
 LANGUAGE SQL 
 
 SELECT (fn_get_employees_location('CA')).*

 --FUNCTIONS 
 CREATE OR REPLACE FUNCTION fn_get_employees_location(loc VARCHAR) 
 RETURNS SETOF sales_person AS
 $BODY$
 	SELECT *
 	  FROM sales_person
 	 WHERE state = loc
 $BODY$
 
 LANGUAGE SQL 
 
 SELECT fn_get_employees_location('CA')
 
 
 SELECT first_name, last_name, phone
   FROM fn_get_employees_location('CA')

   --PL/pgsql 

CREATE OR REPLACE FUNCTION func_name(parameter par_type) RETURNS ret_type AS
$BODY$
BEGIN
--statements
END
$BODY$
LANGUAGE plpgsql 

--FUNCTIONS
CREATE OR REPLACE FUNCTION fn_get_price_product_name(prod_name VARCHAR) 
RETURNS NUMERIC AS
$BODY$
	BEGIN
		RETURN item.price
   		  FROM item
	   NATURAL 
          JOIN product
         WHERE product.name = prod_name; 
	END
$BODY$
LANGUAGE plpgsql 

SELECT fn_get_price_product_name('Grandview')

CREATE OR REPLACE FUNCTION fn_get_sum(val1 INT, val2 INT) 
RETURNS INT AS
	
$BODY$
	DECLARE
		ans INT;
	BEGIN
		ans := val1 + val2;
		RETURN ans;
	END
$BODY$
LANGUAGE plpgsql 

SELECT fn_get_sum(1,2)

--GENERATE RANDOM NUMBERS
CREATE OR REPLACE FUNCTION fn_get_random_num(min_val INT, max_val INT) 
RETURNS INT AS
	
$BODY$
	DECLARE
		rand INT;
	BEGIN
		SELECT random()*(max_val - min_val) + min_val INTO rand;
		RETURN rand;
	END;
$BODY$
LANGUAGE plpgsql 

SELECT fn_get_random_num(2,5)

--CAN GENERATE RANDOM NUMBERS IN THIS WAY AS WELL.
CREATE OR REPLACE FUNCTION fn_get_random_num(min_val INT, max_val INT) 
RETURNS INT AS
	
$BODY$
	DECLARE
		rand INT;
	BEGIN
		rand := random()*(max_val - min_val) + min_val;
		return rand;
-- 		SELECT random()*(max_val - min_val) + min_val INTO rand;
-- 		RETURN rand;
	END;
$BODY$
LANGUAGE plpgsql 

SELECT fn_get_random_num(2,50)

--IN , OUT, INOUT

CREATE OR REPLACE FUNCTION fn_get_sum_2(IN val1 INT, IN val2 INT, ans OUT INT)
AS
$BODY$
	BEGIN
		ans := val1 + val2;
	END;

$BODY$
LANGUAGE plpgsql

--MULTIPLE OUTS
CREATE OR REPLACE FUNCTION fn_get_sum_3(IN the_month INT, 
										OUT bd_month INT, 
										OUT bd_day INT,
									    OUT f_name VARCHAR,
										OUT l_name VARCHAR
									   )
AS
$BODY$
	BEGIN
		SELECT EXTRACT(MONTH FROM birth_date), 
					   EXTRACT(DAY FROM birth_date),
					   first_name,
					   last_name
		INTO bd_month, bd_day, f_name, l_name
		FROM customer 
		WHERE EXTRACT(MONTH FROM birth_date) = the_month;
	END;

$BODY$
LANGUAGE plpgsql


--GETTING DATA FROM MULTIPLE TABLES AND OUTPUTTING THE RESULTSET AS A TABLE

CREATE OR REPLACE FUNCTION fn_get_mul_results_as_table()
RETURNS TABLE (
	company 	VARCHAR,
	quantity 	INT,
	price		NUMERIC
) AS

$BODY$
BEGIN	
	RETURN QUERY
	SELECT 	c.company,
			si.quantity,
			i.price
	FROM sales_order 	AS so
  	JOIN sales_item  	AS si 	ON si.sales_order_id = so.id
  	JOIN item 			AS i 	ON i.id = si.item_id
  	JOIN customer		AS c	ON so.cust_id = c.id;
END;	
$BODY$

LANGUAGE plpgsql;

SELECT (fn_get_mul_results_as_table()).*

--WITH FILTERS

CREATE OR REPLACE FUNCTION fn_get_mul_results_as_table(quant INT)
RETURNS TABLE (
	company 	VARCHAR,
	quantity 	INT,
	price		NUMERIC
) AS

$BODY$
BEGIN	
	RETURN QUERY
	SELECT 	c.company,
			si.quantity,
			i.price
	FROM sales_order 	AS so
  	JOIN sales_item  	AS si 	ON si.sales_order_id = so.id
  	JOIN item 			AS i 	ON i.id = si.item_id
  	JOIN customer		AS c	ON so.cust_id = c.id
   WHERE si.quantity = quant;
END;	
$BODY$

LANGUAGE plpgsql;

SELECT (fn_get_mul_results_as_table(1)).*

--IF ELSEIF AND ELSE

CREATE OR REPLACE FUNCTION fn_check_month_order(the_month INT)
RETURNS VARCHAR AS
$body$
DECLARE
	total_orders INT;
BEGIN
	SELECT COUNT(purchase_order_number)
	INTO total_orders
	FROM sales_order
	WHERE EXTRACT (MONTH FROM time_order_taken) = the_month;
	IF total_orders > 5 THEN
		RETURN CONCAT(total_orders, ' Orders : Doing Good');
	ELSEIF total_orders < 5 THEN 	
		RETURN CONCAT(total_orders, ' Orders : Doing Bad');
	ELSE
		RETURN CONCAT(total_orders, ' Orders : On Target');
	END IF;	
END
$body$

LANGUAGE plpgsql;

SELECT fn_check_month_order(2)

--CASE STATEMENTS

CREATE OR REPLACE FUNCTION fn_check_month_order_2(the_month INT)
RETURNS VARCHAR AS
$body$
DECLARE
	total_orders INT;
BEGIN
	SELECT COUNT(purchase_order_number)
	INTO total_orders
	FROM sales_order
	WHERE EXTRACT (MONTH FROM time_order_taken) = the_month;
	CASE 
		WHEN total_orders < 1 THEN
			RETURN CONCAT(total_orders, ' Orders : Doing Very bad');
		WHEN total_orders > 1 AND total_orders < 5 THEN
			RETURN CONCAT(total_orders, ' Orders : On Target');
		ELSE
			RETURN CONCAT(total_orders, ' Orders : Doing good');
		
	END CASE;
END
$body$

LANGUAGE plpgsql;

SELECT fn_check_month_order_2(2)


/* 
LOOP
	Statement
	EXIT WHEN condition is ture;
END LOOP;	

*/

CREATE OR REPLACE FUNCTION fn_loop_test(max_num int)
RETURNS int AS
$body$
DECLARE 
	j int DEFAULT 1;
	tot_sum int DEFAULT 0;
BEGIN
	LOOP
		tot_sum := tot_sum + j;
		j := j + 1;
		EXIT WHEN j > max_num;
	END LOOP;
	RETURN tot_sum; 
END;
$body$

LANGUAGE plpgsql;

SELECT fn_loop_test(5)

/*
FOR counter_name IN start_value .. end_value BY steeping
LOOP
	statement 
END LOOP;

*/

CREATE OR REPLACE FUNCTION fn_loop_for(max_num int)
RETURNS int AS 
$body$
DECLARE
	tot_sum int DEFAULT 0;
BEGIN
	FOR i IN 1 .. max_num BY 1
	LOOP
		tot_sum := tot_sum + i;
	END LOOP;
	RETURN tot_sum;
END;
$body$
LANGUAGE plpgsql

SELECT fn_loop_for(4)


--FOR LOOPS
DO 
$body$
	DECLARE 
		rec record;
	BEGIN
		FOR rec IN 
			SELECT first_name, last_name
			  FROM sales_person
			 LIMIT 3
		LOOP
			RAISE NOTICE '% %', rec.first_name, rec.last_name;
		END LOOP;	
	END;
$body$
LANGUAGE plpgsql

--FOREACH var IN ARRAY

DO 
$body$
	DECLARE
		arr1 int[] := array[1,2,3];
		i int;
	BEGIN
		FOREACH i IN ARRAY arr1
		LOOP
			RAISE NOTICE '%', i; 
		END LOOP;
	END;

$body$
LANGUAGE plpgsql

--WHILE LOOP

DO 
$body$
	DECLARE
		j INT DEFAULT 1;
		tot_sum INT DEFAULT 0;
	BEGIN
		WHILE j <= 20
		LOOP
			tot_sum := tot_sum + j;
			j := j + 1;
		END LOOP;
		RAISE NOTICE '%', tot_sum;
	END;

$body$
LANGUAGE plpgsql 