select brand_id,brand_name from plm_brand where brand_id in 
(select distinct  brand_id from plm_item i,plm_item_com ic
where i.item_id=ic.item_id and i.is_mrb=1 and ic.is_mrb=1)
order by is_key_brd,brand_name

select sale_dept_id,item_name,sum(qty_sold*t_size)/50000 qty from 
pi_dept_item_month a,plm_item i
where a.item_id=i.item_id
and date1>='${date1}'
and date1<='${date2}'
and i.brand_id='${brandid}'
and qty_sold<>0 group by sale_dept_id,item_name

