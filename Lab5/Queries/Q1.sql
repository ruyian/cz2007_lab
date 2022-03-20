 select AVG(price) 
 from PRICE-HISTORYp
 where shop_name='Shiokee' AND product_name='iPhone Xs' AND start_date>='2021-8-1' AND end_date <='2021-8-31'
