    select ld.car_id,lr.rut_name,ic.short_code,i.item_name,sum(li.qty)  qty 
  from ldm_dist ld,ldm_dist_item li,v6user.o_dist_rut_v@heze lr,plm_item_com ic,plm_item i
  where ld.dist_num=li.dist_num
  and ld.rut_id=lr.rut_id
  and li.item_id=ic.item_id
  and li.item_id=i.item_id
  and ic.com_id='10371701'
  and ld.deliver_id='${deliverid}'
  and ld.dist_date='${date1}'
  and lr.order_date=(select to_char(to_date('${date1}','yyyy-mm-dd')-1,'yyyymmdd') from dual)
  and li.item_id in (select item_id from hz_item_abnormal)
  group by  ld.car_id,lr.rut_name,ic.short_code,i.item_name
  

 select dpt_sale_name from dpt_sale where dpt_sale_id='${deliverid}'

