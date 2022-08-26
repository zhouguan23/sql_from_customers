select dp.sale_dept_id,dp.short_name, round(sum(qty_sold*t_size)/50000,1) qty ,
case when sum(qty_sold)<>0 then round(sum(amt_sold)*50000/sum(qty_sold*t_size),0)
else 0 end as  dxamt,round(sum(gross_profit)/10000,2) profit
from pi_dept_item_day a,plm_item i,dpt_sale dp  where
a.sale_dept_id=dp.dpt_sale_id and a.item_id=i.item_id and date1=(select to_char(sysdate,'yyyyMMdd') from dual)
  group by dp.sale_dept_id,dp.short_name

select  
case when sum(qty_sold)<>0 then '销量:'|| round(sum(qty_sold*t_size)/50000,1)||', 单箱额:'||
round(sum(amt_sold)*50000/sum(qty_sold*t_size),0)||', 毛利:'||round(sum(gross_profit)/10000,2)
else '' end as aa  
from pi_dept_item_day a,plm_item i   where
 a.item_id=i.item_id and date1=(select to_char(sysdate,'yyyyMMdd') from dual)
 

select dp.sale_dept_id,dp.short_name, round(sum(qty_sold*t_size)/50000,1) qty ,

case when sum(qty_sold)<>0 then round(sum(amt_sold)*50000/sum(qty_sold*t_size),0) 
else 0 end as dxamt,round(sum(gross_profit)/10000,2) profit
from pi_dept_item_day a,plm_item i,dpt_sale dp  where
a.sale_dept_id=dp.dpt_sale_id and a.item_id=i.item_id and date1>=(select to_char(sysdate,'yyyyMM')||'01' from dual)
and date1<=(select to_char(sysdate,'yyyyMMdd') from dual)
  group by dp.sale_dept_id,dp.short_name

select case when sum(qty_sold)<>0 then '销量:'|| round(sum(qty_sold*t_size)/50000,1)||', 单箱额:'||
round(sum(amt_sold)*50000/sum(qty_sold*t_size),0)||', 毛利:'||round(sum(gross_profit)/10000,2)
 else '' end as aa
from pi_dept_item_day a,plm_item i   where
 a.item_id=i.item_id and date1>=(select to_char(sysdate,'yyyyMM')||'01' from dual)
 and date1<=(select to_char(sysdate,'yyyyMMdd') from dual)

