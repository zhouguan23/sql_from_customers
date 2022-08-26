 select case cc.sale_dept_id
   when '11371710' then '牡丹区'
   when '11371703' then '曹县'  
   when '11371704' then '成武'   
   when '11371705' then '单县'   
   when '11371706' then '定陶'   
   when '11371707' then '东明'   
   when '11371708' then '巨野'   
   when '11371709' then '鄄城'
   when '11371711' then '郓城'       
   end as dept,cc.cust_id,cc.cust_type3,cr.rim_kind,a.price/10 price
 from co_cust cc,crm_cust cr,
(select cust_id,item_id,item_name,price_retail   price  from 
 (select row_number() over(partition by pm.cust_id  order by pc.price_retail  desc)  num,
 pm.cust_id,pm.item_id,pi.item_name,pc.price_retail
   from pi_cust_item_month pm,plm_item pi,plm_item_com pc
  where pm.item_id=pi.item_id
  and pm.item_id=pc.item_id
 and pc.com_id='10371701'  
   and pm.date1>='${date1}'
   and pm.date1<='${date2}'
  group by   pm.cust_id,pm.item_id,pi.item_name,price_retail
   order by cust_id)
   where num=1) a
   where a.cust_id=cc.cust_id
   and cr.cust_id=cc.cust_id
   and cc.status='02'

