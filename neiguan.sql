select item_id,item_name  from plm_item where item_id in 
(
'6901028075022','6901028075015','6901028062015', '6901028118187','6901028317177','6901028180580','6901028180580','6901028179867'
,'6901028114455'
)

select c.cust_id,c.cust_short_name,
case when c.cust_type3='011' then '城区'
when  c.cust_type3='012' then '镇区'
when  c.cust_type3='013' then '特殊镇区'
when  c.cust_type3='023' then '较好农村' 
when  c.cust_type3='024' then '较差农村' 
else '未维护' end  as dili,
c.cust_seg,
case when domain_id='HZ001' then '电话订货' else '网上订货'  end dhfs, a.qty_sold qty,i.item_name
 from pi_cust_item_bnd_day a,co_cust c,csc_cust cc,plm_item i
where  a.cust_id=c.cust_id and cc.cust_id=c.cust_id
  and a.com_id='10371701' and a.item_id=i.item_id
and c.sale_dept_id='${dpt}' and a.qty_sold<>0
and a.date1='${date1}' and i.item_id in 
('6901028075022','6901028075015','6901028062015' ,'6901028118187','6901028317177','6901028180580','6901028180580','6901028000063','6901028179867','6901028114455')


