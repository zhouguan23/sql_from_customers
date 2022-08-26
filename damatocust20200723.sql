 select car_id, ldl.seq,license_code,cust_short_name, ic.short_code,i.item_name,sum(cl.qty_ord) qty  from
  co_co c,co_co_line cl,plm_item i,plm_item_com ic,ldm_dist ld,ldm_dist_line  ldl,co_cust cc
  where c.co_num=cl.co_num and c.status='60' and c.pose_date='${date1}' and qty_ord<>0
  and c.co_num=ldl.co_num and ld.dist_num=ldl.dist_num  and ldl.cust_id=cc.cust_id
  and ld.car_id='${carid}'
  and cl.item_id=i.item_id and cl.item_id=ic.item_id  
  and c.cust_id=cc.cust_id 
  and i.item_id in (select item_id from hz_item_abnormal) 
  group by car_id, ldl.seq,license_code,cust_short_name, ic.short_code,i.item_name
  order by ldl.seq

select dpt_sale_name from dpt_sale where dpt_sale_id='${deliverid}'

select car_id,car_name from ldm_dist_car where car_id in 
(select car_id from ldm_dist where dist_date='${date1}' and deliver_id='${deliverid}' ) order by car_id

select car_name from ldm_dist_car where car_id='${carid}'

