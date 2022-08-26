  select cust_id,cust_short_name,order_tel,cust_seg,sls.note,
  case c.status  when '02' then '有效' when '03' then '暂停' else '注销' end as status 
  from co_cust c,slsman sls 
  where c.slsman_id=sls.slsman_id  and  
 c.sale_dept_id='${dptid}' and cust_id in 
  (
    select  cust_id from 
      (
      select distinct date1,cust_id from pi_cust_item_bnd_day a 
      where  date1>='${date1}' and date1<='${date2}' and sale_dept_id='${dptid}' 
       ) group by  cust_id  having count(1)='${qty}'
      )

