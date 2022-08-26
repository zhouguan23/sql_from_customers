select vend_id fact_id,substr(vend_name,1,4) fact_name,
yieldly_type is_imported,brand_id itemgr_id,i.item_id,item_name,
price_trade*200/i.t_size pri,price_retail pri_rtl
 from pi_vend f,plm_item i ,plm_item_com ic where i.item_id=ic.item_id and ic.com_id='10371701'
and  f.vend_id=i.brdowner_id and i.is_mrb=1 and i.item_id in 
(select distinct item_id from pi_com_day
where Date1>='${date1}' and Date1<='${date2}'
and  qty_sold<>0
)

order by vend_id

select c.sale_dept_id dpt_sale_id,i.item_id,cl.price pri,sum(cl.qty_ord*i.t_size)/50000 qty from co_co c,co_co_line cl,plm_item i 
where c.co_num=cl.co_num and c.born_date>='${date1}' and c.born_date<='${date2}'
 and cl.item_id=i.item_id  and c.status in ('30','40','50','60','09')  group by 
c.sale_dept_id,i.item_id,cl.price
having sum(qty_ord)<>0



select c.sale_dept_id dpt_sale_id,i.item_id,item_name,ic.price_trade pri_wsale,sum(cl.qty_ord*i.t_size)/50000 qty from co_co c,co_co_line cl,plm_item i ,plm_item_com ic
where c.co_num=cl.co_num and c.born_date>='${date1}' and c.born_date<='${date2}'
 and cl.item_id=i.item_id  and c.status in  ('30','40','50','60','09')
and i.item_id=ic.item_id and ic.com_id='10371701'
and i.brand_id='0046'
and ic.price_retail>=100  group by c.sale_dept_id,i.item_id,i.item_name,ic.price_trade 

having sum(cl.qty_ord)<>0


