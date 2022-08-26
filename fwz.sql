select distinct dpt_sale_id,fwzid,fwzname from strutofwz order by dpt_sale_id,fwzid

select struid,slsman_id,slsman_name from strutofwz

select  distinct fwzid,struid,struname from strutofwz

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty ,sum(a.amt_sold) amt from pi_cust_item_day a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id

and  date1>='${date1}' and date1<='${date2}'  group  by c.slsman_id

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qtyT ,sum(a.amt_sold) amtT from pi_cust_item_day a,co_cust c ,plm_item i where a.cust_id=c.cust_id  and a.item_id=i.item_id
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd') from dual)  
 group  by c.slsman_id

 
select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty290 ,sum(a.amt_sold) amt290 from pi_cust_item_day a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id
and  date1>='${date1}' and date1<='${date2}'   
 AND  a.price_trade>=290 group  by c.slsman_id

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty170 ,sum(a.amt_sold) amt170 from pi_cust_item_day a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id
and  date1>='${date1}' and date1<='${date2}'  
and a.price_trade>=170  and price_trade<290 group  by c.slsman_id

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty95,sum(a.amt_sold) amt95 from pi_cust_item_day a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id
and  date1>='${date1}' and date1<='${date2}'  
and a.price_trade>=95  and price_trade<170 group  by c.slsman_id

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty78 ,sum(a.amt_sold) amt78 from pi_cust_item_day a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id
and  date1>='${date1}' and date1<='${date2}'  
and a.price_trade>=78  and price_trade<95 group  by c.slsman_id


select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty290t from pi_cust_item_day a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id 
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd') from dual) and
a.price_trade>=290   group  by c.slsman_id

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty170t from pi_cust_item_day a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd') from dual) and
a.price_trade>=170 and a.price_trade<290  group  by c.slsman_id

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty95t from pi_cust_item_day a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id
 
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd') from dual) and
a.price_trade>=95 and a.price_trade<170   group  by c.slsman_id

select c.slsman_id,sum(a.qty_sold*t_size)/50000 qty78t from pi_cust_item_day a,co_cust c,plm_item i  where a.cust_id=c.cust_id  and a.item_id=i.item_id
 
and  date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual) and
date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd') from dual) and
a.price_trade>=78 and a.price_trade<95   group  by c.slsman_id

