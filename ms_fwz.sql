select distinct dp.short_name,fwzname,fwzid
from strutofwz  a,dpt_sale dp where a.dpt_sale_id=dp.sale_dept_id order by fwzid

select  fwzid,sum(qty_sold)/250  qty from fwztd where date1='${date1}'  group by fwzid

select  fwzid,sum(qty_sold)/250  qty from fwztd 
where date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-12) ,'yyyyMM') from dual)
   group by fwzid

select  fwzid,sum(qty_sold)/250  qty from fwztd 
where date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1) ,'yyyyMM') from dual)
   group by fwzid

