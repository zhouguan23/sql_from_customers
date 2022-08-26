SELECT   a.dpt_sale_id,kind,i.item_id,item_name,iss_date,sum(qty_sold) as qty  from dpt_sale_day2013 a,item i
where a.item_id=i.item_id and qty_sold<>0
group by a.dpt_sale_id,kind,i.item_id,item_name,iss_date


SELECT   a.dpt_sale_id,kind,i.item_id,item_name,iss_date,sum(qty_sold) as qty
  from dpt_sale_day2012 a,item i
where a.item_id=i.item_id and qty_sold<>0 and
 iss_date<=(
SELECT to_char(add_months(to_date(to_char(sysdate+1,'yyyymmdd'),'yyyymmdd'),-12),'yyyymmdd')  FROM DUAL
)
group by  a.dpt_sale_id,kind,i.item_id,item_name,iss_date



select benbegin, benend,tongbegin,tongend from 
(
select substr(to_char(sysdate+1,'yyyymmdd'),1,6)||'01'  benbegin from dual
) ,
(
select to_char(sysdate+1,'yyyymmdd')  benend  from dual
) ,
(
SELECT  substr(to_char(add_months(to_date(to_char(sysdate+1,'yyyymmdd'),'yyyymmdd'),-12),'yyyymmdd'),1,6)||'01'   tongbegin FROM DUAL
),
(
SELECT to_char(add_months(to_date(to_char(sysdate+1,'yyyymmdd'),'yyyymmdd'),-12),'yyyymmdd') tongend FROM DUAL
)

select distinct item_id,item_name,kind from 
(
select distinct i.item_id,item_name,kind from dpt_Sale_day2013 a,item i 
where a.item_id=i.item_id and qty_sold<>0
union 
select distinct i.item_id,item_name,kind from dpt_Sale_day2012 a,item i 
where a.item_id=i.item_id and qty_sold<>0
and iss_date<=(
SELECT to_char(add_months(to_date(to_char(sysdate+1,'yyyymmdd'),'yyyymmdd'),-12),'yyyymmdd') tongend FROM DUAL
)
) order by kind,item_name

