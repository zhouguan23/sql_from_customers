select   pi.item_name,pc.short_code,cl.price,sum(cl.qty_ord),sum(cl.amt)
from co_co c,co_co_line  cl,co_cust cc,plm_item_com pc,plm_item  pi
where c.co_num=cl.co_num
and c.cust_id=cc.cust_id
and pc.item_id=cl.item_id
and pi.item_id=cl.item_id
and pc.com_id='10371701'
and c.status='60'
and cl.qty_ord>0
and cc.tax_account='${tax}'
and c.born_date>='${date1}'
and c.born_date<='${date2}'
group by  pi.item_name,pc.short_code,cl.price

