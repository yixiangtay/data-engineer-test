-- list of customers and their spending
SELECT c.name AS customer_name, SUM(car.price) AS spending
FROM customer AS c
         JOIN transaction AS t ON c.id = t.customer_id
         JOIN car ON t.car_id = car.id
GROUP BY c.id;


-- top 3 car manufacturers that customers bought by sales quantity
-- and the sales quantity in the current month
-- note: this does not include ties
SELECT m.name AS manufacturer_name, COUNT(*) AS sales_quantity
FROM manufacturer AS m
         JOIN car_model AS cm on m.id = cm.manufacturer_id
         JOIN car AS c on cm.id = c.car_model_id
         JOIN transaction AS t on c.id = t.car_id
WHERE EXTRACT(MONTH FROM t.datetime) = EXTRACT(MONTH FROM NOW())
  AND EXTRACT(YEAR FROM t.datetime) = EXTRACT(YEAR FROM NOW())
GROUP BY m.id
ORDER BY sales_quantity DESC
LIMIT 3;