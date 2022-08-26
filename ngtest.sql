select  c.born_date,co_num,c.status,c.cust_id,cc.busi_addr,c.qty_sum,c.amt_sum
from co_co c,co_cust cc
where c.cust_id=cc.cust_id
and  born_date>='${time1}'
and born_date<='${time2}'

${if(len(cust_id)>0,"and c.cust_id='"+cust_id+"'","and license_code='"+licence+"'")}


select  co_num,cl.item_id,p.item_name,cl.qty_need,cl.qty_ord
from co_co_line  cl,plm_item p
where   p.item_id=cl.item_id
and qty_ord>0
and co_num in (select  co_num from co_co c,co_cust cc
where c.cust_id=cc.cust_id
and  born_date>='${time1}'
and born_date<='${time2}'

${if(len(cust_id)>0,"and c.cust_id='"+cust_id+"'","and license_code='"+licence+"'")}
)
order by qty_ord desc


select  cc.cust_id,license_code,cust_name,busi_addr,manager_tel,
case cc.status when '01'  then '新增'  when '02' then '有效'  when '03'  then '暂停'  when '04' then '注销' end status,cust_seg,
case order_way  when '31'  then '网上'  when  '35'  then '微信' end  dhfs,
  slsman_name sls,
  case pay_type when '20' then '电子结算' when '24' then '支票' end jsfs, case base_type
 when  'B'   then '便利店'
 when 'Z'   then '食杂店'
 when 'S'   then '超市'
 when 'Y'   then '烟酒店'
 when 'N'   then '商场'
 when 'F'   then '娱乐类'
 when 'Q'   then '其他'
end  jjyt,case periods_id 
when 'HZ0701' then '周一'
when 'HZ0702' then '周二'
when 'HZ0703' then '周三'
when 'HZ0704' then '周四'
when 'HZ0705' then '周五' end fxzq
from co_cust cc,slsman sl,csc_cust c
where sl.slsman_id=cc.slsman_id
and c.cust_id=cc.cust_id
--and cc.status='02'
${if(len(cust_id)>0,"and c.cust_id='"+cust_id+"'","and license_code='"+licence+"'")}

