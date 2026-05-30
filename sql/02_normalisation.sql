--1. customer_phones violate 1NF because it contains many phones for a single customer
--2. product_category, product_name and product_price dont depend on the primary key (sale_id). It creates update anomalies.
--3. customer's details (name, email etc) dont depend on primary key so if something changes we have to change many rows and we create anomalies
--4. If a prodct's price changes we have to change all the rows who have this price



CREATE SCHEMA IF NOT EXISTS clean;
SET search_path TO clean;

CREATE TABLE customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(160) NOT NULL,
    city VARCHAR(80),
    country VARCHAR(60)
);

CREATE TABLE customer_phone (
    customer_id BIGINT NOT NULL REFERENCES customer(customer_id) ON DELETE CASCADE,
    phone VARCHAR(40) NOT NULL,
    PRIMARY KEY (customer_id, phone)
);


CREATE TABLE product (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    category VARCHAR(60),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);


CREATE TABLE sale (
    sale_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customer(customer_id),
    sale_date DATE NOT NULL
);

CREATE TABLE sale_item (
    sale_id BIGINT NOT NULL REFERENCES sale(sale_id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES product(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price_at_sale NUMERIC(10,2) NOT NULL CHECK (unit_price_at_sale >= 0),
    line_total NUMERIC(10,2) NOT NULL CHECK (line_total >= 0),
    PRIMARY KEY (sale_id, product_id)
);
