select sl_id,sl_name,sc_external_id,sc_external_name,sc_car_number
from vms_send_lines vl,vms_send_cars vc
where vl.sl_def_car_no=vc.sc_id
and （length(sl_id)=7  or length(sl_id)=9)
order by sl_id 

