select  cl.item_id,p.item_name,cl.qty_need,cl.qty_ord
from co_co_line  cl,plm_item p
where   p.item_id=cl.item_id
and co_num='${conum}'
and qty_ord>0
order by qty_ord desc

