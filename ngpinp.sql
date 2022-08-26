select i.item_id,item_name||'-'||ic.pri_wsale from item_com ic,plm_item i 
where ic.item_id=i.item_id and ic.is_mrb=1
and i.is_mrb=1 and item_kind=1
order by ic.short_id

select  item_id, license_code,cust_short_name,busi_addr,cust_seg,pay_type,cust_type3,order_tel,
sum(a.qty_sold) qty 
from co_cust c,pi_cust_item_day a
where c.cust_id=a.cust_id and item_id='${itemid}'
and date1='${date1}'
group by license_code, item_id,cust_short_name,busi_addr,cust_seg,pay_type,cust_type3,order_tel
having sum(a.qty_sold)>=${qty} order by license_code

