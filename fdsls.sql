select  sls.note,case when cc.cust_type4 is null then '未分档' else cust_type4 end  cust_type4,count(distinct cc.cust_id ) ccust,sum(cs.qty_sold) qty  from  

co_cust  cc,cust_sold cs,slsman sls
where cc.cust_id=cs.cust_id and cc.slsman_id=sls.slsman_id 
and cc.sale_dept_id='${dptid}'
 and cs.date1='${date1}' and cc.status='02'
group by sls.note, cc.cust_type4  order by nvl(cc.cust_type4,'00')

