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

select '1137'||substr(dpt_sale_id,1,4) dpt_sale_id,qty_plan/250 yearplan,dxamt_plan from plan
where dpt_sale_id<>'17010100' and date1=substr('${date1}',1,4)||'  '  

select a.soldday,b.totalday, daypastyue from
  (select count(1) soldday
  from
  (select  date1,sum(qty_sold ) qtysold
  from pi_dept_item_day 
  where date1>=(SELECT SUBSTR('${date1}',1,6)||'01' FROM DUAL)
  and date1<='${date1}'
  group by date1 )
  where qtysold>1000) a,
    
  (select days totalday from sale_days@orahzbo
  where  date1=substr('${date1}',1,6) ) b,
  
(  select to_date('${date1}','yyyymmdd') 
-  to_date(to_char(to_date('${date1}','yyyymmdd'),'yyyymm')||'01','yyyymmdd')+1  daypastyue
 from dual  ) c

select distinct item_type1 ,substr(item_type1,2,10) item_type2 from item_com order by item_type1

select sale_dept_id dpt_sale_id, i.kind, brand_id itemgr_id,IC.PRI_RTL,yieldly_type is_imported,ic.item_type1, is_thin,
 sum(qty_sold_year*i.t_size)/50000  qty,sum(amt_sold_year) amt, 
 sum(qty_sold_year_same*i.t_size)/50000  qtysame
 ,sum(amt_sold_year_same)  amtsame

from pi_dept_item_day a,plm_item i ,item_com@orahzbo ic 
where a.item_id=i.item_id and i.item_id=ic.item_id  and date1='${date1}'
 
group by  
 sale_dept_id, i.kind,brand_id,IC.PRI_RTL,yieldly_type,ic.item_type1,is_thin
 




select vend_id,short_name from pi_vend where vend_id in 
(select distinct brdowner_id from plm_item i ,pi_com_month a where i.item_id=a.item_id 
and a.date1>='201601' and qty_sold<>0
) order by vend_id

select dayyearpast,yeardays from 
(
select to_char(to_date('${date1}','yyyymmdd'),'ddd')   dayyearpast
 from dual),
 ( 
  SELECT ADD_MONTHS(TRUNC(to_date('${date1}','yyyymmdd'), 'YYYY'), 12) - TRUNC(to_date('${date1}','yyyymmdd'), 'YYYY') yeardays FROM DUAL
  )

select brdowner_id,sale_dept_id dpt_sale_id, 
 sum(qty_sold_year*i.t_size)/50000  fqty ,
 sum(qty_sold_year_same*i.t_size)/50000   qtyt

from  pi_dept_item_day a,plm_item i  ,pi_vend f
where a.item_id=i.item_id and i.brdowner_id=f.vend_id 
  and date1='${date1}'
group by brdowner_id,sale_dept_id   



select brdowner_id,dpt_sale_id, 
 sum(qty_sold*i.t_size)/50000  fqty 

from dpt_Sale_day2017 a,plm_item i  ,factory f
where a.item_id=i.item_id and i.brdowner_id=f.fact_id 
 and iss_date<=(select to_char(add_months(sysdate,-12),'yyyymmdd') from dual)
group by brdowner_id,dpt_sale_id having sum(qty_sold)<>0



