select c.sale_dept_id,i.item_id,ic.short_code,item_name,ic.price_trade,sum(qty_ord*t_size)/50000 qty from 
co_co c,co_co_line cl,plm_item i,plm_item_com ic 
where c.co_num=cl.co_num and cl.item_id=i.item_id and i.item_id=ic.item_id
and ic.com_id='10371701'
and c.born_date='${time1}'
 
and c.status in ('20','30','40','50','60')
group by c.sale_dept_id,i.item_id,ic.short_code,item_name,ic.price_trade
having sum(qty_ord)<>0 order by ic.short_code 

