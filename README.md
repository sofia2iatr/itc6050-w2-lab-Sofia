Because an order may have many orderitems 

The logical model avoids Postgres‑specific types like BIGINT and JSONB so that it remains independent of any specific database vendor and can be implemented on any RDBMS.

3. One to many 
Customer → Address
Customer → Order
Category → Product
Order → OrderItem
Product → OrderItem
Customer → Review
Product → Review
Category → Discount
Product → Discount

Many to Many
Customer ↔ Product
Category ↔ Product

4. Using ON DELETE CASCADE on order_item.order_id is wrong because deleting an order would also delete all its order items, destroying the audit trail of what was purchased.
