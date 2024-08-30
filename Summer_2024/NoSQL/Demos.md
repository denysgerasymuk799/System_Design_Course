# Commands for Demos

## MongoDB Demo

```javascript
// Analog of SELECT * FROM items
db.items.find({});

// Analog of the following RDBMS query:
// SELECT _id, order_number, total_sum, "payment.card_owner"
// FROM orders
// WHERE total_sum > 2400
db.orders.find({total_sum: {$gt: 2400}}, {order_number: 1, total_sum: 1, "payment.card_owner": 1});

// Analog of SELECT * FROM items WHERE model = "Apple Watch Series 8" OR model = "Galaxy Watch 5"
db.items.find({$or: [{model: "Apple Watch Series 8"}, {model: "Galaxy Watch 5"}]});
```


## Neo4j Demo

```sql
// Simple queries
MATCH (n) RETURN n LIMIT 100;

MATCH (batch)-[r]->(process_order)
RETURN *
LIMIT 100;

MATCH path = (b:Batch {batch_cid: "FNDG0012246027"})-[*1..6]-(p)
WHERE p:ProcessOrder OR p:Batch
RETURN path;

MATCH path = (b:Batch {batch_cid: "FNDG0015784430"})-[*1..12]-(p)
WHERE p:ProcessOrder OR p:Batch
RETURN path;


// ============================================================================
// Quality status query
// ============================================================================
CALL {
    MATCH (p:ProcessOrder)-[:MADE_FROM]->(b:Batch)
    WHERE b.harvest_year = '2022'
        AND b.plant_id = 'NL01'
        AND EXISTS(()-[:INSPECTED]->(b))
        AND (b.material_group IN ['COM500', 'COM510'] OR (b.material_group = 'COM300' AND b.existing_inventory_flag = TRUE))
        AND NOT p.process_order_type_id IN ['ZP03', 'ZP10', 'ZP22', 'ZP23', 'ZP24', 'ZP25', 'ZP26']
    RETURN b.quality_status AS quality_status, count(DISTINCT b.batch_id) AS batch_count
}
WITH quality_status, batch_count
RETURN
    '# of batches' AS Measure,
    SUM(CASE WHEN quality_status = 'GF' THEN batch_count ELSE 0 END) AS `Green`,
    SUM(CASE WHEN quality_status = 'YF' THEN batch_count ELSE 0 END) AS `Yellow`,
    SUM(CASE WHEN quality_status = 'RF' THEN batch_count ELSE 0 END) AS `Red`,
    SUM(CASE WHEN NOT quality_status IN ['GF', 'YF', 'RF'] THEN batch_count ELSE 0 END) AS `Not finished`;
```


## Cassandra Demo

```sql
// Напишіть запити, які вибирають товари за різними критеріями в межах певної категорії
// (тут де треба замість індексу використайте Materialized view):
// * назва,
// * ціна та виробник
SELECT * FROM items_by_category_and_item_name_vw
WHERE category = 'Laptop' and item_name = 'MacBook 2021';

SELECT * FROM items_by_category_and_producer_vw
WHERE category = 'Laptop' and producer = 'ASUS' and price < 2650;
```
