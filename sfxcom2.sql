select com_id,com_name from s_com order by note

select com_id,sum(qty_sold*t_size)/50000 qtyb,sum(amt_sold)/100000000 amt from s_com_day a,plm_item i 
where date1>=(select to_char(sysdate,'yyyyMM')||'01' from dual)
and a.item_id=i.item_id 
group by com_id

select com_id,sum(qty_sold*t_size)/50000 qtyy,sum(amt_sold)/100000000 amty from s_com_day a,plm_item i 
where date1>=(select to_char(sysdate,'yyyy')||'0101' from dual)
and a.item_id=i.item_id 
group by com_id

select com_id,sum(qty_sold*t_size)/50000 qtysb,sum(amt_sold)/100000000 amtsb 
from s_com_day a,plm_item i 
where 
 date1>=(select  to_char(add_months( sysdate, -12) ,'yyyyMM')||'01' from dual)
and 
date1<=(select  to_char(add_months( sysdate, -12) ,'yyyyMMdd') from dual)
and a.item_id=i.item_id 
group by com_id


select com_id,sum(qty_sold*t_size)/50000 qtysy,sum(amt_sold)/100000000 amtsy 
from s_com_day a,plm_item i 
where 
 date1>=(select  to_char(add_months( sysdate, -12) ,'yyyy')||'0101' from dual)
and 
date1<=(select  to_char(add_months( sysdate, -12) ,'yyyyMMdd') from dual)
and a.item_id=i.item_id 
group by com_id

