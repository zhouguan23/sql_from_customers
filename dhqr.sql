select  ls.cust_order,c.cust_id,cc.cust_name,cc.manager,cc.order_tel,c.qty_sum,c.amt_sum,c.pmt_status
from co_co c,co_cust cc,ldm_cust lc,ldm_dist_car  ld,ldm_cust_dist  ls
where  c.cust_id=cc.cust_id
and c.cust_id=lc.cust_id
and lc.region_id=ld.region_id
and lc.cust_id=ls.cust_id
and ld.is_mrb='1'
and ld.car_id='${carid}'
and c.born_date=(select to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual)
and c.status<>'90'
order  by ls.cust_order

select car_id,car_name from ldm_dist_car
  where is_mrb='1' 
  and car_id in 
  (select car_id from ldm_dist where dist_date=${date1} and deliver_id=${deliverid} )
  order by car_id

select c.cust_id,sum(cl.qty_ord)
from co_co c,co_co_line cl,plm_item_com pc 
 where  c.co_num=cl.co_num
 and cl.item_id=pc.item_id  
 and c.status<>'90'
 and c.born_date=(select to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual) 
 and pc.is_abnormal='1' 
  GROUP BY c.cust_id

select c.cust_id,sum(cl.qty_ord)
from co_co c,co_co_line cl,plm_item_com pc 
 where  c.co_num=cl.co_num
 and cl.item_id=pc.item_id  
 and c.status<>'90'
 and c.born_date=(select to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual) 
 and pc.is_abnormal='0' 
 and qty_ord>0
 GROUP BY c.cust_id

