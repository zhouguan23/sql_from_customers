select c.cust_id,c.cust_name,c.busi_addr,c.order_tel,sum(a.qty_sold) qty

from co_cust c,pi_cust_item_day  a
where a.cust_id=c.cust_id and c.status='02'
 and a.date1>='${date1}' and a.date1<='${date2}'
and c.sale_dept_id='${dpt}'
group by c.cust_id,c.cust_name,c.busi_addr,c.order_tel having sum(a.qty_sold)>=${qty}

order by sum(a.qty_sold) desc

