select c.cust_id,
ic.short_code short_id,i.item_name,ic.price_trade pri_wsale,a.qty_sold
from co_cust c,plm_item_com ic,plm_item i ,pi_cust_item_bnd_day a
where c.cust_id=a.cust_id and a.item_id=i.item_id and a.item_id=ic.item_id and ic.com_id='10371701'
and a.date1='${date1}'
and a.cust_id='${custid}' and a.qty_sold<>0
order by ic.price_trade desc



select cust_name,busi_addr,order_tel tel,license_code cig_lice_id,
case when cust_type1='01' then '农村'
 when cust_type1='02' then '乡镇'
  when cust_type1='03' then '城区'
 else '未定义' end as  diwhere,
case when base_type='Z' then '食杂店'
when base_type='B' then '便利店'
when base_type='S' then '超市'
when base_type='N' then '商场'
when base_type='Y' then '烟酒店'
when base_type='F' then '娱乐服务'
when base_type='Q' then '其他'
else '未知' end as yetai ,sls.note
from co_cust c,slsman sls  where c.slsman_id=sls.slsman_id and sls.com_id='10371701'
and  cust_id='${custid}'

