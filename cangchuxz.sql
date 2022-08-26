 select i.item_id,i.item_name, case when is_thin=1 then '细支' else '特异型' end as isthin ,sum(qty_sold*t_size)/50000 qty 
 from hz_item_abnormal  a,plm_item i,pi_com_month  ic  
  where   a.item_id=i.item_id and i.item_id=ic.item_id 
  and ic.date1>='${date1}' and date1<='${date2}'  and qty_sold<>0
  group by  i.item_id,i.item_name, is_thin order by is_thin

