select distinct a.cus_code as cus_code,
a.cus_code||'|'||b.cus_name as cus_name  from dim_cus_transfer a,dim_cus b,dim_region c
where a.area_code=b.area_code
and a.cus_code=b.cus_code
and a.area_code=c.area_code
and 1=1 ${if(len(area)=0,""," and a.area_code  in ('"+area +"')")}
and 1=1 ${if(len(union_area)=0,""," and c.union_area_name  in ('"+union_area +"')")}
order by cus_code

select area_code,area_name from dim_region
where 1=1 ${if(len(union_area)=0,""," and union_area_name  in ('"+union_area +"')")}
order by sorted


select a.area_code,b.area_name,b.union_area_name,a.cus_code,c.cus_name,a.transfer_year,a.transfer_type,a.project_transfer_type,c.open_date,tax_transfer_fee,tax_investment_amount,investment_cost_recovery,sales_target_first,sales_target_second,sales_target_third,profit_forecast_first,profit_forecast_second,profit_forecast_third
from dim_cus_transfer a,dim_region b,dim_cus c
where a.area_code=b.area_code
and a.area_code=c.area_code
and a.cus_code=c.cus_code
and 1=1 ${if(len(area)=0,""," and a.area_code  in ('"+area +"')")}
and 1=1 ${if(len(union_area)=0,""," and b.union_area_name  in ('"+union_area +"')")}
and 1=1 ${if(len(cus)=0,""," and a.cus_code  in ('"+cus +"')")}
and 1=1 ${if(len(year)=0,"","and a.transfer_year in('"+year+"')")}
and 1=1 ${if(len(transfer_type)=0,""," and a.transfer_type  in ('"+transfer_type +"')")}
and 1=1 ${if(len(ptt)=0,""," and a.project_transfer_type in ('"+ptt +"')")}
and 1=1 ${if(len(open_date)=0,""," and to_char(c.open_date,'YYYY-MM') in ('"+open_date +"')")}
order by b.sorted,a.cus_code

select union_area_name from dim_region
order by sorted

select distinct transfer_year from dim_cus_transfer
order by transfer_year desc

select distinct transfer_type from dim_cus_transfer

select distinct to_char( b.open_date,'yyyy-mm')open_date from dim_cus_transfer a,dim_cus b
where a.area_code=b.area_code
and a.cus_code=b.cus_code
order by open_date desc

select distinct project_transfer_type from dim_cus_transfer

