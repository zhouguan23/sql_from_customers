select distinct dpt_sale_id,fwzid,fwzname from strutofwz where dpt_sale_id in ('${dptid}')

select distinct fwzid,struid,struname from strutofwz where fwzid in ('${fwzid}')

select  fwzname,struname,slsman_id,slsman_name,fwzid, struid from strutofwz where dpt_sale_id='${dptid}' order by fwzid, struid


select  sale_dept_id ,short_name from dpt_sale where sale_dept_id in ('${dptid}')
 


select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty ,sum(a.amt_sold) amt from pi_cust_item_month  a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id
and  date1>='${date1}' and date1<='${date2}' and a.sale_dept_id in ('${dptid}') group  by c.slsman_id

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty ,sum(a.amt_sold) amt from pi_cust_item_month  a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm') from dual) and
a.sale_dept_id in ('${dptid}') group  by c.slsman_id

 
select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty290   from pi_cust_item_month a,co_cust c,plm_item_com ic,plm_item i  where a.cust_id=c.cust_id  and a.item_id=ic.item_id and a.item_id=i.item_id
and  date1>='${date1}' and date1<='${date2}' and a.sale_dept_id in ('${dptid}')
 
and price_trade>=290 group  by c.slsman_id

 
select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty170   from pi_cust_item_month a,co_cust c,plm_item_com ic,plm_item i  where a.cust_id=c.cust_id  and a.item_id=ic.item_id and a.item_id=i.item_id
and  date1>='${date1}' and date1<='${date2}' and a.sale_dept_id in ('${dptid}')
and  price_trade>=170  and price_trade<290 group  by c.slsman_id

 
select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty95  from pi_cust_item_month a,co_cust c,plm_item_com ic,plm_item i  where a.cust_id=c.cust_id  and a.item_id=ic.item_id and a.item_id=i.item_id
and  date1>='${date1}' and date1<='${date2}' and a.sale_dept_id in ('${dptid}')
and  price_trade>=95  and price_trade<170  group  by c.slsman_id

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty78   from pi_cust_item_month a,co_cust c,plm_item_com ic,plm_item i  where a.cust_id=c.cust_id  and a.item_id=ic.item_id and a.item_id=i.item_id
and  date1>='${date1}' and date1<='${date2}' and a.sale_dept_id in ('${dptid}')
and  price_trade>=78  and price_trade<95 group  by c.slsman_id


select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty170t  from pi_cust_item_month a,co_cust c,plm_item_com ic,plm_item i  where a.cust_id=c.cust_id  and a.item_id=ic.item_id and a.item_id=i.item_id
 
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm') from dual) and
price_trade>=170 and price_trade<290 and 
a.sale_dept_id in ('${dptid}') group  by c.slsman_id

 
select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty290t  from pi_cust_item_month a,co_cust c,plm_item_com ic,plm_item i  where a.cust_id=c.cust_id  and a.item_id=ic.item_id and a.item_id=i.item_id
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm') from dual) and
price_trade>=290  and 
a.sale_dept_id in ('${dptid}') group  by c.slsman_id

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty95t  from pi_cust_item_month a,co_cust c,plm_item_com ic,plm_item i  where a.cust_id=c.cust_id  and a.item_id=ic.item_id and a.item_id=i.item_id
 
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm') from dual) and
price_trade>=95 and price_trade<170 and 
a.sale_dept_id in ('${dptid}') group  by c.slsman_id


select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty78t   from pi_cust_item_month a,co_cust c,plm_item_com ic,plm_item i  where a.cust_id=c.cust_id  and a.item_id=ic.item_id and a.item_id=i.item_id
 
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm') from dual) and
price_trade>=78  and price_trade<95 and 
a.sale_dept_id in ('${dptid}') group  by c.slsman_id

