select cust_short_name,order_tel,case cust_type3 when '011' then '城区' when '012' then '镇区' when '013' then '特殊镇区' when '023' then '农好' when '024' then '农差' else '其他' end custtype3 ,cust_seg,sls.note from co_cust c,slsman sls 
   
where   c.slsman_id=sls.slsman_id  
and c.cust_id in   (
select  cust_id from co_cust where status='02' minus
select distinct cust_id from cust_sold where date1>='${date1}' and date1<='${date2}')
 
and c.status='02'   and c.sale_dept_id='${dptid}' order by sls.note

