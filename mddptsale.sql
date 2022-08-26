 select D.dpt_sale_id,short_name,QTYB,QTYS,QTYT,amtb,amts,amtt,dpt_sale_id_new FROM 

(select a.dpt_sale_id sale_dept_id, sum(a.qty_sold)/250 qtyb, sum(a.amt)*250/sum(a.qty_sold)  amtb 
from cust_sold a , cust  cc
 where   date1>='${date1}' and date1<='${date2}' 
and a.cust_id=cc.cust_id   and cc.cust_type3 in ('${ccqh}')
group by a.dpt_sale_id  ) a,
(

select a.dpt_sale_id sale_dept_id, sum(a.qty_sold)/250 qtys , sum(a.amt)*250/sum(a.qty_sold) 
amts from cust_sold a , cust  cc
 where   a.cust_id=cc.cust_id and 
date1>=(select to_char(to_date('${date1}','yyyymm')-(to_date('${date2}','yyyymm')-to_date('${date1}','yyyymm')+1),'yyyymm') from dual)
and date1<=(select to_char(to_date('${date2}','yyyymm')-(to_date('${date2}','yyyymm')-to_date('${date1}','yyyymm')+1),'yyyymm') from dual)    and cc.cust_type3 in  ('${ccqh}')
group by a.dpt_sale_id  ) b,
(
select a.dpt_sale_id sale_dept_id ,sum(a.qty_sold)/250 qtyt ,

sum(a.amt)*250/sum(a.qty_sold)   amtt from cust_sold a, cust cc 
 where    a.cust_id=cc.cust_id and 
date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm' ) from dual)
 and date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm' ) from dual)
  and cc.cust_type3 in  ('${ccqh}')
group by a.dpt_sale_id
) c,dpt_sale D
WHERE A.SALE_DEPT_ID(+)=D.sale_dept_id
AND B.SALE_DEPT_ID(+)=D.sale_dept_id
AND C.SALE_DEPT_ID(+)=D.sale_dept_id
and d.sale_dept_id<>'11370101'
order by dpt_sale_id_new

select * from di_where where isstatefl=1

