select ct.cust_short_name,c.crt_date,c.iss_date,ic.short_id,it.item_name,ic.pri_wsale,cl.qty_req,cl.qty_ord,c.crt_user_id
from co${years} c,co_line${years} cl,cust ct,item it,item_com ic
where c.co_num=cl.co_num
and c.cust_id=ct.cust_id
and it.item_id=cl.item_id
and ic.item_id=cl.item_id
and ic.com_id='10371701'
and c.status<>'01'
and c.status<>'02'
and   c.iss_date>='${years}${start}01'
and  c.iss_date<='${years}${end}31'
and c.cust_id='${cust_id}'
order by c.iss_date

