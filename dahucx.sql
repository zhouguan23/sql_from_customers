
 select dp.short_name,c.license_code cust_id,cust_short_name,busi_addr,order_tel ,aa.qty_sold from co_cust c,dpt_sale dp,
 (
 select cust_id,sum(qty_sold) qty_sold
  from (select * from cust_month2017 where date1='${date1}' 
  union select * from cust_month2018 where date1='${date1}'
  ) 
   a where qty_sold>=(select avg(qty_sold)*5 from (select * from cust_month2017  where date1='${date1}' union select * from cust_month2018 where date1='${date1}') )
   group by cust_id
 
 
) aa where c.cust_id=aa.cust_id and c.status='02' and c.sale_dept_id=dp.sale_dept_id
and c.sale_dept_id='${dptid}'

