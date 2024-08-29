USE ucu_de_2022_2023;

// ########################################
// Items table queries
// ########################################
// 1) Напишіть запит, який показує структуру створеної таблиці (команда DESCRIBE)
DESCRIBE TABLE items_by_category;

// 2) Напишіть запит, який виводить усі товари в певній категорії відсортовані за ціною
SELECT * FROM items_by_category
WHERE category = 'Smartphone'
ORDER BY price;

// 3) Напишіть запити, які вибирають товари за різними критеріями в межах певної категорії
// (тут де треба замість індексу використайте Materialized view):
// * назва,
// * ціна (в проміжку),
// * ціна та виробник
SELECT * FROM items_by_category_and_item_name_vw
WHERE category = 'Laptop' and item_name = 'MacBook 2021';

SELECT * FROM items_by_category
WHERE category = 'Smartphone' and price >= 600 AND price <= 700;

SELECT * FROM items_by_category_and_producer_vw
WHERE category = 'Laptop' and producer = 'ASUS' and price < 2650;

// 4) Напишіть запити, які вибирають товари за:
// * наявність певних характеристик
// * певна характеристика та її значення
SELECT * FROM items_by_category
WHERE other_props CONTAINS KEY 'RAM';

SELECT * FROM items_by_category
WHERE other_props['RAM'] = '32G';

// 5) Оновити опис товару:
// * змінить існуючі значення певної характеристики
// * додайте нові властивості (характеристики) товару
// * видалить характеристику товару
UPDATE items_by_category
SET other_props['RAM'] = '64G'
WHERE category = 'Laptop' AND price = 2700;

ALTER TABLE items_by_category
ADD is_gaming_device boolean;

UPDATE items_by_category
SET is_gaming_device = TRUE
WHERE category = 'Laptop' AND price = 2700;

DROP MATERIALIZED VIEW items_by_category_and_producer_vw;

DROP MATERIALIZED VIEW items_by_category_and_item_name_vw;

ALTER TABLE items_by_category
DROP is_gaming_device;



// ########################################
// Orders table queries
// ########################################
// 1) Напишіть запит, який показує структуру створеної таблиці (команда DESCRIBE)
DESCRIBE TABLE orders_by_customer_id;

// 2) Для замовника виведіть всі його замовлення відсортовані за часом коли вони були зроблені
SELECT * FROM orders_by_customer_id
WHERE customer_id = 1
ORDER BY order_date_time;

// 3) Для замовника знайдіть замовлення з певним товаром
SELECT * FROM orders_by_customer_id
WHERE customer_id = 2 AND item_ids CONTAINS 11;

// 4) Для замовника знайдіть замовлення за певний період часу і їх кількість
SELECT * FROM orders_by_customer_id
WHERE customer_id = 1 AND order_date_time >= '2023-03-01' AND order_date_time <= '2023-04-01';

SELECT count(*) FROM orders_by_customer_id
WHERE customer_id = 1 AND order_date_time >= '2023-03-01' AND order_date_time <= '2023-04-01';

// 5) Для кожного замовників визначте суму на яку були зроблені усі його замовлення
SELECT customer_id, sum(order_price) FROM orders_by_customer_id
GROUP BY customer_id;

// 6) Для кожного замовників визначте замовлення з максимальною вартістю
SELECT customer_id, max(order_price) FROM orders_by_customer_id
GROUP BY customer_id;

// 7) Модифікуйте певне замовлення додавши / видаливши один або кілька товарів
// при цьому також змінюючи вартість замовлення
UPDATE orders_by_customer_id
SET item_ids = item_ids + [6, 2],
    order_price = 1100 + 2500 + 2000 + 3000
WHERE customer_id = 2 AND order_date_time = '2023-01-31 12:05:00.000';

// 8) Для кожного замовлення виведіть час коли його ціна були занесена в базу (SELECT WRITETIME)
SELECT order_id, WRITETIME (order_price) FROM orders_by_customer_id;

// 9) Створіть замовлення з певним часом життя (TTL), після якого воно видалиться
INSERT INTO orders_by_customer_id (
    customer_id, customer_name, order_id, item_ids, order_price, order_date_time
) VALUES (
    4, 'Test User', 8, [12], 300, '2022-02-10 12:05:00'
) USING TTL 30;

// 10) Поверніть замовлення у форматі JSON
SELECT JSON * FROM orders_by_customer_id;

// 11) Додайте замовлення у форматі JSON
INSERT INTO orders_by_customer_id
JSON '{"customer_id" : 5, "customer_name" : "Test JSON", "order_id" : 8, "item_ids" : [12], "order_price" : 300, "order_date_time" : "2022-02-10 12:05:00"}';
