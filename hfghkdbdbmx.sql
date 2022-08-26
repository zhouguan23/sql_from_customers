select     cc.sale_dept_id  dept,cc.cust_id,cc.cust_name,cc.cust_type3,cr.rim_kind,count(p.item_id)  sl
      from  co_cust cc,crm_cust cr,
(select pm.cust_id,pm.item_id,sum(pm.qty_sold)
 from  pi_cust_item_month pm
 where    pm.date1>='${date1}'
 and pm.date1<='${date2}'
 and pm.qty_sold>0
 and cust_id  in (
 
 select wdh.cust_id from 
( ((select   distinct ch.cust_id
from (select * from csc_cust_orderdate_his union all select * from csc_cust_orderdate)  ch,co_cust cc
where  cc.cust_id=ch.cust_id
and ch.call_date>='${date3}'
and ch.call_date<='${date4}'
and cc.status='02'
)  minus
(select  distinct c.cust_id from co_co  c,co_cust cc
where c.cust_id=cc.cust_id
and c.born_date>='${date3}'
and c.born_date<='${date4}'
and cc.status='02'
and c.status='60'
)) union all

(select  distinct  ca.cust_id from 
co_cust c, (select * from csc_cust_orderdate_his union all select * from csc_cust_orderdate) ca
 where c.cust_id=ca.cust_id and call_date>='${date5}' and call_date<='${date6}' and c.status='02'  minus
 select  distinct cs.cust_id from 
 (select * from csc_cust_orderdate_his union all select * from csc_cust_orderdate)  cs,co_cust c
 where c.cust_id=cs.cust_id and  call_date>='${date3}' and call_date<='${date4}' and status='02')) wdh,  

(select distinct c.cust_id from co_co  c,co_cust cc
where c.cust_id=cc.cust_id
and c.born_date>='${date5}'
and c.born_date<='${date6}'
and cc.status='02'
and c.status='60'
) ydh
where ydh.cust_id=wdh.cust_id    
 )
 
 group by pm.cust_id,pm.item_id
 having sum(pm.qty_sold)>0)p
 where p.cust_id=cc.cust_id
 and p.cust_id=cr.cust_id
 and cc.status='02'
  group by cc.sale_dept_id,cc.cust_id,cc.cust_name,cc.cust_type3,cr.rim_kind

