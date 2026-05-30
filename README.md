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

6. Q1:
 Index Scan using customer_email_key on customer  (cost=0.29..8.30 rows=1 width=53) (actual time=0.453..0.474 rows=1 loops=1)
   Index Cond: ((email)::text = 'cust5000@example.com'::text)
 Planning Time: 10.222 ms
Execution Time: 2.405 ms

Q2:                                                  
 Sort  (cost=2125.17..2125.19 rows=10 width=22) (actual time=91.205..91.208 rows=10 loops=1)
   Sort Key: order_date DESC
   Sort Method: quicksort  Memory: 25kB
   ->  Seq Scan on orders  (cost=0.00..2125.00 rows=10 width=22) (actual time=5.987..90.253 rows=10 loops=1)
         Filter: (customer_id = 5000)
         Rows Removed by Filter: 99990
Planning Time: 3.518 ms
 Execution Time: 5.688 msq

 Q3:                                                   Limit  (cost=11301.20..11301.23 rows=10 width=43) (actual time=93.944..97.993 rows=10 loops=1)
   ->  Sort  (cost=11301.20..11303.70 rows=1000 width=43) (actual time=93.941..97.987 rows=10 loops=1)
         Sort Key: (sum(((oi.quantity)::numeric * oi.unit_price_at_sale))) DESC
         Sort Method: top-N heapsort  Memory: 26kB
->  Finalize GroupAggregate  (cost=11018.74..11279.59 ro
ws=1000 width=43) (actual time=124.227..129.553 rows=1000 loops=1
)
               Group Key: p.name
               ->  Gather Merge  (cost=11018.74..11252.09 rows=20
00 width=43) (actual time=124.212..128.275 rows=3000 loops=1)
                     Workers Planned: 2
                     Workers Launched: 2
                     ->  Sort  (cost=10018.72..10021.22 rows=1000
 width=43) (actual time=110.917..110.992 rows=1000 loops=3)
                           Sort Key: p.name
                           Sort Method: quicksort  Memory: 118kB
                           Worker 0:  Sort Method: quicksort  Mem
ory: 118kB
                           Worker 1:  Sort Method: quicksort  Mem
ory: 118kB
                           ->  Partial HashAggregate  (cost=9956.
39..9968.89 rows=1000 width=43) (actual time=107.475..107.910 row
s=1000 loops=3)
                                 Group Key: p.name
                                 Batches: 1  Memory Usage: 577kB
                                  Worker 0:  Batches: 1  Memory Us
age: 577kB
                                 Worker 1:  Batches: 1  Memory Us
age: 577kB
                                 ->  Hash Join  (cost=2843.12..97
06.18 rows=25021 width=21) (actual time=40.540..91.462 rows=20088
 loops=3)
                                       Hash Cond: (oi.product_id 
= p.product_id)
                                       ->  Hash Join  (cost=2775.
12..9572.35 rows=25021 width=18) (actual time=39.285..84.831 rows
Hash Cond: (oi.order
_id = o.order_id)
                                             ->  Parallel Seq Sca
n on order_item oi  (cost=0.00..6250.33 rows=208333 width=26) (ac
tual time=0.038..17.235 rows=166667 loops=3)
                                             ->  Hash  (cost=2625
.00..2625.00 rows=12010 width=8) (actual time=39.103..39.104 rows
=12053 loops=3)
                                                   Buckets: 16384
  Batches: 1  Memory Usage: 599kB
   ->  Seq Scan o
n orders o  (cost=0.00..2625.00 rows=12010 width=8) (actual time=
0.075..31.385 rows=12053 loops=3)
                                                         Filter: 
(order_date >= (now() - '90 days'::interval))
                                                         Rows Rem
oved by Filter: 87947
                                       ->  Hash  (cost=43.00..43.
00 rows=2000 width=19) (actual time=1.171..1.172 rows=2000 loops=
3)
                                             Buckets: 2048  Batch
                                             es: 1  Memory Usage: 126kB
                                             ->  Seq Scan on prod
uct p  (cost=0.00..43.00 rows=2000 width=19) (actual time=0.031..
0.503 rows=2000 loops=3)
 Planning Time: 0.520 ms
 Execution Time: 130.051 ms
(34 rows)