
select slsman_id,count(distinct cc.cust_id) dghsb,sum(a.qty_sold) qtyb,sum(amt)  amtb from  cust_sold  a,co_cust cc
where a.cust_id=cc.cust_id and date1>='${date1}'  and date1<='${date2}' 
${if(len(sls)==0,""," and cc.slsman_id in ('"+sls+"')")}
and cc.sale_dept_id in ('${dptid}' ) group by slsman_id


select slsman_id,count(1) dghss,sum(a.qty_sold) qtys,sum(amt)  amts from  cust_sold  a,co_cust cc
where a.cust_id=cc.cust_id and date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM')  from dual)
${if(len(sls)==0,""," and cc.slsman_id in ('"+sls+"')")}
and cc.sale_dept_id in ('${dptid}' )  group by slsman_id

select sls.slsman_id,sls.note,count(cust_id) newhs 
from co_cust  cc,slsman sls where cc.slsman_id=sls.slsman_id and cc.status='02'
and cc.sale_dept_id in ('${dptid}')
${if(len(sls)==0,""," and sls.slsman_id in ('"+sls+"')")}
 group by sls.slsman_id,sls.note

select slsman_id,sls.note ,dpt_sale_id_new from   slsman sls,dpt_sale dp
where sls.dpt_sale_id=dp.dpt_sale_id  and dp.sale_dept_id in ('${dptid}') order by dp.dpt_sale_id_new,slsman_id

