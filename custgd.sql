 select license_code,cust_id,cust_name, 
 case rim_kind
   when '11'  then '品牌店'
   when '12'  then '精品店'
   when '13'  then '标准店'
   when '14'  then '普通店'
   end as rim, order_tel,
    case   cust_type3
   when '011' then '城区'
   when '012' then '镇区'
   when '013' then '特殊镇区'
   when '023' then '农村较好'
   when '024' then '农村较差'
      end as dlwz,
 item_id,item_name,price_retail from 
 (select row_number() over(partition by c.cust_id  order by pc.price_retail  desc)  num,
 c.license_code,c.cust_id,c.cust_name,cr.rim_kind,c.order_tel,c.cust_type3,pm.item_id,pi.item_name,pc.price_retail
   from pi_cust_item_month pm,plm_item pi,plm_item_com pc,co_cust c,crm_cust cr
  where pm.item_id=pi.item_id
  and pm.item_id=pc.item_id
  and c.cust_id=pm.cust_id
  and c.cust_id=cr.cust_id
  and c.status='02'
   and pm.qty_sold>0
   and pc.com_id='10371701'  
   and pm.date1>='${date1}'
   and pm.date1<='${date2}'
   and pm.sale_dept_id='${dept}'
   group by   c.license_code,c.cust_id,c.cust_name,cr.rim_kind,c.order_tel,c.cust_type3,pm.item_id,pi.item_name,pc.price_retail
   order by cust_id)
   where num=1

