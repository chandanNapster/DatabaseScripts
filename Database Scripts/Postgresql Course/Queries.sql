SELECT time_order_taken
FROM sales_order
WHERE time_order_taken > '2018-12-01' AND time_order_taken < '2018-12-31';



SELECT *
  FROM item 
  JOIN sales_item ON item.id = sales_item.id 
				 AND price > 120
				 
				 
SELECT so.id, si.quantity, i.price
  FROM sales_order AS so 
  JOIN sales_item  AS si ON so.id = si.sales_order_id
  JOIN item        AS  i ON i.id = si.item_id 
 ORDER 
    BY 1;  


CREATE VIEW purchase_order_overview AS 
SELECT so.purchase_order_number, 
	   c.company,
       si.quantity, 
	   p.supplier,
	   p.name,
	   i.price,
	   (si.quantity * i.price) AS Total, --HAVING THESE AGGREGATES WE CANNOT DO AGGREGATES ON THE VIEWS
	   CONCAT(sp.first_name, ' ', sp.last_name) AS Salesperson
  FROM sales_order 	AS so
  JOIN sales_item  	AS si 	ON si.sales_order_id = so.id
  JOIN item 		AS i 	ON i.id = si.item_id
  JOIN customer		AS c	ON so.cust_id = c.id
  JOIN product		AS p 	ON p.id = i.product_id
  JOIN sales_person AS sp 	ON sp.id = so.sales_person_id  
  

SELECT * FROM purchase_order_overview    
DROP VIEW purchase_order_overview 
