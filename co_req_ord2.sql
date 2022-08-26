select icm.dpt_sale_id,ct.slsman_id,ct.cust_id,ct.cust_short_name,ct.busi_addr,ct.tel,cr.note,sum(icm.qty_req)  req,sum(icm.qty_sold)  sold
from item_cust_month${years} icm, cust ct,call_rut cr,item_com ic
 where icm.cust_id=ct.cust_id
and icm.item_id=ic.item_id
and ct.call_rut=cr.rut_id
and cr.com_id='10371701'
and ct.status='02'
and ct.slsman_id='${slsman_id}'
and  icm.iss_date>='${years}${start}'
and icm.iss_date<='${years}${end}'
and ic.com_id='10371701'
${if(len(short_id)==0,"", " and ic.short_id='"+short_id+"'")}
group by icm.dpt_sale_id,ct.slsman_id,ct.cust_id,ct.cust_short_name,ct.busi_addr,ct.tel,cr.note

 select note from slsman where com_id='10371701' and slsman_id='${slsman_id}'

