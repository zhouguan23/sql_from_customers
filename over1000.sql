select  ds.short_name,ct.cust_id,ct.cust_short_name,ct.busi_addr,ct.tel,qty_sold
from cust_month${years} cm,cust ct,dpt_sale ds
where cm.cust_id=ct.cust_id
and ds.dpt_sale_id=ct.dpt_sale_id
and cm.date1='${time}'
and cm.qty_sold>=1000
order by ds.dpt_sale_id_new,qty_sold desc

select  ds.short_name,ct.cust_id,ct.cust_short_name,ct.busi_addr,ct.tel,it.item_name,qty_sold
from item_cust_month${years} icm,cust ct,dpt_sale ds,item it,item_com ic
where icm.cust_id=ct.cust_id
and ds.dpt_sale_id=ct.dpt_sale_id
and icm.item_id=it.item_id
and icm.item_id=ic.item_id
and ic.com_id='10371701'
and icm.iss_date='${time}'
and icm.qty_sold>200
order by ds.dpt_sale_id_new,qty_sold desc

