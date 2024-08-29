USE ucu_de_2022_2023;


// ########################################
// For an Items table
// ########################################
// Smartphones
INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    1, 'iPhone 12', 'Smartphone', 1700, 'Apple Inc.', {'color': 'blue-ocean'}
);


INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    2, 'iPhone 13', 'Smartphone', 2000, 'Apple Inc.', {'color': 'star-light'}
);


INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    3, 'iPhone 7', 'Smartphone', 650, 'Apple Inc.', {'color': 'black'}
);


INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    4, 'Samsung Galaxy S10', 'Smartphone', 550, 'Samsung', {'color': 'blue'}
);


INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    5, 'Samsung Galaxy S11', 'Smartphone', 660, 'Samsung', {'color': 'yellow'}
);


-- Laptops
INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    6, 'MacBook 2022', 'Laptop', 3000, 'Apple Inc.', {'RAM': '32G', 'processor': 'M2'}
);


INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    7, 'MacBook 2021', 'Laptop', 2500, 'Apple Inc.', {'RAM': '16G', 'processor': 'M1'}
);


INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    8, 'ROG Strix SCAR 18 (2023)', 'Laptop', 2600, 'ASUS', {'RAM': '32G', 'processor': '13th Gen Intel Core i9-13980HX'}
);


INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    9, 'ROG Strix G17 (2022)', 'Laptop', 2700, 'ASUS', {'RAM': '32G', 'processor': 'AMD Ryzen 7 6800H'}
);


-- Smartwatches
INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    10, 'Apple Watch Series 8', 'Smartwatch', 500, 'Apple Inc.', {'band': 'Trail Loop'}
);


INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    11, 'Apple Watch Ultra', 'Smartwatch', 1100, 'Apple Inc.', {'band': 'Sport Loop'}
);


INSERT INTO items_by_category (
    item_id, item_name, category, price, producer, other_props
) VALUES (
    12, 'Galaxy Watch 5 Pro', 'Smartwatch', 300, 'Samsung', {'band': 'Buckle Sport'}
);


// ########################################
// For an Orders table
// ########################################
INSERT INTO orders_by_customer_id (
    customer_id, customer_name, order_id, item_ids, order_price, order_date_time
) VALUES (
    1, 'Denys Herasymuk', 1, [6, 10, 1], 5200, '2023-02-25 16:05:00'
);

INSERT INTO orders_by_customer_id (
    customer_id, customer_name, order_id, item_ids, order_price, order_date_time
) VALUES (
    1, 'Denys Herasymuk', 2, [5], 660, '2023-03-25 18:05:00'
);

INSERT INTO orders_by_customer_id (
    customer_id, customer_name, order_id, item_ids, order_price, order_date_time
) VALUES (
    1, 'Denys Herasymuk', 3, [8], 2600, '2023-03-31 19:05:00'
);

INSERT INTO orders_by_customer_id (
    customer_id, customer_name, order_id, item_ids, order_price, order_date_time
) VALUES (
    2, 'Andrii Rodionov', 4, [7, 11], 3600, '2023-01-31 12:05:00'
);

INSERT INTO orders_by_customer_id (
    customer_id, customer_name, order_id, item_ids, order_price, order_date_time
) VALUES (
    2, 'Andrii Rodionov', 5, [2], 2000, '2022-01-30 12:05:00'
);

INSERT INTO orders_by_customer_id (
    customer_id, customer_name, order_id, item_ids, order_price, order_date_time
) VALUES (
    3, 'Bohdan Petryshak', 6, [9], 2700, '2022-01-30 12:05:00'
);

INSERT INTO orders_by_customer_id (
    customer_id, customer_name, order_id, item_ids, order_price, order_date_time
) VALUES (
    3, 'Bohdan Petryshak', 7, [12], 300, '2022-02-10 12:05:00'
);
