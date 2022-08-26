select  brdowner_id,p.short_name,round(sum(qty_sold*t_size)/50000,0) qty ,
 
round(sum(amt_sold)*50000/sum(qty_sold*t_size),0) dxamt
from pi_com_month a,plm_item i,pi_vend p
 where a.item_id=i.item_id and i.brdowner_id=p.vend_id and date1>='${date1}' 
 and date1<='${date2}'  and qty_sold<>0
 group by brdowner_id,p.short_name  order by sum(qty_sold) desc

