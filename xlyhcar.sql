select  case when vl.sl_send_area_id='CZ0000010' then '直送'
when vl.sl_send_area_id='CZ0000009' then '成武'
when vl.sl_send_area_id='CZ0000008' then '单县'
when vl.sl_send_area_id='CZ0000007' then '曹县'
when vl.sl_send_area_id='CZ0000006' then '东明'
when vl.sl_send_area_id='CZ0000005' then '鄄城'
when vl.sl_send_area_id='CZ0000004' then '郓城'
when vl.sl_send_area_id='CZ0000003' then '巨野'  end as deliver,
vl.sl_id,sl_name,vc.sc_external_id,vc.sc_external_name,vc.sc_car_number
from vms_send_lines  vl,vms_send_cars vc 
where vc.sc_id=vl.sl_def_car_no
and  sc_external_id is  not null   
and sc_available='1'
and  sc_send_area_id is not null  
and (length(sl_id)=7  or length(sl_id)=9)
ORDER BY deliver

