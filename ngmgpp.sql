
select a.co_num,c.cust_id,cust_name,b.qty,qty_sum from co_cust c, (
select co_num,cust_id,qty_sum  from co_co where born_date='${date1}' and status<>'90') a,
(
select co_num,sum(qty_ord) qty  from co_co_line where co_num in 
(select co_num from co_co where born_date='${date1}' and status<>'90') and item_id in (

'6901028118828','6901028075015','6901028075022','6901028118187' ) group by co_num having sum(qty_ord)>=${qty}
) b where a.co_num=b.co_num and a.cust_id=c.cust_id and qty/qty_sum*100>=${bl}

