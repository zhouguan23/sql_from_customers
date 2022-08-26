select distinct  i.item_id, item_name,factory from item i,zdppdd b
where i.item_id=b.item_id order by factory

select distinct  item_id, sale_dept_id,
 qty_ord ,qty_need    from zdppdd
where date1='${date1}' and item_id<>'all'

select distinct  item_id, sale_dept_id,
 sum(qty_ord) qtymonth ,sum(qty_need) needmonth  from zdppdd
where date1>=(select substr('${date1}',1,6)||'01' from dual) and  date1<='${date1}' and item_id<>'all'
group by item_id, sale_dept_id

select distinct  item_id, sale_dept_id,
case when qtyall<=0 then 0
else round(qtydj/qtyall*100,2) end as zyl   from zdppdd
where date1='${date1}' and item_id<>'all'

select distinct  item_id, sale_dept_id,
case when sum(qtyall)<=0 then 0
else round(sum(qtydj)/sum(qtyall)*100,2) end as zylmonth   from zdppdd
where date1>=(select substr('${date1}',1,6)||'01' from dual) 
and  date1<='${date1}' and item_id<>'all'
group by item_id, sale_dept_id

select sale_dept_id,qtyco  from zdppdd where date1='${date1}' and item_id='all'

select sale_dept_id,count(1) custall from co_cust where status='02'
group by sale_dept_id

select item_id,'1137'||substr(dpt_sale_id,1,4) sale_dept_id,count(1) djmonth from 
item_cust_month2015 where iss_date=(select substr('${date1}',1,6) from dual)
and item_id in 
(select distinct item_id from zdppdd where date1='${date1}' and item_id<>'all')
group by item_id,'1137'||substr(dpt_sale_id,1,4)

select item_id,sale_dept_id,
nvl(djhs1,0) djhs1,nvl(djhs2,0) djhs2,nvl(djhs3,0) djhs3,nvl(djhs4,0) djhs4,
nvl(djhs5,0) djhs5 from zdppdd 
where date1='${date1}' and item_id<>'all'

select item_id,sale_dept_id,
nvl(sum(djhs1),0) djhsls1,nvl(sum(djhs2),0) djhsls2,
nvl(sum(djhs3),0) djhsls3,nvl(sum(djhs4),0) djhsls4,
nvl(sum(djhs5),0) djhsls5 from zdppdd 
where  date1>=(select substr('${date1}',1,6)||'01' from dual) 
and  date1<='${date1}' and item_id<>'all'
group by item_id,sale_dept_id

select distinct  item_id,
case when sum(qtyall) <=0 then 0
else round(sum(qtydj)/sum(qtyall)*100,2) end as zylhjday   from zdppdd
where date1='${date1}' and item_id<>'all'
 group by item_id

select distinct  item_id, 
case when sum(qtyall) <=0 then 0
else round(sum(qtydj)/sum(qtyall)*100,2) end as zylhjmonth   from zdppdd
where date1>=(select substr('${date1}',1,6)||'01' from dual) 
and  date1<='${date1}' and item_id<>'all'
group by item_id

select item_id,sale_dept_id,
nvl(sum(djls1),0) djlslj1,nvl(sum(djls2),0) djlslj2,
nvl(sum(djls3),0) djlslj3,nvl(sum(djls4),0) djlslj4,
nvl(sum(djls5),0) djlslj5 from zdppdd 
where  date1>=(select substr('${date1}',1,6)||'01' from dual) 
and  date1<='${date1}' and item_id<>'all'
group by item_id,sale_dept_id

select item_id,sale_dept_id,
nvl(djls1,0) djls1,nvl(djls2,0) djls2,nvl(djls3,0) djls3,nvl(djls4,0) djls4,
nvl(djls5,0) djls5 from zdppdd 
where date1='${date1}' and item_id<>'all'

select   sale_dept_id,
 qty_ord ,qty_need    from zdppdd
where date1='${date1}' and item_id='all'

select sale_dept_id,
 sum(qty_ord) qtymonth ,sum(qty_need) needmonth  from zdppdd
where date1>=(select substr('${date1}',1,6)||'01' from dual) and  date1<='${date1}' and item_id='all'
group by   sale_dept_id

select sale_dept_id,qtynoco  from zdppdd where date1='${date1}' and item_id='all'

select sale_dept_id,sum(qtynoco) nocomonth  from zdppdd 
where date1>=(select substr('${date1}',1,6)||'01' from dual) and  date1<='${date1}'
 and item_id='all'
group by sale_dept_id

select  sale_dept_id,
nvl(djhs1,0) djhs1,nvl(djhs2,0) djhs2,nvl(djhs3,0) djhs3,nvl(djhs4,0) djhs4,
nvl(djhs5,0) djhs5 from zdppdd 
where date1='${date1}' and item_id='all'

select  sale_dept_id,
nvl(sum(djhs1),0) djhsls1,nvl(sum(djhs2),0) djhsls2,
nvl(sum(djhs3),0) djhsls3,nvl(sum(djhs4),0) djhsls4,
nvl(sum(djhs5),0) djhsls5 from zdppdd 
where  date1>=(select substr('${date1}',1,6)||'01' from dual) 
and  date1<='${date1}' and item_id='all'
group by  sale_dept_id

select  sale_dept_id,
nvl(djls1,0) djls1,nvl(djls2,0) djls2,nvl(djls3,0) djls3,nvl(djls4,0) djls4,
nvl(djls5,0) djls5 from zdppdd 
where date1='${date1}' and item_id='all'

select  sale_dept_id,
nvl(sum(djls1),0) djlslj1,nvl(sum(djls2),0) djlslj2,
nvl(sum(djls3),0) djlslj3,nvl(sum(djls4),0) djlslj4,
nvl(sum(djls5),0) djlslj5 from zdppdd 
where  date1>=(select substr('${date1}',1,6)||'01' from dual) 
and  date1<='${date1}' and item_id<>'all'
group by  sale_dept_id

