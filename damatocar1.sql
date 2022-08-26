select car_id  ,region_name  , ic.short_code  ,i.item_name  ,sum(qty_ord)  qty  from
  co_co c,co_co_line cl,plm_item i,plm_item_com ic  ,ldm_dist_car lc,ldm_dist_region ldr,ldm_cust_dist lcc
  where c.co_num=cl.co_num and c.status='60' and c.pose_date='${date1}' and qty_ord<>0
  and c.cust_id=lcc.cust_id and lc.region_id=ldr.region_id and ldr.region_id=lcc.rut_id
  and lc.deliver_id='${deliverid}'  and cl.item_id=i.item_id and cl.item_id=ic.item_id 
  and c.type<>'62'
  and i.item_id in (select item_id from hz_item_abnormal) group by car_id,region_name, ic.short_code,i.item_name  order by car_id

select dpt_sale_name from dpt_sale where dpt_sale_id='${deliverid}'

