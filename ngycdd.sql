select  c.born_date,co_num,c.status,c.cust_id,cc.busi_addr,c.qty_sum,c.amt_sum
from co_co c,co_cust cc
where c.cust_id=cc.cust_id
and  born_date>='${time1}'
and born_date<='${time2}'

${if(len(cust_id)>0,"and c.cust_id='"+cust_id+"'","and license_code='"+licence+"'")}



