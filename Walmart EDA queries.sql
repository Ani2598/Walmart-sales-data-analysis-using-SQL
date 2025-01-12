create database Ecommerce;
use Ecommerce;
show tables;
select count(*) from walmart_clean_data;
-- Business Problem Q1: Find different payment methods, number of transactions, and quantity sold by payment method
SELECT 
    payment_method,
    COUNT(*) AS no_payments,
    SUM(quantity) AS no_qty_sold
FROM walmart_clean_data
GROUP BY payment_method;  
 #2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating 
select * from
(  select 
    branch,category,
    avg(rating) as avg_rating,
    rank() over(partition by branch order by avg(rating)desc) as rank_rating
from walmart_clean_data
group by branch,category
) as ranked
where rank_rating =1;
select *
from
   (select 
      branch,
       dayname(str_to_date(date,'%d-%m-%y')) as day_name,
	  count(*) as no_transactions,
      rank() over(partition by branch order by count(*) desc) as rank_transaction
    from walmart_clean_data
    group by branch,day_name
)as ranked
where rank_transaction=1;
-- Q4: Calculate the total quantity of items sold per payment method
SELECT 
    payment_method,
    SUM(quantity) AS no_qty_sold
FROM walmart_clean_data
GROUP BY payment_method;
-- Q5: Determine the average, minimum, and maximum rating of categories for each city
select 
city,
category,
 min(rating) as min_rating,
 max(rating) as max_rating,
 avg(rating) as avg_rating
from walmart_clean_data
group by city,category;
-- Q6: Calculate the total profit for each category,ordered from highest to lowest
select
category,
sum(unit_price*quantity*profit_margin) as total_profit
from walmart_clean_data
group by category
order by total_profit desc;
-- Q7: Determine the most common payment method for each branch
with cte as
		(SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_trans
    FROM walmart_clean_data
    GROUP BY branch, payment_method
    )
select * from cte where rank_trans=1;
-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts , findout each of the shift and total invoices
select 
	branch,
    case
		when hour(time(time))<12 then 'Morning'
        when hour(time(time))between 12 and 17 then 'Afternoon'
        else 'Evening'
    end as shift,
  count(*) as num_invoices
  from walmart_clean_data
  GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;



 
