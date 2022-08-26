
 
select case  device_id when 'SJ01' then '分拣线1' when 'SJ02' then '分拣线2' when 'SJ03' then '分拣线3' when 'SJ04' then '分拣线4'
 when 'SJ05' then '异型烟' end as fj,qtyall,qtysucc from (

 select aa.device_id,qtyall,qtysucc  from 
 (
  select  a.device_id,sum(qty) qtyall from 
( select  distinct device_id, distribution_id from  t_order_box t) a,
 ( select order_id,sum(need_quantity) qty  from t_order_bill a,  t_cig_dic  b
where  a.product_id=b.product_id and  b.is_pick='1'  group by order_id) cc
    where  a.distribution_id=cc.order_id group by device_id) aa,
 (
  select  a.device_id,sum(qty) qtysucc from 
( select  distinct device_id, distribution_id from  t_order_box t where status='3'   ) a,
 ( select order_id,sum(need_quantity) qty  from t_order_bill a,  t_cig_dic  b
where  a.product_id=b.product_id and  b.is_pick='1' and  status='3'  group by order_id ) cc
where  a.distribution_id=cc.order_id group by device_id
) bb   where bb.device_id(+)=aa.device_id

union 
select 'SJ05'  device_id, qtyall,qtysucc from 
(
select   sum(need_quantity) qtyall  from t_order_bill where  product_id  
      in (select product_id from t_cig_dic t where is_pick=0)  ),
      (
select  sum(need_quantity) qtysucc  from t_order_bill where  status=3  and  product_id  
      in (select product_id from t_cig_dic t where is_pick=0)  )
      
 )

select  case  a.device_id when 'SJ01' then '分拣线1' when 'SJ02' then '分拣线2' when 'SJ03' then '分拣线3' when 'SJ04' then '分拣线4'
 when 'SJ05' then '异型烟' end as device_id,custall,custsucc from 
(
select device_id,count(distinct distribution_id) custall
from  t_order_box group by device_id
) a,
(
select device_id,count(distinct distribution_id) custsucc
from  t_order_box  where status=3 group by device_id
) b where b.device_id(+)=a.device_id

