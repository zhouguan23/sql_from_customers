select cust_short_name,order_tel,case cust_type3 when '011' then '城区' when '012' then '镇区' when '013' then '特殊镇区' when '023' then '农好' when '024' then '农差' else '其他' end custtype3 ,cust_seg,sls.note from co_cust c,slsman sls,
  csc_cust_orderdate a 
where  a.cust_id=c.cust_id and c.slsman_id=sls.slsman_id and a.call_date=(select to_char(sysdate,'yyyyMMdd') from dual)
and c.cust_id in    (Select cust_id from co_cust minus
select cust_id  from co_co where born_date=(select to_char(sysdate,'yyyyMMdd') from dual)  and status<>'90')
 
and c.status='02'   and c.sale_dept_id='${dptid}' order by sls.note

