    -- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)
SELECT c.company_name AS customer, CONCAT(first_name, ' ', last_name) AS employee
FROM orders as o
JOIN customers as c USING(customer_id)
JOIN employees as e USING(employee_id)
JOIN shippers as s ON o.ship_via = s.shipper_id
WHERE c.city = 'London' AND e.city = 'London' AND s.company_name = 'United Package';

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT product_name, units_in_stock, s.contact_name, s.phone
FROM products
INNER JOIN suppliers as s USING(supplier_id)
INNER JOIN categories as c USING(category_id)
WHERE units_in_stock < 25 AND discontinued = 0 AND (category_name = 'Dairy Products' OR category_name = 'Condiments')
ORDER BY units_in_stock

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT company_name
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT product_name
FROM products AS p
WHERE EXISTS(SELECT o.product_id FROM order_details JOIN order_details AS o ON p.product_id = o.product_id WHERE o.quantity = 10)
