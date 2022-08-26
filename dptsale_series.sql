select dpt_sale_id,date1,qty_plan/250 qtyplan,dxamt_plan amtplan from plan 
where date1>=${date1} and date1<=${date2}  and type='01'

select dpt_sale_id,date1,round(sum(qty_sold*i.rods)/50000,1) qty,
round(sum(amt_sold_with_tax)*50000/sum(qty_sold*i.rods),0) dxamt
from item_dpt_sale_month a,item i  where a.item_id=i.item_id and date1>=${date1} and date1<=${date2}
group by dpt_sale_id,date1

