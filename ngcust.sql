select c.cust_id,cig_lice_id,cust_short_name,busi_addr,tel,
case when cust_type2_root='01' then '食杂店'
when cust_type2_root='02' then '便利店'
when cust_type2_root='03' then '超市'
when cust_type2_root='04' then '商场'
when cust_type2_root='05' then '烟酒店'
when cust_type2_root='06' then '娱乐服务'
when cust_type2_root='07' then '其他'
else '未定义' end as custtype,
case when  status='02' then '有效' when status='03' then '暂停'
 when status='04' then '吊销' when status='05' then '注销' end  as status ,
case when pay_type='03' then '电子结算户' else '非结算户' end as pay_type,
cust_type4, case visit_order when 'HZ001' then  '电话订货' else '网订' end  as domain_name ,sls.note,call_period
 from cust   c,slsman sls where c.slsman_id=sls.slsman_id and  (cig_lice_id in 
(${cust_id}) or cust_id in (${cust_id}))

