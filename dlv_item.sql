 
select ic.short_code short_id,im.item_name,sum(dist_item.qty) qty,sum(dist_item.amt) amt
from ldm_dist dist,ldm_dist_item dist_item,plm_item im,plm_item_com ic
where dist.dist_num=dist_item.dist_num
and dist_item.item_id=im.item_id
and im.item_id=ic.item_id
and ic.com_id='10371701'  and  dist.is_mrb=1 
and dist.dist_date='${date1}'
and dist.car_id like '${carid}'

group by ic.short_code,im.item_name
 

