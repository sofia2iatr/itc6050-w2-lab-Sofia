SET search_path TO shop;

------------------------------------------------------------
-- 1) 50 categories
------------------------------------------------------------
INSERT INTO category (name)
SELECT 'Category ' || g
FROM generate_series(1, 50) g;

------------------------------------------------------------
-- 2) 1,000 products
------------------------------------------------------------
INSERT INTO product (category_id, name, description, price)
SELECT
    ((g - 1) % 50) + 1,
    'Product ' || g,
    'Description for product ' || g,
    ROUND((random() * 200 + 5)::numeric, 2)
FROM generate_series(1, 1000) g;

------------------------------------------------------------
-- 3) 10,000 customers
------------------------------------------------------------
INSERT INTO customer (email, first_name, last_name)
SELECT
    'cust' || g || '@example.com',
    'First' || g,
    'Last' || g
FROM generate_series(1, 10000) g;

------------------------------------------------------------
-- 4) 10,000 addresses (1 per customer)
------------------------------------------------------------
INSERT INTO address (customer_id, line1, city, postcode, country, is_default)
SELECT
    g,
    'Address line ' || g,
    'City ' || ((g - 1) % 100),
    'PC' || LPAD((g % 9999)::text, 4, '0'),
    'GR',
    TRUE
FROM generate_series(1, 10000) g;

------------------------------------------------------------
-- 5) 100,000 orders
------------------------------------------------------------
INSERT INTO orders (customer_id, order_date, status, total)
SELECT
    ((g - 1) % 10000) + 1,
    NOW() - (random() * INTERVAL '730 days'),
    (ARRAY['new','paid','shipped','delivered','cancelled'])[ceil(random()*5)::int],
    ROUND((random() * 500 + 10)::numeric, 2)
FROM generate_series(1, 100000) g;

------------------------------------------------------------
-- 6) 500,000 order items
------------------------------------------------------------
INSERT INTO order_item (order_id, product_id, quantity, unit_price_at_sale)
SELECT
    ((g - 1) % 100000) + 1,
    ((g - 1) % 1000) + 1,
    ceil(random() * 5)::int,
    ROUND((random() * 200 + 5)::numeric, 2)
FROM generate_series(1, 500000) g;

------------------------------------------------------------
-- 7) Update planner statistics
------------------------------------------------------------
ANALYZE;
