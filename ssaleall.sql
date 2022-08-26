select com_id,sum(qty_sold*t_size)/50000 qtyday,sum(amt_sold) amtday,sum(gross_profit) grossday, case when sum(qty_sold)<>0 then round(sum(amt_sold)*50000/sum(qty_sold*t_size),0) else 0 end  dxday ,

sum(qty_sold_month*t_size)/50000 qtymonth,sum(amt_sold_month) amtmonth,sum(gross_sold_month) grossmonth,case when sum(qty_sold_month)<>0 then round(sum(amt_sold_month)*50000/sum(qty_sold_month*t_size),0)  else 0 end dxmonth,

sum(qty_sold_year*t_size)/50000 qtyyear,sum(amt_sold_year) amtyear,sum(gross_sold_year) grossyear,
case when sum(qty_sold_year)<>0 then round(sum(amt_sold_year)*50000/sum(qty_sold_year*t_size),0)  else 0 end dxyear,

sum(qty_sold_month_same*t_size)/50000 qtymonthsame,sum(amt_sold_month_same) amtmonthsame,sum(gross_sold_month_same) grossmonthsame,
case when sum(qty_sold_month_same)<>0 then 
round(sum(amt_sold_month_same)*50000/sum(qty_sold_month_same*t_size),0) else 0 end dxmonthsame,

sum(qty_sold_year_same*t_size)/50000 qtyyearsame,sum(amt_sold_year_same) amtyearsame,sum(gross_sold_year_same) grossyearsame,
case when sum(qty_sold_year_same)<>0 then 
round(sum(amt_sold_year_same)*50000/sum(qty_sold_year_same*t_size),0) else 0 end  dxyearsame

from hz_s_com_day a,plm_item i where a.item_id=i.item_id and  date1='${date1}' group by com_id



select * from s_com order by note

select com_id,qty_plan,amt_plan  from com_plan where date1=(select to_char(sysdate,'yyyy') from dual)||'  '


select dayyearpast,yeardays   from (
select to_date('${date1}','yyyymmdd')-to_date(to_char(sysdate,'yyyy')||'0101' ,'yyyymmdd') +1 dayyearpast from dual) ,

( SELECT ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12) - TRUNC(SYSDATE, 'YYYY') yeardays FROM DUAL)


select sum(qty_sold*t_size)/50000 qtyday,sum(amt_sold) amtday,sum(gross_profit) grossday, case when sum(qty_sold)<>0 then round(sum(amt_sold)*50000/sum(qty_sold*t_size),0) else 0 end  dxday ,

sum(qty_sold_month*t_size)/50000 qtymonth,sum(amt_sold_month) amtmonth,sum(gross_sold_month) grossmonth,case when sum(qty_sold_month)<>0 then round(sum(amt_sold_month)*50000/sum(qty_sold_month*t_size),0)  else 0 end dxmonth,

sum(qty_sold_year*t_size)/50000 qtyyear,sum(amt_sold_year) amtyear,sum(gross_sold_year) grossyear,
case when sum(qty_sold_year)<>0 then round(sum(amt_sold_year)*50000/sum(qty_sold_year*t_size),0)  else 0 end dxyear,

sum(qty_sold_month_same*t_size)/50000 qtymonthsame,sum(amt_sold_month_same) amtmonthsame,sum(gross_sold_month_same) grossmonthsame,
case when sum(qty_sold_month_same)<>0 then 
round(sum(amt_sold_month_same)*50000/sum(qty_sold_month_same*t_size),0) else 0 end dxmonthsame,

sum(qty_sold_year_same*t_size)/50000 qtyyearsame,sum(amt_sold_year_same) amtyearsame,sum(gross_sold_year_same) grossyearsame,
case when sum(qty_sold_year_same)<>0 then 
round(sum(amt_sold_year_same)*50000/sum(qty_sold_year_same*t_size),0) else 0 end  dxyearsame

from hz_s_com_day a,plm_item i where a.item_id=i.item_id and  date1='${date1}'  


