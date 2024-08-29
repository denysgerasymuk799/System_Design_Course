CREATE KEYSPACE ucu_de_2022_2023 WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor' : 1};

USE ucu_de_2022_2023;

// ########################################
// Items Data model
// ########################################
CREATE TABLE items_by_category (
    item_id INT,
    item_name TEXT,
    category TEXT,
    price DOUBLE,
    producer TEXT,
    other_props MAP<TEXT, TEXT>,
    PRIMARY KEY ((category), price)
) WITH CLUSTERING ORDER BY (price ASC);


CREATE MATERIALIZED VIEW items_by_category_and_producer_vw AS
   SELECT * FROM items_by_category
   WHERE producer IS NOT NULL AND category IS NOT NULL AND price IS NOT NULL
   PRIMARY KEY ((category, producer), price);


CREATE MATERIALIZED VIEW items_by_category_and_item_name_vw AS
   SELECT * FROM items_by_category
   WHERE item_name IS NOT NULL AND category IS NOT NULL AND price IS NOT NULL
   PRIMARY KEY ((category, item_name), price);


CREATE INDEX idx_entries_other_props ON items_by_category(Entries (other_props));

CREATE INDEX idx_keys_other_props ON items_by_category(Keys (other_props));


// ########################################
// Orders Data model
// ########################################
CREATE TABLE orders_by_customer_id (
    customer_id INT,
    customer_name TEXT,
    order_id INT,
    order_price DOUBLE,
    item_ids LIST<INT>,
    order_date_time TIMESTAMP,
    PRIMARY KEY ((customer_id), order_date_time)
) WITH CLUSTERING ORDER BY (order_date_time ASC);

CREATE INDEX idx_item_ids_in_orders_by_customer_id ON orders_by_customer_id(item_ids);
