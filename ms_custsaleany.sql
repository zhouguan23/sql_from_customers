select flname,round(sum(qty_sold),0) qty from 

pub_base  c ,custsolddili b where c.base_type=b.dili and 
   c.custfl='dili'  and date1>='${date1}' and date1<='${date2}'  group by flname

select flname,round(sum(qty_sold),0) qty from 

pub_base  c ,custsoldyetai b where c.base_type=b.cust_type3 and 
   c.custfl='yetai'  and date1>='${date1}' and date1<='${date2}'  group by flname


select cust_seg,round(sum(a.qty_sold)/250,0) qty 
from cust_sold a,co_cust cc where a.cust_id=cc.cust_id and date1>='${date1}' and date1<='${date2}'
group by cust_seg 


select base_type,custnum from pub_base where custfl='custseg' order by base_type desc

