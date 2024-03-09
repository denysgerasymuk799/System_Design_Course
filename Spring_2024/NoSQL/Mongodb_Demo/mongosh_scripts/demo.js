// ========================= Insert and update queries =========================
// Insert one records into the Orders collection
db.orders.insertOne(
    {
        order_number : 2023171,
        date : ISODate("2023-03-17"),
        total_sum : 600.0,
        customer : {
            name : "Denys",
            surname : "Herasymuk",
            phones : [1440189],
            address : "Bandery 1, Lviv, UA"
        },
        payment : {
            card_owner : "Denys Herasymuk",
            cardId : 18273645
        },
        items_id : [1]
    }
);

// Analog of the following query:
// UPDATE items
// SET price = price + 50,
//     color = "blue",
//     case_size = 45
// WHERE category = "Smart Watch" AND producer = "Samsung"
db.items.updateMany(
    {category: "Smart Watch", producer: "Samsung"},
    {
        $inc: {price: 50},
        $set: {
            color: "blue",
            case_size: 45
        }
    }
 );


// ========================= Select queries =========================
// Analog of SELECT * FROM items
db.items.find({});

// Analog of SELECT _id, order_number FROM orders
db.orders.find({}, {order_number: 1});

// Analog of SELECT order_number FROM orders
db.orders.find({}, {order_number: 1, _id: 0});

// Analog of the following RDBMS query:
// SELECT _id, order_number, total_sum, "payment.card_owner"
// FROM orders
// WHERE total_sum > 2400
db.orders.find({total_sum: {$gt: 2400}}, {order_number: 1, total_sum: 1, "payment.card_owner": 1});

// Analog of SELECT DISTINCT producer FROM items
db.items.distinct("producer");

// Analog of SELECT * FROM items WHERE category = "Smart Watch" AND price >= 350 AND price < 500
db.items.find({category: "Smart Watch", price: {$gte: 350, $lt: 500}});

// Analog of SELECT * FROM items WHERE model = "Apple Watch Series 8" OR model = "Galaxy Watch 5"
db.items.find({$or: [{model: "Apple Watch Series 8"}, {model: "Galaxy Watch 5"}]});


// ========================= Aggregations =========================
// Analog of SELECT count(category) FROM items
db.items.find({ category: "Smart Watch" }).count();

// Analog of the following query:
// SELECT
//      "customer.name" AS customer_name,
//      "customer.surname" AS customer_surname,
//      SUM(total_sum) AS orders_total_sum,
//      COUNT(*) AS orders_count
// FROM orders
// GROUP BY "customer.name", "customer.surname"
db.orders.aggregate([
    {
        $group: {
            _id: { customer_name: "$customer.name" , customer_surname: "$customer.surname" },
           orders_total_sum: { $sum: "$total_sum" },
           orders_count: { $sum: 1 }
        }
    }
]);

// Analog of the following query:
// SELECT
//      "customer.name" AS customer_name,
//      "customer.surname" AS customer_surname,
//      MAX(total_sum) AS orders_max_sum
// FROM orders
// GROUP BY "customer.name", "customer.surname"
db.orders.aggregate([
    {
        $group: {
            _id: { customer_name: "$customer.name" , customer_surname: "$customer.surname" },
           orders_max_sum: { $max: "$total_sum" },
        }
    }
]);

// Explode and join items and orders. After exploding of items_id column,
// this is an analog of the following query:
//
// SELECT ord.customer, it.model, it.price
// FROM orders AS ord
// JOIN items AS it ON ord.item_id = it.item_id
db.orders.aggregate([
    { // Explode items id
        $unwind: "$items_id"
    },
    { // Select and cast specific columns for lookup
        $project: {
            customer: 1,
            item_id: "$items_id"
        }
    },
    { // Join items
        $lookup: {
           from: "items",
           localField: "item_id",
           foreignField: "item_id",
           as: "items"
        }
    },
    { // Select specific columns
        $project: {
            _id: 0,
            customer: 1,
            "items.model": 1,
            "items.price": 1
        }
    }
]);
