select a.soldday,b.totalday,a.soldday||'/'||totalday||'   进度:'||round(a.soldday/totalday*100,2)||'%' jd from
  (select count(1) soldday
  from
  (select date1,sum(qty_sold*i.rods/200) qtysold
  from item_dpt_sale_day a,item i
  where a.item_id=i.item_id and  date1>=(SELECT SUBSTR(TO_CHAR(to_date('${date1}','YYYYMMDD'),'yyyymmdd'),1,6)||'01' FROM DUAL)
  and date1<=(SELECT SUBSTR(TO_CHAR(to_date('${date1}','YYYYMMDD'),'yyyymmdd'),1,8) FROM DUAL)
  group by date1)
  where qtysold>200) a,
  
  (select days totalday from sale_days
  where  date1=(SELECT SUBSTR(TO_CHAR(to_date(${date1},'yyyyMMdd'),'yyyymmdd'),1,6) FROM DUAL)) b

select dpt_sale_id,qty_plan/250 qtyplan,dxamt_plan,dxamt_plan*qty_plan/250 amount from plan where date1=(select to_char(to_date('${date1}','yyyymmdd'),'yyyymm') from dual) and dpt_sale_id<>'17010100'

select dpt_Sale_id,iss_date,i.item_id,item_name,sum(qty_sold*i.rods)/50000 qty,sum(amt_sold_with_tax) amt from 
dpt_Sale_day${years} a,item i  where  a.item_id=i.item_id  and iss_date>=(select to_char(to_date(${date1},'yyyymmdd'),'yyyymm')||'01' from dual)
and iss_date<=${date1}
group by dpt_Sale_id,iss_date,i.item_id ,item_name having sum(qty_sold)<>0



select dpt_Sale_id,iss_date, i.item_id,item_name,sum(qty_sold*i.rods)/50000 qty,sum(amt_sold_with_tax) amt from 
dpt_sale_day${years2} a,item i  where a.item_id=i.item_id   and iss_date>=(SELECT substr(TO_CHAR(add_months(to_date(${date1},'yyyymmdd'),-12),'YYYYMMdd'),1,6)||'01' FROM DUAL)
and iss_date<= (SELECT TO_CHAR(add_months(to_date(${date1},'yyyymmdd'),-12),'YYYYMM')||'31' FROM DUAL)
group by dpt_Sale_id ,iss_date,i.item_id,item_name having sum(qty_sold)<>0

select  dxamt_plan from plan where date1=(select to_char(to_date('${date1}','yyyymmdd'),'yyyymm') from dual) and dpt_sale_id='17010100'

select i.item_id,iss_date,sum(qty_sold*i.rods)/50000 qty,sum(amt_sold_with_tax) amt from 
dpt_sale_day${year} a,item i  where
a.item_id=i.item_id 
  and iss_date>=(select to_char(to_date('${date1}','yyyymmdd'),'yyyymm')||'01' from dual) and iss_date<='${date1}'
group by  i.item_id,iss_date  having sum(qty_sold)<>0


select i.item_id, pri_rtl,kind,im.itemgr_id,itemgr_NAME,iss_date,im.note,sum(qty_sold*i.rods)/50000 qty,sum(amt_sold_with_tax) amt from 
dpt_sale_day${years2} a,item i ,item_com ic,itemgr  im where
a.item_id=ic.item_id and ic.item_id=i.item_id and i.itemgr_id=im.itemgr_id 
 and iss_date>=(SELECT substr(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,6)||'01' FROM DUAL) 
and iss_date<=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMM')||'31' FROM DUAL) 
group by i.item_id ,pri_rtl,kind,im.itemgr_id,itemgr_NAME,iss_date,im.note  having sum(qty_sold)<>0



select fact_id,  i.item_id,item_name,kind , pri_wsale,  im.note, ic.pri_rtl,i.itemgr_id 
from factory f,item i, item_com ic ,itemgr im
where f.fact_id=i.factory  
and i.item_id=ic.item_id   and i.itemgr_id=im.itemgr_id 
and i.item_id in 
(select distinct item_id from 
( select distinct item_id from ocom_month where date1=(SELECT substr(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,6) FROM DUAL) 
 group by item_id having sum(qty_sold)<>0
union all
select  distinct item_id from dpt_sale_day${years} where iss_date>=(select substr(to_char(to_date('${date1}','yyyymmdd'),'yyyymmdd'),1,6)||'01' from dual)
and iss_date<=${date1}
group by item_id having sum(qty_sold)<>0
)
)
 
order by fact_id ,itemgr_id,kind asc,ic.pri_wsale  desc


select to_char(add_months(to_date(${date1},'yyyymmdd'),-12),'yyyymmdd') rqt from dual

select rq1,rq2 from 
(
SELECT TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMM')||'01' rq1 FROM DUAL
),
(
SELECT TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd') rq2 FROM DUAL
)

select dpt_Sale_id,iss_date,itemgr_id,pri_rtl,kind,sum(qty_sold*i.rods)/50000 qty,sum(amt_sold_with_tax) amt from 
dpt_Sale_day${years} a,item i ,item_com ic  where  a.item_id=i.item_id  and
a.item_id=ic.item_id  and ic.com_id='10371701' and  iss_date>=(select to_char(to_date('${date1}','yyyymmdd'),'yyyymm')||'01' from dual)
and iss_date<='${date1}' and itemgr_id in ('0046','0108','0144','0170')

group by dpt_Sale_id,iss_date,itemgr_id,pri_rtl,kind having sum(qty_sold)<>0

select dpt_Sale_id,iss_date,itemgr_id,pri_rtl,kind,sum(qty_sold*i.rods)/50000 qty,sum(amt_sold_with_tax) amt from 
dpt_Sale_day${years2} a,item i ,item_com ic  where  a.item_id=i.item_id  and
a.item_id=ic.item_id  and ic.com_id='10371701' and  iss_date>=(SELECT substr(TO_CHAR(add_months(to_date(${date1},'yyyymmdd'),-12),'YYYYMMdd'),1,6)||'01' FROM DUAL)
and iss_date<= (SELECT TO_CHAR(add_months(to_date(${date1},'yyyymmdd'),-12),'YYYYMM')||'31' FROM DUAL)
and  itemgr_id in ('0046','0108','0144','0170')

group by dpt_Sale_id,iss_date,itemgr_id,pri_rtl,kind having sum(qty_sold)<>0

