select i.item_id,iss_date,pri_rtl,sum(qty_sold)/250 qty from  
dpt_sale_day${years} a, item i,item_com ic
where a.item_id=i.item_id  and i.itemgr_id=${itemgr}
and a.item_id=ic.item_id 
and iss_date<='${time1}'
group by i.item_id ,iss_date,pri_rtl having sum(qty_sold)<>0

select i.item_id,iss_date,pri_rtl,sum(qty_sold)/250 qty from  
dpt_sale_day${years2} a,item i,item_com ic
where a.item_id=i.item_id and i.itemgr_id=${itemgr} 
and a.item_id=ic.item_id 
and iss_date<=(SELECT TO_CHAR(add_months(to_date(${time1},'yyyymmdd'),-12),'YYYYMMdd') from dual) 
group by i.item_id,iss_date,pri_rtl  having sum(qty_sold)<>0

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

select distinct i.item_id,ic.short_id,item_name,kind,pri_wsale,pri_rtl from item i,item_com ic,
(
select distinct i.item_id,sum(qty_sold) qty from 
dpt_sale_day${years} a,item i
where a.item_id=i.item_id  and i.itemgr_id=${itemgr}
and iss_date<=${time1}  group by i.item_id having sum(qty_sold)<>0
union 
select distinct i.item_id,sum(qty_sold) qty from 
dpt_sale_day${years2} a,item i
where a.item_id=i.item_id  and i.itemgr_id=${itemgr}
and iss_date<=(SELECT TO_CHAR(add_months(to_date(${time1},'yyyymmdd'),-12),'YYYYMMdd') from dual) group by i.item_id having sum(qty_sold)<>0
) cc 
where i.item_id=ic.item_id and i.item_id=cc.item_id
 
order by ic.pri_wsale desc

select itemgr_name from itemgr where itemgr_id='${itemgr}'

