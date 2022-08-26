select dpt_sale_id,  
 sum(qty_sold*i.t_size)/50000  qty,sum(amt_sold_with_tax) amt

from dpt_Sale_day${years} a,plm_item i  
where a.item_id=i.item_id  
and iss_date=(select to_char(to_date('${date1}','yyyymmdd'),'yyyyMMdd') from dual)
group by 
 dpt_sale_id  having sum(qty_sold)<>0




 select  a.dpt_sale_id, pop,c.qtyplan,c.dxamt_plan,d.days,round(qtyplan/days,2) dayplan
  from  
(select dpt_sale_id,pop from pop_xian) a,

(select stru_id,qty_plan/250 qtyplan,DXAMT_PLAN
from plan
where type='01' and date1=(SELECT  TO_CHAR(to_date('${date1}','YYYYMMDD'),'yyyyMM') FROM DUAL)) c,

(select days
from sale_days
where date1=(SELECT TO_CHAR(to_date('${date1}','YYYYMMDD'),'yyyyMM') FROM DUAL )) d
where  
      c.stru_id(+)=a.dpt_sale_id
    
 and a.dpt_sale_id<>'17010100'

 
SELECT DXAMT_PLAN FROM PLAN WHERE DATE1=(SELECT TO_CHAR(to_date('${date1}','YYYYMMdd'),'yyyyMM') FROM DUAL)
AND TYPE='02'
 

select dpt_sale_id,qty_plan yearplan,dxamt_plan from plan
where dpt_sale_id<>'17010100' and date1='201713'

select a.soldday,b.totalday, daypastyue ,yearpast,yeardays from
  (select count(1) soldday
  from
  (select iss_date,sum(qty_sold*i.t_size/50000) qtysold
  from dpt_sale_day${years} a,plm_item i
  where a.item_id=i.item_id and  iss_date>=(SELECT  TO_CHAR(to_date('${date1}','YYYYMMDD'),'yyyymm')||'01' FROM DUAL)
  and iss_date<=(SELECT  TO_CHAR(to_date('${date1}','YYYYMMDD'),'yyyymmdd') FROM DUAL)
  group by iss_date)
  where qtysold>200) a,
  
  (select days totalday from sale_days
  where  date1=(SELECT  TO_CHAR(to_date('${date1}','YYYYMMDD'),'yyyymm') FROM DUAL)) b,

(select to_date('${date1}','yyyymmdd')-to_date(to_char(to_date('${date1}','yyyymmdd'),'yyyymm')||'01','yyyymmdd')+1
  daypastyue
 from dual ),
 (select   to_date('${date1}','yyyymmdd')-TRUNC(SYSDATE, 'YYYY')+1 yearpast  from dual) ,
  (SELECT ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12) - TRUNC(SYSDATE, 'YYYY') yeardays FROM DUAL) 

select distinct item_type1 ,substr(item_type1,2,10) item_type2 from item_com order by item_type1

select dpt_sale_id, 
 sum(qty_sold*i.t_size)/50000  qty,sum(amt_sold_with_tax) amt

from dpt_Sale_day${years} a,plm_item i  
where a.item_id=i.item_id  
and iss_date>=( SELECT  TO_CHAR(to_date('${date1}','YYYYMMDD'),'yyyymm')||'01' FROM DUAL)
and iss_date<=(select  to_char(to_date('${date1}','yyyymmdd'),'yyyyMMdd')  from dual)
group by 
 dpt_sale_id having sum(qty_sold)<>0



select dpt_sale_id,  
 sum(qty_sold*i.t_size)/50000  qty,sum(amt_sold_with_tax) amt

from dpt_Sale_day${years} a,plm_item i ,item_com ic 
where a.item_id=i.item_id and i.item_id=ic.item_id 
and iss_date>='20171001' 
 and iss_date<='${date1}' 
group by 
 dpt_sale_id  having sum(qty_sold)<>0



select substr(sale_dept_id,5,4)||'0100' dpt_id,sum(gross_profit)/10000 gross, sum(gross_sold_month)/10000 grossmonth ,sum(gross_sold_year)/10000
grossyear from pi_dept_item_day where date1='${date1}'   group by 
substr(sale_dept_id,5,4)||'0100' 

SELECT DXAMT_PLAN yeardxamt FROM PLAN WHERE DATE1='201713' and type='02'

