
select  c.cust_id,cust_short_name,busi_addr,order_tel,
case status when '02' then '有效' when '03' then '暂停' else  '注销' end as status,b.qty_sold from co_cust c,dpt_sale dp,
 (
 select cust_id,sum(qty_sold) qty_sold
  from cust_sold where date1='${date1}' 
  and qty_sold>=(select avg(qty_sold)*5 from cust_sold where date1='${date1}') 
   group by cust_id
  
) b where c.cust_id=b.cust_id  and c.sale_dept_id=dp.sale_dept_id
and substr(c.sale_dept_id,5,4)||'0100'='${dptid}'
order by qty_sold desc

