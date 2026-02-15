use olist_store_analysis;

  -- Q 1
SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) IN (1,7) 
        THEN 'Weekend' 
        ELSE 'Weekday' 
    END AS DayType,
    
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    ROUND(SUM(p.payment_value)) AS TotalPayments,
    ROUND(AVG(p.payment_value)) AS AveragePayment

FROM olist_orders_dataset o
JOIN olist_order_payment_dataset p 
    ON o.order_id = p.order_id

GROUP BY DayType;





--  Q 2
SELECT 
    COUNT(DISTINCT p.order_id) AS NumberOfOrders
FROM olist_order_payment_dataset p
JOIN olist_order_reviews_dataset r 
    ON p.order_id = r.order_id
WHERE r.review_score = 5
  AND p.payment_type = 'credit_card';
  
  
  
  
--  Q3
SELECT 
    c.product_category_name_english AS product_category_name,
    ROUND(AVG(TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date)), 2) AS avg_delivery_time
FROM olist_orders_dataset o
JOIN olist_order_items_dataset i 
    ON o.order_id = i.order_id
JOIN olist_products_dataset p 
    ON i.product_id = p.product_id
JOIN category_name_translation c 
    ON p.product_category_name = c.product_category_name
WHERE TRIM(LOWER(c.product_category_name_english)) = 'pet_shop'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY c.product_category_name_english;




--  Q 4
SELECT 
    ROUND(AVG(order_avg_price), 0) AS average_price,
    ROUND(AVG(order_avg_payment), 0) AS average_payment
FROM (
    SELECT 
        o.order_id,
        AVG(i.price) AS order_avg_price,
        AVG(p.payment_value) AS order_avg_payment
    FROM customers_dataset c
    JOIN olist_orders_dataset o 
        ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset i 
        ON o.order_id = i.order_id
    JOIN olist_order_payment_dataset p 
        ON o.order_id = p.order_id
    WHERE LOWER(c.city) = 'sao paulo'   
    GROUP BY o.order_id
) AS order_level;





--  Q 5
select 
    ifnull(round(avg(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)), 0), 0) as AvgShippingDays,
    r.review_score
from 
    olist_orders_dataset o
join 
    olist_order_reviews_dataset r 
    on o.order_id = r.order_id
where 
    o.order_delivered_customer_date is not null
    and o.order_purchase_timestamp is not null
group by 
    r.review_score;







  









