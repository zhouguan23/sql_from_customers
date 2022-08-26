select ic.short_code,i.item_name,cl.price price_trade,sum(cl.qty_ord) qty from 
co_co_line cl,ldm_dist l,ldm_dist_line dl,plm_item_com ic,plm_item i
where cl.item_id=i.item_id and ic.item_id=i.item_id and dl.co_num=cl.co_num
and dl.dist_num=l.dist_num and l.car_id like '${carid}%'
and ic.com_id='10371701' and l.dist_date>='${time1}'
and l.dist_date<='${time2}' and l.is_mrb=1
group by  ic.short_code,i.item_name,cl.price having sum(qty_ord)<>0
order by ic.short_code

