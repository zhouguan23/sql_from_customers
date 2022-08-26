select pl.short_code,p.item_name,pl.price_trade,sum(qty_sold),sum(amt_sold) from  
pi_cust_item_day a,plm_item p,plm_item_com pl
where a.item_id=p.item_id and date1>='${date1}' and date1<='${date2}'
and a.item_id=pl.item_id and pl.com_id='10371701' and cust_id='${custid}'
group by  pl.short_code,p.item_name,pl.price_trade having sum(qty_sold)<>0
order by pl.short_code

select cust_name from co_cust where cust_id='${custid}'

