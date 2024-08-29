// Create and populate an Items collection
db.items.insertMany([
   { item_id: 1, category: "Phone", model: "iPhone 6", producer: "Apple", price: 600 },
   { item_id: 2, category: "Phone", model: "iPhone 12", producer: "Apple", price: 1000 },
   { item_id: 3, category: "Smart Watch", model: "Apple Watch Series 8", producer: "Apple", price: 500 },
   { item_id: 4, category: "Smart Watch", model: "Galaxy Watch 5", producer: "Samsung", price: 400 },
   { item_id: 5, category: "Smart Watch", model: "Galaxy Watch 4", producer: "Samsung", price: 350 },
   { item_id: 6, category: "Laptop", model: "MacBook Pro (M2)", producer: "Apple", price: 3500 },
   { item_id: 7, category: "Laptop", model: "MacBook Pro (M1)", producer: "Apple", price: 3000 }
]);

// Create and populate an Orders collection
db.orders.insertMany([
   {
        order_number : 2023191,
        date : ISODate("2023-03-19"),
        total_sum : 1923.4,
        customer : {
            name : "Dmytro",
            surname : "Pryimak",
            phones : [9876543, 1234567],
            address : "PTI, Peremohy 37, Kyiv, UA"
        },
        payment : {
            card_owner : "Dmytro Pryimak",
            cardId : 12345678
        },
        items_id : [3, 7]
    },
   {
        order_number : 2023192,
        date : ISODate("2023-03-19"),
        total_sum : 3200.0,
        customer : {
            name : "Denys",
            surname : "Herasymuk",
            phones : [1440189],
            address : "Bandery 1, Lviv, UA"
        },
        payment : {
            card_owner : "Denys Herasymuk",
            cardId : 87654321
        },
        items_id : [2, 3, 6]
    },
    {
        order_number : 2023181,
        date : ISODate("2023-03-18"),
        total_sum : 2500.0,
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
        items_id : [4, 7]
    },
    {
        order_number : 2023172,
        date : ISODate("2023-03-17"),
        total_sum : 2500.0,
        customer : {
            name : "Oles",
            surname : "Dobosevych",
            phones : [7777777, 1111111],
            address : "Lazarenka 1, Lviv, UA"
        },
        payment : {
            card_owner : "Oles Dobosevych",
            cardId : 76543218
        },
        items_id : [2, 6]
    }
]);
