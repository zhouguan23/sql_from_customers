select  dp.dpt_sale_id,count(1) dhhs,sum(b.qty_sold) qtydh from co_cust c,dpt_sale dp,
 (
 select cust_id,sum(qty_sold) qty_sold
  from cust_sold
   a where  date1='${date1}' and 
   qty_sold>=(select avg(qty_sold)*5 from cust_sold  where date1='${date1}')  
   group by cust_id
  
) b where c.cust_id=b.cust_id  and c.sale_dept_id=dp.sale_dept_id
   group by dp.dpt_sale_id

select dp.dpt_sale_id, dp.short_name,count(1) dhall,sum(b.qty_sold) qtyall from  dpt_sale dp,
cust_sold b where  b.date1='${date1}'and   b.dpt_sale_id=dp.sale_dept_id
   group by   dp.dpt_sale_id, dp.short_name

