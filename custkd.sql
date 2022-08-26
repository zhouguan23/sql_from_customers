select    cc.license_code,cc.cust_id,cc.cust_name,
   case cr.rim_kind
   when '11'  then '品牌店'
   when '12'  then '精品店'
   when '13'  then '标准店'
   when '14'  then '普通店'
   end as rim,
   case   cc.cust_type3
   when '011' then '城区'
   when '012' then '镇区'
   when '013' then '特殊镇区'
   when '023' then '农村较好'
   when '024' then '农村较差'
      end as dlwz,count(p.item_id)  sl
      from  co_cust cc,crm_cust cr,
(select pm.cust_id,pm.item_id,sum(pm.qty_sold)
 from  pi_cust_item_month pm
 where  pm.date1>='${date1}'
 and pm.date1<='${date2}'
 and pm.qty_sold>0
 and pm.sale_dept_id='${dept}' 
 group by pm.cust_id,pm.item_id
 having sum(pm.qty_sold)>0)  p
 where cc.cust_id=cr.cust_id
 and cc.cust_id=p.cust_id
 and cc.status='02'
  and cc.sale_dept_id='${dept}'
 group by   cc.sale_dept_id,cc.license_code,cc.cust_id,cc.cust_name,cr.rim_kind,cc.cust_type3


