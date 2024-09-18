Use olist_dataset;
Show tables;

ALTER TABLE dataset_csv rename to Olist_Store;
Show Columns From Olist_Store;

/*KPI:1  Weekday Vs Weekend Payment Statistics*/
SELECT
    `Weekday Vs Weekend`,
     CONCAT('R$ ', Round (SUM(payment_value))) AS Payment_Statistics
FROM
   Olist_Store
GROUP BY
    `Weekday Vs Weekend`;
    
/*KPI:2 Number of Orders with review score 5 and payment type as credit card*/
SELECT
    payment_type,
    review_score,
    COUNT(order_id) AS Number_Of_Orders
FROM
    Olist_Store
WHERE
    payment_type = 'credit_card' AND review_score = 5
GROUP BY
    payment_type, review_score;

/*KPI:3 Average number of days taken for order_delivered_customer_date for pet_shop*/
SELECT
   Product_Categories,
   Round (AVG(`Shipping Days`)) AS Avg_Delivery_Days      
FROM
    Olist_Store
WHERE
    Product_Categories = 'pet_shop'
GROUP BY
    Product_Categories;

/*KPI:4 Average price and payment values from customers of sao paulo city*/
SELECT 
	  customer_city, 
    Concat('R$ ', Round (AVG(`price`))) As Avg_Price,
	Concat('R$ ', Round(AVG(`payment_value`))) As Avg_Payment_Value,
	Count(customer_id) As Total_Customers
From
    Olist_Store
Where customer_city = 'sao paulo'
Group By
       `customer_city`;

/*KPI:5 Relationship between shipping days Vs review scores*/
SELECT
    review_score,
    Round(AVG(`Shipping Days`)) AS Avg_Delivery_days
FROM
    Olist_Store
GROUP BY
    review_score
Order By
    review_score Asc;

/*KPI:6 Top 10 city sales*/
SELECT
    customer_city AS City,
    CONCAT('R$ ', CAST(SUM(payment_value) AS SIGNED)) AS Total_Sales
FROM
    Olist_Store
GROUP BY
    customer_city
ORDER BY
    SUM(payment_value) DESC
LIMIT 10;

/*KPI:7 card Total_Customers Count,Total_sales,Total_orders_count,Total_city_count,Total_seller_city count
		total_type_of products_count*/

select count(distinct(customer_id)) as "Total_customers",count(order_id) as "Total_orders_count" ,
Truncate(sum(payment_value),0) as "Total_sales",
count(distinct(product_categories)) as "Type_product_count",
count(distinct(customer_city)) as "Total_city_count",
count(distinct(seller_city)) as "Seller_city_count" from Olist_Store;

/*KPI:8 Monthly Sales*/
SELECT 
      Month,
      Concat('R$ ', CAST(SUM(payment_value) AS SIGNED)) AS Total_Sales
FROM
    Olist_Store
Group By
       Month
Order By 
	  SUM(payment_value) DESC;

/*KPI:9 Year wise order count & Sales_Revenue*/
SELECT
      Year,
      Count(order_id) as "Count_of_orders",
      Concat('R$ ', CAST(SUM(payment_value) AS SIGNED)) as "Sales_Revenue"
  From Olist_Store 
  GROUP BY Year
  Order by count(order_id), Sum(payment_value);


/* KPI:10 Product-wise Avg Price, Avg Delivery Charges, Avg Delivery Days & Total_Sales*/
ALTER TABLE Olist_Store
Rename column product_category_name_english TO Product_Categories;

SELECT
   Product_Categories,
  Concat('R$ ', ROUND(AVG(`price`))) AS Avg_Price,
  Concat('R$ ', ROUND(AVG(`freight_value`))) AS Avg_Delivery_Charges,
  Concat('R$ ', CAST(SUM(payment_value) AS SIGNED)) AS Total_Sales,
  Round (AVG(`Shipping Days`)) AS Avg_Delivery_Days 
FROM
    Olist_Store
GROUP BY
   Product_Categories
Order By 
   SUM(payment_value) DESC;
DELETE FROM Olist_Store
  Where Product_Categories = '';

/* KPI:11 Top 10 Product Sales*/
SELECT
	Product_Categories,
    CONCAT('R$ ', CAST(SUM(payment_value) AS SIGNED)) AS Total_Sales
FROM
    Olist_Store
GROUP BY
	Product_Categories
ORDER BY
   SUM(payment_value) DESC
LIMIT 10;

/* KPI:12 Day-wise Sales*/
SELECT
     Day,
     Count(`order_id`) AS Number_Of_Orders,
     Concat('R$ ', CAST(SUM(payment_value) AS SIGNED)) AS Total_Sales
FROM
    Olist_Store
Group By 
    Day
Order BY
    SUM(payment_value) DESC;

/*KPI:13 Top 10 seller city orders count*/
Select seller_city,count(order_id) as "No.Of.orders" From Olist_Store
Group by seller_city Order by count(order_id) Desc Limit 10;

/*STORED PROCEDURE*/

DELIMITER //

CREATE PROCEDURE Payment_Type(IN payment_parameter VARCHAR(100))
BEGIN 
     SELECT 
       payment_type,
       review_score,
       Count(`order_id`) As Number_Of_Orders,
       Concat('R$ ', CAST(SUM(payment_value) AS SIGNED)) AS Total_Sales
	 FROM
		Olist_Store
	 WHERE payment_type = payment_parameter
     GROUP BY payment_type, review_score;
End //

DELIMITER ;

Call Payment_Type('boleto');
Call Payment_Type('credit_card');
Call Payment_Type('voucher');
Call Payment_Type('debit_card');

DROP PROCEDURE Payment_Type_Sales;


  

      
      
      





