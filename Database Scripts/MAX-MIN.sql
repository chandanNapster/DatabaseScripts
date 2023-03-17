DROP TABLE IF EXISTS customers;
	
CREATE TEMP TABLE customers(
    name VARCHAR,
	salary INT
);

INSERT INTO customers VALUES
	('Ron', 25),
	('John', 35),
	('David', 32),
	('Shradha', 30),
	('Ron', 125),
	('John', 235),
	('David', 332),
	('Shradha', 430),
	('Ron', 525),
	('John', 635),
	('David', 732),
	('Shradha', 830),
	('Ron', 925),
	('John', 1035),
	('David', 1132),
	('Shradha', 1230),
	('Ron', 1325),
	('John', 1435),
	('David', 1532),
	('Shradha', 1630),
	('Ron', 1725),
	('John', 1835),
	('David', 1932),
	('Shradha', 2030),
	('Ron', 2125),
	('John', 2235),
	('David', 2332),
	('Shradha', 2430),
	('Ron', 2525),
	('John', 2635),
	('David', 2732),
	('Shradha', 2830),
	('Ron', 2925),
	('John', 3035),
	('David', 3132),
	('Shradha', 3230),
	('Ron', 3325),
	('John', 3435),
	('David', 3532),
	('Shradha', 3630),
	('Ron', 3725),
	('John', 3835),
	('David', 3932),
	('Shradha', 4030),
	('Ron', 4125),
	('John', 4235),
	('David', 4332),
	('Shradha', 4430),
	('Ron', 4525),
	('John', 4635),
	('David', 4732),
	('Shradha', 4830),
	('Ron', 4925),
	('John', 5035),
	('David', 5132),
	('Shradha', 5230),
	('Ron', 5325),
	('John', 5435),
	('David', 5532),
	('Shradha', 5630),
	('Ron', 5725),
	('John', 5835),
	('David', 5932),
	('Shradha', 6030),
	('Ron', 6125),
	('John', 6235),
	('David', 6332),
	('Shradha', 6430),
	('Ron', 6525),
	('John', 6635),
	('David', 6732),
	('Shradha', 6830),
	('Ron', 6925),
	('John', 7035),
	('David', 7132),
	('Shradha', 7230);

--FIND THE MAXIMUM/MINIMUM SALARY BY USING THE WHERE CLAUSE (EXAMPLE OF AN ANTI SEMI JOIN)
SELECT * 
  FROM customers AS c1
 WHERE NOT EXISTS (SELECT * 
					  FROM customers AS c2
				     WHERE c1.salary < c2.salary);

--FIND THE MAXIMUM/MINIMUM SALARY BY USING THE LEFT JOIN

SELECT *
  FROM customers AS c1
  LEFT 
  JOIN customers AS c2 ON c1.salary < c2.salary
 WHERE c2.salary IS NULL;
 
 
--NORMAL JOIN 
SELECT *
  FROM customers AS c1
  JOIN customers AS c2 ON c1.salary = c2.salary


--WE CAN ALSO DO A AGGREGATION FUNCTION TO FIND MIN AND MAX

SELECT max(c1.salary)
FROM customers AS c1
JOIN customers AS c2 ON c1.salary = c2.salary
JOIN customers AS c3 ON c2.salary = c3.salary
JOIN customers AS c4 ON c3.salary = c4.salary
JOIN customers AS c5 ON c4.salary = c5.salary
JOIN customers AS c6 ON c5.salary = c6.salary
JOIN customers AS c7 ON c6.salary = c7.salary