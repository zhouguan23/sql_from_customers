select  c.slsman_id,i.item_id,i.item_name,ic.price_trade,i.kind,sls.note,sum(cl.qty_ord*i.t_size)/200 qty from co_co c,co_co_line cl, plm_item i ,slsman sls,plm_item_com ic

where c.co_num=cl.co_num and c.status<>'90'  and c.slsman_id=sls.slsman_id and sls.com_id='10371701'

and cl.item_id=i.item_id   and cl.item_id=ic.item_id and ic.com_id='10371701'
 and c.born_date>='${date1}' and c.born_date<='${date2}'  
and sls.dpt_sale_id='${dptno}'
 group by c.slsman_id,i.item_id,i.item_name,ic.price_trade,i.kind,sls.note having sum(cl.qty_ord)<>0 order by ic.price_trade desc

select i.item_id,item_name,price_trade pri_wsale,kind  from plm_item i ,plm_item_com ic 

where i.item_id=ic.item_id and ic.com_id='10371701'
and i.item_id in 
(select distinct item_id from  co_co c,co_co_line cl where c.co_num=cl.co_num
and   c.born_date>='${date1}' and c.born_date<='${date2}' 
 and c.sale_dept_id=('${dptno}')
group by item_id having sum(qty_ord)<>0 
) order by price_trade desc

select slsman_id,note from slsman where com_id='10371701'  and is_mrb=1 and 
dpt_sale_id=${dptno}  

