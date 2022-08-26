select dpt_sale_id,iss_date,i.kind,itemgr_id,IC.PRI_RTL,is_imported,ic.item_type2,substr(ic.item_type1,2,10) item_type1,
 sum(qty_sold*i.rods)/50000  qty,sum(amt_sold_with_tax) amt

from dpt_Sale_day${years}  a,item i ,item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id group by 
 dpt_sale_id,iss_date,i.kind,itemgr_id,IC.PRI_RTL,is_imported,ic.item_type2,ic.item_type1 having sum(qty_sold)<>0
order by kind,ic.item_type2


select  a.dpt_sale_id, pop,c.qtyplan,c.dxamt_plan,d.days,round(qtyplan/days,2) dayplan
  from  
(select dpt_sale_id,pop from pop_xian) a,

(select stru_id,qty_plan/250 qtyplan,DXAMT_PLAN
from plan
where type='01' and date1=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,6) FROM DUAL)) c,

(select days
from sale_days
where date1=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,6) FROM DUAL)) d
where  
      c.stru_id(+)=a.dpt_sale_id
    
 and a.dpt_sale_id<>'17010100'

select DXAMT_PLAN,yearplan , yeardxamt from 
(
SELECT DXAMT_PLAN FROM PLAN WHERE DATE1=(SELECT TO_CHAR(SYSDATE,'YYYYMM') FROM DUAL)
AND TYPE='02'
),
(
SELECT qty_plan/250 yearplan ,DXAMT_PLAN yeardxamt FROM PLAN WHERE DATE1=(SELECT TO_CHAR(SYSDATE,'YYYY') FROM DUAL)||'  ' AND TYPE='04'
)

select dpt_sale_id,qty_plan/250 yearplan,dxamt_plan from plan
where dpt_sale_id<>'17010100' and date1=(select to_char(sysdate,'yyyy') from dual)||'  ' 

select a.soldday,b.totalday from
  (select count(1) soldday
  from
  (select iss_date,sum(qty_sold*i.rods/200) qtysold
  from dpt_sale_day${years} a,item i
  where a.item_id=i.item_id and  iss_date>=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,6)||'01' FROM DUAL)
  and iss_date<=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,8) FROM DUAL)
  group by iss_date)
  where qtysold>200) a,
  
  (select days totalday from sale_days
  where  date1=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,6) FROM DUAL)) b

