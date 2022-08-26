
select lr.deliver_id,sum(amt_sold) amtall
from pi_cust_item_bnd_day a,ldm_cust_dist b,ldm_dist_region lr
where a.date1='${date1}'  and a.cust_id=b.cust_id and b.rut_id=lr.region_id

group by lr.deliver_id


with cc as (
select distinct cust_id from co_trans_flow where trade_date='${date1}' and trade_flag=0
union 
select cust_id from hzdjcust
)
select lr.deliver_id,sum(amt_sold) amtsucc
from pi_cust_item_bnd_day a,ldm_cust_dist b,ldm_dist_region lr,cc
where a.date1='${date1}'  and a.cust_id=b.cust_id and b.rut_id=lr.region_id
and a.cust_id=cc.cust_id

group by lr.deliver_id

