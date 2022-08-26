select  cl.item_id,pi.item_name,sum(cl.qty_ord),sum(cl.amt)
from ldm_dist ld,ldm_dist_line  l,co_co c,co_co_line cl,plm_item pi,co_cust cc
where ld.dist_num=l.dist_num
and c.co_num=l.co_num
and c.co_num=cl.co_num
and cl.item_id=pi.item_id
and c.cust_id=cc.cust_id
and  c.born_date='20210126'
and ld.rut_id='SHXL0000000298'
and cc.tax_account='372901724812645'
and cl.qty_ord>0
group by cl.item_id,pi.item_name

