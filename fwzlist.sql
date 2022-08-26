
select  distinct  short_name||fwzname fwzname,fwzid ,dpt_sale_id_new from strutofwz  a,dpt_sale b
where a.dpt_sale_id=b.sale_dept_id order by dpt_sale_id_new,fwzid

select struid,slsman_id,slsman_name from strutofwz

select  distinct fwzid,struid,struname from strutofwz

select fwzid,sum(a.qty_sold*t_size)/50000 qty ,sum(a.amt_sold) amt from pi_cust_item_day a,co_cust c ,strutofwz@orahzbo b ,plm_item i 
where a.cust_id=c.cust_id and b.slsman_id=c.slsman_id and a.item_id=i.item_id
and  date1>='${date1}' and date1<='${date2}'  group  by fwzid

select fwzid,sum(a.qty_sold*t_size)/50000 qty,sum(a.amt_sold) amt from pi_cust_item_day a,co_cust c ,strutofwz@orahzbo b,plm_item i 
where a.cust_id=c.cust_id and b.slsman_id=c.slsman_id  and a.item_id=i.item_id
 
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd') from dual)  
 group  by fwzid

 

 
 select fwzid,sum(a.qty_sold*t_size)/50000 qty ,sum(a.amt_sold) amt from pi_cust_item_day a,co_cust c ,strutofwz@orahzbo b ,plm_item i 
where a.cust_id=c.cust_id and b.slsman_id=c.slsman_id 
and a.item_id=i.item_id AND  a.price_trade>=290
and  date1>='${date1}' and date1<='${date2}'  group  by fwzid
 


select fwzid,sum(a.qty_sold*t_size)/50000 qty ,sum(a.amt_sold) amt from pi_cust_item_day a,co_cust c ,strutofwz@orahzbo b ,plm_item i 
where a.cust_id=c.cust_id and b.slsman_id=c.slsman_id  and a.item_id=i.item_id
and a.price_trade>=170  and price_trade<290 
and  date1>='${date1}' and date1<='${date2}'  group  by fwzid


select fwzid,sum(a.qty_sold*t_size)/50000 qty95 ,sum(a.amt_sold) amt from pi_cust_item_day a,co_cust c ,strutofwz@orahzbo b ,plm_item i
where a.cust_id=c.cust_id and b.slsman_id=c.slsman_id  and a.item_id=i.item_id
and a.price_trade>=95  and price_trade<170 
and  date1>='${date1}' and date1<='${date2}'  group  by fwzid

select fwzid,sum(a.qty_sold*t_size)/50000 qty78 ,sum(a.amt_sold) amt from pi_cust_item_day a,co_cust c ,strutofwz@orahzbo b ,plm_item i
where a.cust_id=c.cust_id and b.slsman_id=c.slsman_id  and a.item_id=i.item_id
and a.price_trade>=78  and price_trade<95 
and  date1>='${date1}' and date1<='${date2}'  group  by fwzid

select fwzid,sum(a.qty_sold*t_size)/50000 qty290t from pi_cust_item_day a,co_cust c ,strutofwz@orahzbo b,plm_item i 
where a.cust_id=c.cust_id and b.slsman_id=c.slsman_id  and a.item_id=i.item_id 

and  date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd') from dual) and
a.price_trade>=290   group  by fwzid

select fwzid,sum(a.qty_sold*t_size)/50000 qty170t from pi_cust_item_day a,co_cust c ,strutofwz@orahzbo b,plm_item i 
where a.cust_id=c.cust_id and b.slsman_id=c.slsman_id  and a.item_id=i.item_id

and  date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd') from dual) and
a.price_trade>=170  and a.price_trade<290  group  by fwzid

select fwzid,sum(a.qty_sold*t_size)/50000 qty95t from pi_cust_item_day a,co_cust c ,strutofwz@orahzbo b,plm_item i 
where a.cust_id=c.cust_id and b.slsman_id=c.slsman_id  and a.item_id=i.item_id

and  date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd') from dual) and
a.price_trade>=95 and price_trade<170   group  by fwzid

select fwzid,sum(a.qty_sold*t_size)/50000 qty78t from pi_cust_item_day a,co_cust c ,strutofwz@orahzbo b,plm_item i 
where a.cust_id=c.cust_id and b.slsman_id=c.slsman_id  and a.item_id=i.item_id

and  date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd') from dual) and
a.price_trade>=78 and price_trade<95   group  by fwzid

