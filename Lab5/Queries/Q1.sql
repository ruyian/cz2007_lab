 select avg(price) 
 from price-history 
 where shop_name='Shiokee' and product_name='iPhone Xs' and start_date>='2021-8-1' and end_date <='2021-8-31'
