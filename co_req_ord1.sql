select cm.dpt_sale_id,ct.slsman_id,sum(cm.qty_req)  req,sum(cm.qty_sold)  sold
from cust_month${years} cm, cust ct
 where cm.cust_id=ct.cust_id
and ct.status='02'
and  cm.date1>='${years}${start}'
and cm.date1<='${years}${end}'
group by cm.dpt_sale_id,ct.slsman_id

select slsman_id,dpt_sale_id,note from slsman where com_id='10371701' and is_mrb=1
and dpt_sale_id<>'17010100'

