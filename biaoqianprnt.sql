select i.item_id, item_name,brdowner_name,substr(brdowner_name,1,2),spec,h_size,t_size,price_retail,price_retail/10 
from plm_item i,plm_item_com ic,plm_brandowner p
where i.item_id=ic.item_id and ic.com_id='10371701' and i.is_mrb=1
and i.brdowner_id=p.brdowner_id and i.item_id='${itemid}'

select i.item_id,ic.short_code||'-'||item_name||'-'||price_trade itemname from plm_item i,
plm_item_com ic where i.item_id=ic.item_id and ic.com_id='10371701'
and ic.is_mrb=1 and i.is_mrb=1  and i.item_kind=1 order by i.brdowner_id,ic.short_code

