select  d.car_id,  d.deliver_id, vc.sc_external_name dspt,sum(dl.qty_bar) qty ,sum(amt_ar) amt 

from vms_send_cars@heze vc, ldm_dist d,ldm_dist_line dl
where vc.sc_external_id=d.car_id and dist_date>='${date1}' and dist_date<='${date2}'
and dl.dist_num=d.dist_num and d.is_mrb=1
 and d.com_id='10371701'
  and d.deliver_id='${dptno}'
group by d.car_id,  d.deliver_id, vc.sc_external_name
order by d.car_id


select  car_id,bank_id,sum(qty_trade) qtydj from 
ldm_dist_line dl,ldm_dist l,

(
select * from co_trans_flow where 
trade_date>=(select   to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual)
and trade_date<=(select   to_char(to_date('${date2}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual) and trade_flag=0 
) a 
where dl.co_num=a.co_num and l.deliver_id='${dptno}'
and dl.dist_num=l.dist_num and   l.is_mrb=1 and 
l.dist_date>='${date1}' and l.dist_date<='${date2}'
group by car_id,bank_id

