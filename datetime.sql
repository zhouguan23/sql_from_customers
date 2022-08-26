SELECT   dpt_sale_id,item_id,iss_date,sum(qty_sold) as qty
 from dpt_sale_day2013 
where  qty_sold<>0 group by dpt_sale_id,item_id,iss_date

SELECT  dpt_sale_id, item_id,iss_date,sum(qty_sold) as qty
 from dpt_sale_day2012 
where  qty_sold<>0
and iss_date<=(
SELECT to_char(add_months(to_date(to_char(sysdate+1,'yyyymmdd'),'yyyymmdd'),-12),'yyyymmdd')   FROM DUAL
)
 group by dpt_sale_id,item_id,iss_date

select distinct i.item_id,item_name,kind,ic.item_type3,substr(ic.item_type3,2,20) itemtype from 
(
select distinct  item_id  from dpt_Sale_day2013  
where   qty_sold<>0
union 
select distinct  item_id  from dpt_Sale_day2012  
where   qty_sold<>0
and iss_date<=(
SELECT to_char(add_months(to_date(to_char(sysdate+1,'yyyymmdd'),'yyyymmdd'),-12),'yyyymmdd')  FROM DUAL
)
)  a,item_com ic,item i where i.item_id=ic.item_id and a.item_id=i.item_id  order by ic.item_type3,item_name



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

