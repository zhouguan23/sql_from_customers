 select  ld.seq,lr.rut_name,c.cust_id,cc.cust_name,cc.busi_addr,cc.order_tel,ld.qty_bar,ld.amt_ar,c.pmt_status,l.car_id
from co_co c,co_cust cc,ldm_dist l,ldm_dist_line ld,ldm_dist_rut  lr                 
where  c.cust_id=cc.cust_id
and c.cust_id=ld.cust_id
and l.dist_num=ld.dist_num
and c.co_num=ld.co_num
and cc.cust_id=ld.cust_id
and l.rut_id=lr.rut_id
and l.rut_id='${rutid}'
and c.born_date=(select to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual)
and c.status<>'90'
order  by ld.seq

select car_id,car_name from ldm_dist_car
  where is_mrb='1' 
  and car_id in 
  (select car_id from ldm_dist where dist_date='${date1}' and deliver_id='${deliverid}' )
  order by car_id

select rut_id,rut_name from ldm_dist_rut
where  is_mrb='1' and 
rut_id in 
(select rut_id from ldm_dist where  dist_date=${date1} and deliver_id=${deliverid})
order by rut_id

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

