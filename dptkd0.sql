select     case cc.sale_dept_id
   when '11371710' then '牡丹区'
   when '11371703' then '曹县'  
   when '11371704' then '成武'   
   when '11371705' then '单县'   
   when '11371706' then '定陶'   
   when '11371707' then '东明'   
   when '11371708' then '巨野'   
   when '11371709' then '鄄城'
   when '11371711' then '郓城'       
   end as dept,cc.cust_id,cc.cust_type3,cr.rim_kind,count(p.item_id)  sl
      from  co_cust cc,crm_cust cr,
(select pm.cust_id,pm.item_id,sum(pm.qty_sold)
 from  pi_cust_item_month pm
 where  pm.date1>='${date1}'
 and pm.date1<='${date2}'
 group by pm.cust_id,pm.item_id
 having sum(pm.qty_sold)>0)p
 where p.cust_id=cc.cust_id
 and p.cust_id=cr.cust_id
 and cc.status='02'
 group by cc.sale_dept_id,cc.cust_id,cc.cust_type3,cr.rim_kind
 

