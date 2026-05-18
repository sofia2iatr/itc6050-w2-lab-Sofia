1. customer_phones violate 1NF because it contains many phones for a single customer
2. product_category, product_name and product_price dont depend on the primary key (sale_id). It creates update anomalies.
3. customer's details (name, email etc) dont depend on primary key so if something changes we have to change many rows and we create anomalies
4. If a prodct's price changes we have to change all the rows who have this price
