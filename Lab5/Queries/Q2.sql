select product_name
from products-in-orders 
where SUM(quantity_on_order)>=100 AND feedback_rating_score=5 AND delivery_date >= '2021-8-1' AND delivery_date <= '2021-8-31' 
group by product_name
order by AVG(feedback_rating_score) ASC
