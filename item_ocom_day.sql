select   im.itemgr_name itemgr_name,ic.short_code short_id,it.item_name,ic.price_trade pri_wsale,
 sum(oc.qty_eod*t_size)/${if(len(umm)==0,200,umm)}  qty,round(sum(amt_eod)/10000,2) amt  ,im.note
from pi_com_day oc,plm_item it,plm_item_com ic,bohzuser.itemgr@orahzbo im
where oc.item_id=it.item_id
and oc.item_id=ic.item_id
and  it.brand_id=im.itemgr_id
and ic.com_id='10371701'
and oc.date1='${date1}'
and it.is_mrb=1
and oc.qty_eod<>0
group by im.itemgr_name,it.item_name,ic.short_code,ic.price_trade,im.note
order by   qty  desc

