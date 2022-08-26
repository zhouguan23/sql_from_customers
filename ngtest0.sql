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

