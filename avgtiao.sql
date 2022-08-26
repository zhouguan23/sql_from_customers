
select slsman_id,count(1) dghsb,sum(a.qty_sold) qtyb,sum(amt)  amtb from  cust_sold  a,co_cust cc
where a.cust_id=cc.cust_id and date1='${date1}' group by slsman_id


select slsman_id,count(1) dghss,sum(a.qty_sold) qtys,sum(amt)  amts from  cust_sold  a,co_cust cc
where a.cust_id=cc.cust_id and date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM')  from dual)  group by slsman_id

select sls.slsman_id,sls.note,count(cust_id) newhs 
from co_cust  cc,slsman sls where cc.slsman_id=sls.slsman_id and cc.status='02'
and cc.sale_dept_id='${dptid}'
 group by sls.slsman_id,sls.note

