select  ct.cust_id,ct.cust_short_name,ct.busi_addr,ct.tel,cr.note,sl.note sl,ic.short_id,it.item_name,ic.pri_wsale,sum(icm.qty_req) req,sum(icm.qty_sold)  sold
from cust ct,item_cust_month${years} icm,item it,item_com ic,slsman sl,call_rut cr
where ct.cust_id=icm.cust_id
and  it.item_id=icm.item_id
and  ic.item_id=icm.item_id
and  ic.com_id='10371701'
and  sl.slsman_id=ct.slsman_id
and  sl.com_id='10371701'
and ct.call_rut=cr.rut_id
and cr.com_id='10371701'
and  icm.iss_date>='${years}${start}'
and icm.iss_date<='${years}${end}'
and ct.slsman_id='${slsman_id}'
group by ic.short_id,it.item_name,ic.pri_wsale,ct.cust_id,ct.cust_short_name,ct.busi_addr,ct.tel,cr.note,sl.note

select note from slsman where com_id='10371701' and slsman_id=${slsman_id}

