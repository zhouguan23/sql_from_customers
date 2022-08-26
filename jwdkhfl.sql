
select  soldkind ,cust_type3,count(1) hs,sum(a.qty_sold)/250 qty  ,sum(amt)/10000  amt
from cust_sold a,cust  c where a.cust_id=c.cust_id and date1='${date1}' group by soldkind ,cust_type3

select distinct soldkind,substr(soldkind,2,length(soldkind))  xm from cust_sold 
where date1='${date1}'

select  c.dpt_sale_id,soldkind,count(1) hs 
from  cust c,cust_sold cc  where status='02' and c.cust_id=cc.cust_id  
and date1='${date1}'
 group by c.dpt_sale_id,soldkind

