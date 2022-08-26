select i.item_id, 
sum(qty_sold*t_size)/50000 qty
from pi_dept_item_month a,plm_item i 
where a.item_id=i.item_id 
  and is_thin=1   ${ if(len(dptid)==0,""," and a.sale_dept_id='"+dptid+"'")}
  
and a.date1 between '${date1}' and '${date2}'
group by i.item_id 

select i.brdowner_id, p.short_name,i.item_id,item_name,i.is_mrb,kind,price_trade,price_retail,tar_cont

from plm_item i,plm_item_com ic,pi_vend p
where i.item_id=ic.item_id and ic.com_id='10371701' and is_thin=1
and i.brdowner_id=p.vend_id
order by i.brdowner_id

select i.item_id, 
sum(qty_sold*t_size)/50000 qtyt
from pi_dept_item_month a,plm_item i 
where a.item_id=i.item_id 
  and is_thin=1 
  ${ if(len(dptid)==0,""," and a.sale_dept_id='"+dptid+"' ")}
and a.date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm') from dual)
and date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm') from dual)
group by i.item_id 

select i.item_id, 
sum(qty_sold*t_size)/50000 qty
from pi_dept_item_month a,plm_item i 
where a.item_id=i.item_id 
  and is_thin=1 
  ${ if(len(dptid)==0,""," and a.sale_dept_id='"+dptid+"'")}
 
  
and date1>=(select to_char(to_date('${date1}','yyyymm')-(to_date('${date2}','yyyymm')-to_date('${date1}','yyyymm')+1),'yyyymm') from dual)
and date1<=(select to_char(to_date('${date2}','yyyymm')-(to_date('${date2}','yyyymm')-to_date('${date1}','yyyymm')+1),'yyyymm') from dual)

group by i.item_id 


