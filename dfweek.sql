SELECT distinct item_name  ,DATE1  ,  price_trade ,SUM(QTY_sold*t_size)/50000 qty ,sum(amt_sold) amt 
 FROM pi_cust_item_bnd_day a,plm_item i  
 WHERE DATE1>='${date1}' AND DATE1<='${date2}' and 
a.item_id=i.item_id AND a.sale_TYPE='10'
and i.item_id in 
(select distinct item_id from pi_cust_item_bnd_day 
 where date1>=(select to_char(to_date('${date1}','yyyyMMdd')-7,'yyyyMMdd') from dual)
and date1<='${date2}') 
 GROUP BY item_name  ,DATE1  ,price_trade 
 
having sum(qty_sold)<>0
order by price_trade desc, date1 asc 


select i.kind,
case when cust_type3='011' then '城区'
when cust_type3='012' then '乡镇'
when cust_type3='013'  then '特殊镇区'
when cust_type3='023'  then '较好农村' 
when cust_type3='024'  then '较差农村' 
else '未维护' end as dili,
sum(a.qty_sold*t_size)/50000 qtys ,sum(a.amt_sold)  dtzs from 
pi_cust_item_bnd_day a,plm_item i ,co_cust c 
where a.item_id=i.item_id and a.cust_id=c.cust_id and a.date1>=(select to_char(to_date('${date1}','yyyyMMdd')-7,'yyyyMMdd') from dual)
and a.date1<=(select to_char(to_date('${date2}','yyyyMMdd')-7,'yyyyMMdd') from dual) and a.sale_type='10' group by i.kind,cust_type3
 


select i.kind,
case when cust_type3='011' then '城区'
when cust_type3='012' then '乡镇'
when cust_type3='013'  then '特殊镇区'
when cust_type3='023'  then '较好农村' 
when cust_type3='024'  then '较差农村' else '未维护' end as dili,
sum(a.qty_sold*t_size)/50000 qtyb ,sum(a.amt_sold)  dtzb from 
pi_cust_item_bnd_day a,plm_item i ,co_cust c 
where a.item_id=i.item_id and a.cust_id=c.cust_id and a.date1>='${date1}'
and a.date1<='${date2}' and a.sale_type='10' group by i.kind,cust_type3
having sum(a.qty_sold)<>0

SELECT distinct item_name  ,SUM(QTY_sold*t_size)/50000 qtys 
 FROM pi_cust_item_bnd_day a,plm_item i  
 WHERE DATE1>=(select to_char(to_date('${date1}','yyyyMMdd')-7,'yyyyMMdd') from dual) AND DATE1<=(select to_char(to_date('${date2}','yyyyMMdd')-7,'yyyyMMdd') from dual) and 
a.item_id=i.item_id AND a.sale_TYPE='10' 
and i.item_id in 
(select distinct item_id from pi_cust_item_bnd_day 
 where date1>=(select to_char(to_date('${date1}','yyyyMMdd')-7,'yyyyMMdd') from dual)
and date1<='${date2}') 
 GROUP BY item_name   having sum(qty_sold)<>0
 

