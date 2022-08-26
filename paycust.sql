
select dl.seq,ct.license_code cust_id,cust_short_name,order_tel,car_id ,dl.qty_bar,amt_ar amt, 
case when trade_flag=0 then 0
else  1 end as trust_flag  from 
(select  co_num,trade_flag  from co_trans_flow  where trade_date=(
select   to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual  )
  and trade_flag=0
) bb,
ldm_dist_line dl, co_cust ct ,ldm_dist l where dl.dist_num=l.dist_num and 
 l.dist_date='${date1}'  and  l.is_mrb=1 
  and l.car_id like  '${carid}%'
and dl.cust_id=ct.cust_id 
and bb.co_num(+)=dl.co_num order by seq

select car_id,car_name from ldm_dist_car
  where is_mrb='1' 
  and car_id in 
  (select car_id from ldm_dist where dist_date=${date1} and deliver_id=${deliverid} )
  order by car_id


