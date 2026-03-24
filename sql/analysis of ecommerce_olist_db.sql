create database ecommerce_olist_db;
use ecommerce_olist_db;
-- ============================================================
-- SECTION 1 — OVERALL KPIs
-- ============================================================
 
-- KPI 1: Business snapshot 
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS gross_revenue,
    ROUND(AVG(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 100, 1) AS delivery_rate_pct,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(SUM(CASE WHEN delivery_delay_days > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(CASE WHEN delivery_delay_days IS NOT NULL THEN 1 END), 1) AS late_delivery_pct
FROM orders_merged;


-- KPI 2: Order status breakdown
-- Product question: where are orders dropping off in the funnel?
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM orders_merged
GROUP BY order_status
ORDER BY total_orders DESC;

-- ============================================================
-- SECTION 2 — FUNNEL & DELIVERY ANALYSIS
-- ============================================================
 
-- Q1: Monthly order trend + delivery rate
-- Product question: is the business growing and is quality keeping up?
SELECT
    order_month,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) AS delivered_orders,
    ROUND(COUNT(CASE WHEN order_status = 'delivered' THEN 1 END)
          * 100.0 / COUNT(*), 1) AS delivery_rate_pct,
    ROUND(SUM(total_revenue), 2) AS monthly_revenue
FROM orders_merged
GROUP BY order_month
ORDER BY order_month;

-- Q2: Delivery delay segmentation
-- Product question: how bad is the late delivery problem?
SELECT
    CASE
        WHEN delivery_delay_days <= 0  THEN '1 - On time or early'
        WHEN delivery_delay_days <= 3  THEN '2 - Slightly late (1-3 days)'
        WHEN delivery_delay_days <= 7  THEN '3 - Moderately late (4-7 days)'
        ELSE '4 - Severely late (7+ days)'
    END AS delay_category,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_delivered,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM orders_merged
WHERE order_delivered_customer_date IS NOT NULL
AND delivery_delay_days IS NOT NULL
GROUP BY delay_category
ORDER BY delay_category;

-- Q3: Does late delivery hurt review scores?
-- Product question: what is the review score impact of delays?
SELECT
    CASE
        WHEN delivery_delay_days <= 0 THEN 'On time or early'
        WHEN delivery_delay_days <= 3 THEN 'Slightly late (1-3 days)'
        WHEN delivery_delay_days <= 7 THEN 'Moderately late (4-7 days)'
        ELSE 'Severely late (7+ days)'
    END AS delivery_timing,
    COUNT(*) AS total_orders,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM orders_merged
WHERE delivery_delay_days IS NOT NULL
AND review_score IS NOT NULL
GROUP BY delivery_timing
ORDER BY avg_review_score DESC;

-- ============================================================
-- SECTION 3 — REGIONAL ANALYSIS
-- ============================================================
 
-- Q4: Performance by state
-- Product question: which states need operational attention?
SELECT
    customer_state,
    COUNT(*) AS total_orders,
    ROUND(AVG(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 100, 1) AS delivery_rate_pct,
    ROUND(AVG(delivery_delay_days), 1) AS avg_delay_days,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM orders_merged
WHERE customer_state IS NOT NULL
GROUP BY customer_state
HAVING total_orders > 100
ORDER BY total_orders DESC
LIMIT 15;
 
 
-- Q5: Top 10 cities by order volume
SELECT
    customer_city,
    customer_state,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM orders_merged
WHERE customer_city IS NOT NULL
GROUP BY customer_city, customer_state
ORDER BY total_orders DESC
LIMIT 10;
 
-- ============================================================
-- SECTION 4 — REVENUE ANALYSIS
-- ============================================================
 
-- Q6: Monthly revenue trend
-- Product question: is revenue growing consistently?
SELECT
    order_month,
    order_year,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS monthly_revenue,
    ROUND(AVG(total_revenue), 2) AS avg_order_value,
    ROUND(SUM(total_freight), 2) AS total_freight_collected
FROM orders_merged
WHERE order_status = 'delivered'
GROUP BY order_month, order_year
ORDER BY order_month;
 
 
-- Q7: Revenue by year
SELECT
    order_year,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS yearly_revenue,
    ROUND(AVG(total_revenue), 2) AS avg_order_value
FROM orders_merged
WHERE order_status = 'delivered'
GROUP BY order_year
ORDER BY order_year;
 
 
-- Q8: Average order value by state
-- Product question: where are high value customers located?
SELECT
    customer_state,
    COUNT(*) AS total_orders,
    ROUND(AVG(total_revenue), 2) AS avg_order_value,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM orders_merged
WHERE order_status = 'delivered'
  AND customer_state IS NOT NULL
GROUP BY customer_state
HAVING total_orders > 50
ORDER BY avg_order_value DESC
LIMIT 10;
 
-- ============================================================
-- SECTION 5 — REVIEW & SENTIMENT ANALYSIS
-- ============================================================
 
-- Q9: Review score distribution
-- Product question: how satisfied are our customers overall?
SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM orders_merged
WHERE review_score IS NOT NULL
GROUP BY review_score
ORDER BY review_score;
 
 
-- Q10: Sentiment breakdown
SELECT
    sentiment,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_total,
    ROUND(AVG(total_revenue), 2) AS avg_order_value
FROM orders_merged
WHERE sentiment IS NOT NULL
GROUP BY sentiment
ORDER BY total_orders DESC;
 
 
-- Q11: Review score by delivery timing
-- The key insight query for your dashboard
SELECT
    CASE
        WHEN delivery_delay_days <= 0 THEN 'On time'
        WHEN delivery_delay_days <= 3 THEN 'Slightly late'
        ELSE 'Very late'
    END AS delivery_timing,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS revenue_at_risk
FROM orders_merged
WHERE delivery_delay_days IS NOT NULL
AND review_score IS NOT NULL
GROUP BY delivery_timing
ORDER BY avg_review_score DESC;
 
 
-- ============================================================
-- SECTION 6 — CUSTOMER BEHAVIOUR
-- ============================================================
 
-- Q12: Order frequency per customer
-- Product question: how loyal is our customer base?
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time'
        WHEN order_count BETWEEN 2 AND 3 THEN 'Occasional (2-3)'
        ELSE 'Loyal (4+)'
    END AS order_frequency,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders_merged o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
) t
GROUP BY order_frequency
ORDER BY customers DESC;
 
 
-- Q13: Day of week order patterns
-- Product question: when do customers shop most?
SELECT
    order_dow,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS avg_order_value
FROM orders_merged
WHERE order_dow IS NOT NULL
GROUP BY order_dow
ORDER BY total_orders DESC;
 
 
-- Q14: High value vs low value orders
SELECT
    CASE
        WHEN total_revenue >= 500  THEN 'High value (500+)'
        WHEN total_revenue >= 200  THEN 'Mid value (200-499)'
        WHEN total_revenue >= 50   THEN 'Low value (50-199)'
        ELSE 'Very low (<50)'
    END AS order_tier,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS segment_revenue,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(AVG(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 100, 1) AS delivery_rate_pct
FROM orders_merged
WHERE total_revenue IS NOT NULL
GROUP BY order_tier
ORDER BY segment_revenue DESC;
 
 
-- ============================================================
-- SECTION 7 — PRODUCT INSIGHT SUMMARY
-- (Export these results to Excel for your dashboard)
-- ============================================================
 
-- Final insight: states with high volume but poor delivery
-- This is the key product recommendation query
SELECT
    customer_state,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 100, 1) AS delivery_rate_pct,
    ROUND(AVG(delivery_delay_days), 1) AS avg_delay_days,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    CASE
        WHEN AVG(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 100 < 85 AND COUNT(*) > 1000
        THEN 'High priority — fix delivery'
        WHEN AVG(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 100 >= 95
        THEN 'Performing well'
        ELSE 'Monitor'
    END AS action_flag
FROM orders_merged
WHERE customer_state IS NOT NULL
GROUP BY customer_state
HAVING total_orders > 200
ORDER BY total_orders DESC;
 
 
 -- Check how many orders each customer actually has
SELECT 
    customer_id,
    COUNT(DISTINCT order_id) AS order_count
FROM orders_merged
GROUP BY customer_id
ORDER BY order_count DESC
LIMIT 20;

-- customer_unique_id exists in your customers table
SELECT 
    customer_unique_id,
    COUNT(DISTINCT order_id) AS order_count
FROM orders_merged o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY customer_unique_id
ORDER BY order_count DESC
LIMIT 20;