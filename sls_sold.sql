select  slsman_id ,sum(qty_sold*t_size)/200 qty,sum(amt_sold) amt
from pi_slsman_item_day a,plm_item i  where a.item_id=i.item_id and date1='${date1}' 
and sale_dept_id in   ('${dptno}') group by slsman_id 




select pstru_id,qty/250 qtyplan,round(amount*250/qty,0) dxplan,popul from plan_slsman where date1=substr('${date1}',1,6)
and com_id in ('${dptno}')


select slsman_id,note from slsman where is_mrb=1 and short_id in ('${dptno}') order by dpt_sale_id

select slsman_id,sum(qty_sold*i.t_size/50000) qty_month,sum(amt_sold) amt
from pi_slsman_item_day a,plm_item i
where a.item_id=i.item_id and date1>=(select to_char(to_date('${date1}','yyyymmdd'),'yyyymm')||'01' from dual) and
date1<='${date1}'
and sale_dept_id in  ('${dptno}')
group by slsman_id

select qty_plan/250 qtyplam,dxamt_plan from plan where date1=(select to_char(to_date('${date1}','yyyymmdd'),'yyyymm') from dual) 
and stru_id in ('${dptno}') and type='01'

select a.soldday,b.totalday from
  (select count(1) soldday
  from
  (select iss_date,sum(qty_sold) qtysold
  from dpt_sale_day${year}
  where iss_date>=(select to_char(to_date(${date1},'yyyymmdd'),'yyyymm')||'01' from dual) and
  iss_date<=(select to_char(to_date(${date1},'yyyymmdd'),'yyyymmdd') from dual)
  group by iss_date)
  where qtysold>2500) a,

  (select days totalday from sale_days
  where  date1=(SELECT TO_CHAR(to_date(${date1},'yyyymmdd'),'YYYYMM') FROM DUAL)) b

