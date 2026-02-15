use olist_store_analysis;

-- Question 1. Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics.
Create table kpi1 Select 
CASE 
WHEN DAYOFWEEK(o.order_purchase_timestamp) IN (1,7) THEN 'Weekend'
ELSE 'Weekday' 
END AS DayType,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    ROUND(SUM(p.payment_value)) AS TotalPayments,
    ROUND(AVG(p.payment_value)) AS AveragePayment
FROM orders_dataset o
JOIN payments_dataset p 
ON   o.order_id = p.order_id
GROUP BY DayType;
select * from kpi1;



--  Questions 2.Number of Orders with review score 5 and payment type as credit card.

 Create table kpi2 Select
    r.review_score,
    COUNT(DISTINCT p.order_id) AS NumberOfOrders
FROM payments_dataset p
JOIN reviews_dataset r 
    ON p.order_id = r.order_id
WHERE r.review_score = 5
  AND p.payment_type = 'credit_card'
GROUP BY r.review_score;
select * from kpi2;


-- Question 3. Average number of days taken for order_delivered_customer_date for pet_shop

 Create table kpi3 Select
    p.product_category_name,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp))) AS avg_delivery_time
FROM orders_dataset o
JOIN items_dataset i 
  ON i.order_id = o.order_id
JOIN products_dataset p 
ON   p.product_id = i.product_id
WHERE p.product_category_name = 'pet_shop'
AND   o.order_delivered_customer_date IS NOT NULL;
select * from kpi3;



--  Question 4. Average price and payment values from customers of sao paulo city.


Create table kpi4 Select
    ROUND(AVG(i.price), 0) AS average_price,
    ROUND(AVG(p.payment_value), 0) AS average_payment
FROM customers_dataset c
JOIN orders_dataset o 
    ON c.customer_id = o.customer_id
JOIN items_dataset i 
    ON o.order_id = i.order_id
JOIN payments_dataset p 
    ON o.order_id = p.order_id
WHERE c.city = 'Sao Paulo';
select * from kpi4;



--  Question 5. Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

Create table kpi5 Select
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 0) AS AvgShippingDays,
    r.review_score
FROM orders_dataset o
JOIN reviews_dataset r 
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY r.review_score;
select * from kpi5;





