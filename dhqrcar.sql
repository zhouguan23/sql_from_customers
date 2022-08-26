 select  ld.seq,l.rut_id,c.cust_id,cc.cust_name,cc.busi_addr,cc.order_tel,ld.qty_bar,ld.amt_ar,c.pmt_status
from co_co c,co_cust cc,ldm_dist l,ldm_dist_line ld           
where  c.cust_id=cc.cust_id
and c.cust_id=ld.cust_id
and l.dist_num=ld.dist_num
and c.co_num=ld.co_num
and cc.cust_id=ld.cust_id
and l.car_id='${carid}'
and c.born_date=(select to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual)
and c.status<>'90'
order  by ld.seq

select car_id,car_name from ldm_dist_car
  where is_mrb='1' 
  and car_id in 
  (select car_id from ldm_dist where dist_date=${date1} and deliver_id=${deliverid} )
  order by car_id

select c.cust_id,sum(cl.qty_ord)
from co_co c,co_co_line cl,plm_item_com pc,hz_item_abnormal hz
 where  c.co_num=cl.co_num
 and cl.item_id=pc.item_id 
 and hz.item_id=pc.item_id 
 and c.status<>'90'
 and c.born_date=(select to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual) 
 --and pc.is_abnormal='1' 
  GROUP BY c.cust_id

select c.cust_id,sum(cl.qty_ord)
from co_co c,co_co_line cl,(select item_id from plm_item_com minus select item_id from hz_item_abnormal )  i
 where  c.co_num=cl.co_num
 and cl.item_id=i.item_id  
 and c.status<>'90'
 and c.born_date=(select to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual) 
 --and pc.is_abnormal='0' 
 --and pc.item_id not in (select item_id from hz_item_abnormal)
 and qty_ord>0
 GROUP BY c.cust_id

select rut_id,rut_name,car_id,car_name from v6user.o_dist_rut_v@heze
where  order_date=(select  to_char(to_date('${date1}','yyyy-mm-dd')-1,'yyyymmdd') from  dual)
and deliver_id=${deliverid}

