select '1137'||substr(dpt_sale_id,1,4) dpt_sale_id,qty_plan/250 yearplan,dxamt_plan from plan
where dpt_sale_id<>'17010100' and date1=substr('${date1}',1,4)||'  '  

select distinct item_type1 ,substr(item_type1,2,10) item_type2 from item_com order by item_type1

select  i.kind, brand_id itemgr_id,IC.PRI_RTL,
case when yieldly_type=1 then '省内' else '省外' end as  is_imported,ic.item_type1, 
case when is_thin=1 then '细支' else '其他' end is_thin,
 sum(qty_sold_year*i.t_size)/50000  qty,sum(amt_sold_year) amt, 
 sum(qty_sold_year_same*i.t_size)/50000  qtysame
 ,sum(amt_sold_year_same)  amtsame

from pi_com_item_day a,plm_item i ,item_com@orahzbo ic 
where a.item_id=i.item_id and i.item_id=ic.item_id
and date1=（select max(date1) from pi_dept_item_day)
 
group by  
  i.kind,brand_id,IC.PRI_RTL,yieldly_type,ic.item_type1,is_thin
 order by i.kind,ic.item_type1 
 




select  i.kind,  
 round(sum(qty_sold_year*i.t_size)/50000,1)  qty 

from pi_com_item_day a,plm_item i  
where a.item_id=i.item_id   
and date1=（select max(date1)  from pi_dept_item_day)
 
group by  
  i.kind 
 order by i.kind 
 


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



select round(sum(qty_sold_year*t_size)/50000,0) qty,
round(sum(amt_sold_year)*50000/sum(qty_sold_year*t_size),0) dxamt,
round(sum(qty_sold_year*t_size)/200/8287700*yeardays/daypast,2) popjun
  from pi_com_item_day a,plm_item i ,
  (
select trunc(sysdate)-to_date(to_char(sysdate,'yyyy')||'0101','yyyymmdd')+1 daypast from dual
),
(
SELECT ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12) - TRUNC(SYSDATE, 'YYYY') yeardays  FROM DUAL
) 
where a.item_id=i.item_id and date1=(select max(date1) from pi_dept_item_day)


select  ic.item_type1, 
 round(  sum(qty_sold_year*i.t_size)/50000,1)  qty 

from pi_com_item_day a,plm_item i ,item_com@orahzbo ic 
where a.item_id=ic.item_id and a.item_id=i.item_id
and date1=（select max(date1) from pi_dept_item_day)
 
group by  
 ic.item_type1
 order by ic.item_type1 
 


