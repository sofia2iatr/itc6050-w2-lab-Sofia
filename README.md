Because an order may contain many orderitems, each with its own quantity and price.  

The logical model avoids specific types like BIGINT and JSONB so that it remains independent of any specific database vendor and can be implemented on any RDBMS.

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

5. The 3NF schema is already in BCNF. In every table, all functional dependencies have a candidate key on the left-hand side, so no further decomposition is required.