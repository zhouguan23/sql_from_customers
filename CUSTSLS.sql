select license_code,cust_name,busi_addr,order_tel,substr(periods_id,6,1) periods_id,domain_name from 
co_cust c,csc_cust cc,csc_orderdomain a where c.cust_id=cc.cust_id and 
c.sale_dept_id='${dptno}' and c.slsman_id='${slsman}'
and c.status='02' 
and a.domain_id=cc.domain_id
${if(len(ppd)==0,"", " and cc.periods_id='"+ppd+"'")}
order by periods_id,license_code

select slsman_id,note from slsman where dpt_sale_id='${dptno}'
and is_mrb=1 order by slsman_id

