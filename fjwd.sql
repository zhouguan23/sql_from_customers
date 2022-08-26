select  i.item_id,iss_date,sum(qty_sold*i.rods)/50000 qty2 from dpt_sale_day${years} a  ,item i
where  a.item_id=i.item_id 

and iss_date<=${time1} group by   i.item_id,iss_date
having sum(qty_sold)<>0

select benbegin, benend,tongbegin,tongend from 
(
select substr('${time1}',1,6)||'01'  benbegin from dual
) ,
(
select ${time1}  benend  from dual
) ,
(
SELECT SUBSTR(TO_CHAR(add_months(to_date(${time1},'yyyymmdd'),-12),'YYYYMMdd'),1,6)||'01' tongbegin FROM DUAL
),
(
SELECT SUBSTR(TO_CHAR(add_months(to_date(${time1},'yyyymmdd'),-12),'YYYYMMdd'),1,8) tongend FROM DUAL
)

select i.item_id,ic.short_id,ic.item_type3,itemgr_id,substr(ic.item_type3,2,20) itemtype,item_name,kind,pri_wsale,pri_rtl 
from item i,item_com ic,
(
select distinct i.item_id,sum(qty_sold) qty from 
dpt_sale_day${years} a,item i
where a.item_id=i.item_id   
and iss_date<=${time1}  group by i.item_id having sum(qty_sold)<>0
union 
select distinct i.item_id ,sum(qty_sold) qty from 
dpt_sale_day${years2} a,item i
where a.item_id=i.item_id   and
 iss_date<=(select TO_CHAR(add_months(to_date(${time1},'yyyymmdd'),-12),'YYYYMMdd') from dual) group by i.item_id having sum(qty_sold)<>0
) cc 
where i.item_id=ic.item_id and i.item_id=cc.item_id

order by item_type3,ic.pri_wsale desc,itemgr_id

select i.item_id,iss_date,sum(qty_sold*i.rods)/50000 qty2 from dpt_sale_day${years2} a,item i
where a.item_id=i.item_id 

and iss_date<=(SELECT TO_CHAR(add_months(to_date(${time1},'yyyymmdd'),-12),'YYYYMMdd') from dual)  group by i.item_id,iss_date having sum(qty_sold)<>0  

