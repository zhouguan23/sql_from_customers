 
with c as(
 select c.cust_id, item_id, sum(qty_ord) qty from co_co c,co_co_line cl 
 where c.co_num=cl.co_num and cl.qty_ord<>0
 and c.status<>'90' and c.sale_Dept_id='${dpt}' 
 and c.born_date>='${starttime}' and c.born_date<='${endtime}'
  group by c.cust_id,item_id )
  

select  ic.short_code ,it.item_name,ic.price_trade pri_wsale, sl.note  slsnote ,sum(c.qty)  qty
from c,slsman sl,plm_item_com ic,plm_item it,co_cust cc
where     c.cust_id=cc.cust_id 
   and cc.slsman_id=sl.slsman_id  
 
and c.item_id=ic.item_id
and c.item_id=it.item_id
and ic.com_id='10371701'
and sl.com_id='10371701' 
 
group by ic.short_code ,it.item_name, price_trade,sl.note   
order by ic.short_code

