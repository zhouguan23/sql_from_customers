select item_id,qty,count(1) hnum,count(1)*qty/250 qtysold from (
select c.co_num,item_id,sum(qty_ord) qty from co_co c,co_co_line cl
where c.co_num=cl.co_num and item_id in ('${itemid}')
and c.born_date>='${date1}' and c.born_date<='${date2}'
and c.status!='90' group by item_id,c.co_num having 
sum(qty_ord)>0
)  where qty in (${pri1},${pri2},${pri3},${pri4},${pri5},${pri6},${pri7},${pri8},${pri9})
group by item_id,qty order by qty asc

select i.item_id,ic.short_code||'-'||item_name||'-'||price_trade itemname from plm_item i,
plm_item_com ic
where i.item_id=ic.item_id and ic.is_mrb=1 and i.is_mrb=1
and i.is_mrb=1 and i.item_kind=1
and ic.com_id='10371701' order by i.brdowner_id,ic.short_code

select i.item_id,ic.short_code,item_name from plm_item i,plm_item_com ic
 where i.item_id=ic.item_id and ic.com_id='10371701' and i.item_id in 
('${itemid}')

select item_id,count(1) qtyhm,sum(qty) qty from 
(
select c.co_num,item_id,sum(cl.qty_ord)/250 qty 
from co_co  c,co_co_line cl
where c.co_num=cl.co_num and item_id in ('${itemid}')
and c.born_date>='${date1}' and c.born_date<='${date2}'
and c.status!='90' group by c.co_num,item_id  having sum(qty_ord)>0
) group by item_id

