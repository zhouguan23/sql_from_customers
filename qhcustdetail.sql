select ic.short_code,i.item_name,ic.price_trade,i.kind,qty_need,qty_sold,amt_sold 
from pi_cust_item_day a,plm_item i,plm_item_com ic
where a.item_id=ic.item_id and a.item_id=i.item_id and ic.com_id='10371701'
and a.cust_id='${custid}'
and a.date1=(select to_char(to_date('${date1}','yyyyMMdd')+1,'yyyyMMdd') from dual)
order by kind,price_trade desc

select cust_name from co_cust where cust_id='${custid}'

