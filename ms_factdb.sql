select  brdowner_id,p.short_name,
round(sum(qty_sold_month*t_size)/50000,0) qtymonth ,
round(sum(qty_sold_month_same*t_size)/50000,0) qtymontht,
round(sum(qty_sold_year*t_size)/50000,0) qtyyear ,
round(sum(qty_sold_year_same*t_size)/50000,0) qtyyeart

from pi_com_item_day a,plm_item i,pi_vend p
 where a.item_id=i.item_id and i.brdowner_id=p.vend_id and date1='${date1}' 
 
 group by brdowner_id,p.short_name  order by sum(qty_sold_year) desc

