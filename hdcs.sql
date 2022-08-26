select dp.dpt_sale_id||dp.short_name short_name ,dhcs,count(1) hs from dpt_sale dp,
(
     select sale_dept_id,cust_id,count(1) dhcs from 
      (
      select distinct sale_dept_id,date1,cust_id from pi_cust_item_bnd_day
      where date1>='${date1}' and date1<='${date2}'
       ) group by sale_dept_id,cust_id
) a where a.sale_dept_id=dp.dpt_sale_id  group by dp.dpt_sale_id||dp.short_name, dhcs
order by  dhcs desc

