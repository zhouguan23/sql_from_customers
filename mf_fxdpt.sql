select dpt_sale_id, i.kind,brand_id itemgr_id,IC.PRI_RTL,yieldly_type is_imported,ic.item_type1, 
 sum(qty_sold*i.t_size)/50000  qty,sum(amt_sold_with_tax) amt

from dpt_Sale_day2019 a,plm_item i ,item_com ic 
where a.item_id=i.item_id and i.item_id=ic.item_id 
and iss_date=(select to_char(sysdate,'yyyymmdd') from dual)
group by 
 dpt_sale_id, i.kind,brand_id,IC.PRI_RTL,yieldly_type,ic.item_type1  having sum(qty_sold)<>0



select  a.dpt_sale_id, pop,c.qtyplan,c.dxamt_plan,d.days,round(qtyplan/days,2) dayplan
  from  
(select dpt_sale_id,pop from pop_xian) a,

(select dpt_sale_id stru_id,qty_plan/250 qtyplan,DXAMT_PLAN
from plan
where type='01' and date1=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,6) FROM DUAL)) c,

(select days
from sale_days
where date1=(SELECT SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,6) FROM DUAL)) d
where  
      c.stru_id=a.dpt_sale_id
    
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
where dpt_sale_id<>'17010100' and date1=(select to_char(sysdate,'yyyy') from dual) ||'  '

select a.soldday,b.totalday, daypastyue ,yeardays from
  (select count(1) soldday
  from
  (select iss_date,sum(qty_sold*i.t_size/200) qtysold
  from dpt_sale_day2019 a,plm_item i
  where a.item_id=i.item_id and  iss_date>=(SELECT  TO_CHAR(SYSDATE,'YYYYMM')||'01' FROM DUAL)
  and iss_date<=(SELECT TO_CHAR(SYSDATE,'YYYYMMDD') FROM DUAL)
  group by iss_date)
  where qtysold>200) a,
  
  (select days totalday from sale_days
  where  date1=(SELECT TO_CHAR(SYSDATE,'YYYYMM') FROM DUAL)) b,
(select to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd')
- to_date(to_char(sysdate,'yyyyMM')||'01','yyyymmdd')+1 daypastyue
 from dual ),
  (SELECT ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12) - TRUNC(SYSDATE, 'YYYY') yeardays FROM DUAL) 

select distinct item_type1 ,substr(item_type1,2,10) item_type2 from item_com order by item_type1

select dpt_sale_id, i.kind,brand_id itemgr_id,IC.PRI_RTL,yieldly_type is_imported,ic.item_type1, 
 sum(qty_sold*i.t_size)/50000  qty,sum(amt_sold_with_tax) amt

from dpt_Sale_day2019 a,plm_item i ,item_com ic 
where a.item_id=i.item_id and i.item_id=ic.item_id 
and iss_date>=to_char(sysdate,'yyyymm')||'01'
and iss_date<=to_char(sysdate,'yyyymmdd')
group by 
 dpt_sale_id, i.kind,brand_id,IC.PRI_RTL,yieldly_type,ic.item_type1  having sum(qty_sold)<>0



select dpt_sale_id, i.kind, brand_id itemgr_id,IC.PRI_RTL,yieldly_type is_imported,ic.item_type1, 
 sum(qty_sold*i.t_size)/50000  qty,sum(amt_sold_with_tax) amt

from dpt_Sale_day2019 a,plm_item i ,item_com ic 
where a.item_id=i.item_id and i.item_id=ic.item_id 
 
group by 
 dpt_sale_id, i.kind,brand_id,IC.PRI_RTL,yieldly_type,ic.item_type1  having sum(qty_sold)<>0



