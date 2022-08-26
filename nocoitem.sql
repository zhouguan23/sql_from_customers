select ic.item_id,item_name,i.brdowner_id,price_trade from plm_item  i,plm_item_com ic
where  i.item_id=ic.item_id and i.is_mrb=1 and ic.is_mrb=1 and ic.com_id='10371701'
and i.item_kind=1 order by i.brdowner_id,price_trade desc

select c.cust_id,cust_short_name,busi_addr,order_tel,cust_seg,
case when periods_id='HZ0701' or periods_id='HZ1401' or periods_id='HZ1408' then '周一'
  when periods_id='HZ0702' or periods_id='HZ1402' or periods_id='HZ1409' then '周二'
  when periods_id='HZ0703' or periods_id='HZ1403' or periods_id='HZ1410' then '周三'
  when periods_id='HZ0704' or periods_id='HZ1404' or periods_id='HZ1411' then '周四'
  when periods_id='HZ0705' or periods_id='HZ1405' or periods_id='HZ1412' then '周五'
end as callrut
from co_cust c,csc_cust cs   where  c.cust_id=cs.cust_id and c.status='02' 
and cust_seg in ('${custseg}') and c.cust_id in 
(select cust_id from co_cust where status='02' and sale_dept_id like '${dpt}'
minus
select distinct cust_id from pi_cust_item_bnd_day where  sale_dept_id like '${dpt}' and 
date1>='${date1}'  and date1<='${date2}' and item_id='${itemid}' and qty_sold<>0

) order by c.cust_id

select distinct cust_seg from co_cust where cust_seg is not null order by cust_seg

