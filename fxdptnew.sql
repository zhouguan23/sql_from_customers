select dpt_sale_id, i.kind,brand_id itemgr_id,IC.PRI_RTL,yieldly_type is_imported,ic.item_type1, 
 sum(qty_sold*i.t_size)/50000  qty,sum(amt_sold_with_tax) amt

from dpt_Sale_day2020 a,plm_item i ,item_com ic 
where a.item_id=i.item_id and i.item_id=ic.item_id 
and iss_date=(select to_char(sysdate,'yyyymmdd') from dual)
group by 
 dpt_sale_id, i.kind,brand_id,IC.PRI_RTL,yieldly_type,ic.item_type1  having sum(qty_sold)<>0



select  a.dpt_sale_id, pop,c.qtyplan,c.dxamt_plan,d.days,round(qtyplan/days,2) dayplan
  from  
(select dpt_sale_id,pop from pop_xian) a,

(select dpt_sale_id,qty_plan/250 qtyplan,DXAMT_PLAN
from plan
where type='01' and date1=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,6) FROM DUAL)) c,

(select days
from sale_days
where date1=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,6) FROM DUAL)) d
where  
      c.dpt_sale_id=a.dpt_sale_id
    
 and a.dpt_sale_id<>'17010100'

select DXAMT_PLAN,yearplan , yeardxamt from 
(
SELECT DXAMT_PLAN FROM PLAN WHERE DATE1=(SELECT TO_CHAR(SYSDATE,'YYYYMM') FROM DUAL)
AND TYPE='02'
),
(
SELECT qty_plan/250 yearplan ,DXAMT_PLAN yeardxamt FROM PLAN WHERE DATE1=(SELECT TO_CHAR(SYSDATE,'YYYY') FROM DUAL)||'  ' AND TYPE='04'
)

select dpt_sale_id,sum(qty_plan)/250 yearplan from plan
where dpt_sale_id<>'17010100' and date1 like '2020%'
and type='01' and quarter=(select to_char(sysdate,'Q') from dual) group by dpt_sale_id  

select a.soldday,b.totalday, daypastyue from
  (select count(1) soldday
  from
  (select iss_date,sum(qty_sold*i.t_size/200) qtysold
  from dpt_sale_day2019 a,plm_item i
  where a.item_id=i.item_id and  iss_date>=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,6)||'01' FROM DUAL)
  and iss_date<=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,8) FROM DUAL)
  group by iss_date)
  where qtysold>200) a,
  
  (select days totalday from sale_days
  where  date1=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,6) FROM DUAL)) b,
(select to_date(to_char(sysdate-1,'yyyymmdd'),'yyyymmdd')
- to_date(to_char(to_date(to_char(sysdate-1,'yyyymmdd'),'yyyymmdd'),'yyyymm')||'01','yyyymmdd')+1 daypastyue
 from dual )

select distinct item_type1 ,substr(item_type1,2,10) item_type2 from item_com order by item_type1

select dpt_sale_id, i.kind,brand_id itemgr_id,IC.PRI_RTL,yieldly_type is_imported,ic.item_type1, 
 sum(qty_sold*i.t_size)/50000  qty,sum(amt_sold_with_tax) amt

from dpt_Sale_day2020 a,plm_item i ,item_com ic 
where a.item_id=i.item_id and i.item_id=ic.item_id 
and iss_date>=(select substr(to_char(sysdate,'yyyymmdd'),1,6)||'01' from dual)
and iss_date<=(select  to_char(sysdate,'yyyymmdd')  from dual)
group by 
 dpt_sale_id, i.kind,brand_id,IC.PRI_RTL,yieldly_type,ic.item_type1  having sum(qty_sold)<>0



select dpt_sale_id, ic.prm_note, 
 sum(qty_sold*i.t_size)/50000  qtyy,sum(amt_sold_with_tax)/10000 amt 
from dpt_Sale_day2020 a,plm_item i ,item_com ic 
where a.item_id=i.item_id and i.item_id=ic.item_id 
and substr(iss_date,1,6) in 
(select distinct date1 from kh2016 where quarter=(select to_char(sysdate,'Q') from dual))
group by 
 dpt_sale_id,  ic.prm_note having sum(qty_sold)<>0



select itemtype,sale_dept_id,sum(qtyjh) qtyjh from kh2016 where date1=(select to_char(sysdate,'yyyymm') from dual) and qtysold='1' 
and itemtype<>'1'  group by itemtype,sale_dept_id

select distinct prm_note,substr(prm_note,2,15) fl from item_com where length(prm_note)>5


select dpt_sale_id, ic.prm_note, 
 sum(qty_sold*i.t_size)/50000  qty,sum(amt_sold_with_tax)/10000 amt

from dpt_Sale_day2020 a,plm_item i ,item_com ic 
where a.item_id=i.item_id and i.item_id=ic.item_id 
and iss_date=(select to_char(sysdate,'yyyymmdd') from dual)
group by 
 dpt_sale_id, ic.prm_note  having sum(qty_sold)<>0



select dpt_sale_id, ic.prm_note, 
 sum(qty_sold*i.t_size)/50000  qty, sum(amt_sold_with_tax)/10000  amt

from dpt_Sale_day2020 a,plm_item i ,item_com ic 
where a.item_id=i.item_id and i.item_id=ic.item_id 
and iss_date>=(select substr(to_char(sysdate,'yyyymmdd'),1,6)||'01' from dual)
and iss_date<=(select  to_char(sysdate,'yyyymmdd')  from dual)
group by 
 dpt_sale_id, ic.prm_note  having sum(qty_sold)<>0



select itemtype,sale_dept_id,sum(qtyjh) qtyjh from kh2016  ,
(select to_char(sysdate,'Q') qq from dual) 
where  qtysold='1' and quarter=qq  group by itemtype,sale_dept_id
 

select dpt_sale_id, ic.prm_note, 
 sum(qty_sold*i.t_size)/50000  qtyt, sum(amt_sold_with_tax)/10000  amtt

from dpt_Sale_day2019 a,plm_item i ,item_com ic 
where a.item_id=i.item_id and i.item_id=ic.item_id 
and iss_date>=(select  to_char(add_months(sysdate,-12) ,'yyyymm')||'01' from dual)
and iss_date<=(select  to_char(add_months(sysdate,-12) ,'yyyymmdd') from dual) 
group by 
 dpt_sale_id, ic.prm_note  having sum(qty_sold)<>0

select sale_dept_id, sum(qtyjh)/10000 qtyt 
from kh2019 
where qtysold='2' and date1=(select to_char(sysdate,'yyyyMM') from dual)
group by 
sale_dept_id 

select itemtype,sale_dept_id,sum(qtyjh) qtyjh from kh2016 group by itemtype,sale_dept_id

select to_char(sysdate,'Q')||'季度' jd from dual

select * from pop_xian

