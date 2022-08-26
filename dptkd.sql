select     cc.sale_dept_id dept,cc.cust_id,cc.cust_type3,cr.rim_kind,count(p.item_id)  sl
      from  co_cust cc,crm_cust cr,
(select pm.cust_id,pm.item_id,sum(pm.qty_sold)
 from  pi_cust_item_month pm
 where  pm.date1>='${date1}'
 and pm.date1<='${date2}'
 and pm.qty_sold>0
 group by pm.cust_id,pm.item_id
 having sum(pm.qty_sold)>0)p
 where p.cust_id=cc.cust_id
 and p.cust_id=cr.cust_id
 and cc.status='02'
 group by cc.sale_dept_id,cc.cust_id,cc.cust_type3,cr.rim_kind
 

