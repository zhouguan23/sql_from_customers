select 
sm.dpt_sale_name,
sm.slsman_id,
sm.slsman_name,
cc.cust_name,
vcg.c_longitude,
vcg.c_latitude
from slsman sm
left join co_cust cc on cc.slsman_id=sm.slsman_id
left join vms_custs_gis vcg on vcg.c_id=cc.cust_id
where sm.dpt_sale_id='11371709'
and cc.status='02'
-- AND sm.slsman_id='103717010130'
order by sm.slsman_id asc

