select D.area_code,D.cus_code,sum(A.no_tax_amount) as no_tax_amount,sum(A.no_tax_cost) as no_tax_cost
from dim_cus D
left join dm_sale_tmp A on A.area_code=D.area_code and A.cus_code=D.cus_code
and  A.sale_date >= to_date('${StartDate}','yyyy/mm/dd') and A.sale_date <= to_date('${EndDate}','yyyy/mm/dd') where 1=1 and 
${if(len(area_code)==0,"1=1","D.area_code in ('"+area_code+"')")} and
${if(len(cus_code)==0,"1=1","D.cus_code in ('"+cus_code+"')")} and
${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by D.area_code,D.cus_code

select A.area_code,A.cus_code,sum(A.no_tax_amount) as vip_amount,sum(A.no_tax_cost) as no_tax_cost,sum(A.tax_amount) as vip_tax_amount,sum(origin_amount) as vip_origin_amount
from dm_sale_tmp A
left join dim_cus D on A.area_code=D.area_code and A.cus_code=D.cus_code
where A.vip='是' and A.sale_date >= to_date('${StartDate}','yyyy/mm/dd') and A.sale_date <= to_date('${EndDate}','yyyy/mm/dd') and
${if(len(area_code)==0,"1=1","A.area_code in ('"+area_code+"')")} and
${if(len(cus_code)==0,"1=1","A.cus_code in ('"+cus_code+"')")} and
${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by A.area_code,A.cus_code

select count(C.insiderid) as available_vip,B.area_code,B.cus_code from dim_vip B 
join (select distinct insiderid from dm_available_vip A where A.sale_date >= add_months(to_date('${StartDate}','yyyy/mm/dd'),-6) and A.sale_date <= to_date('${EndDate}','yyyy/mm/dd')) C on C.insiderid=B.insiderid
left join dim_cus D on B.area_code=D.area_code and B.cus_code=D.cus_code
where
${if(len(area_code)==0,"1=1","B.area_code in ('"+area_code+"')")} and
${if(len(cus_code)==0,"1=1","B.cus_code in ('"+cus_code+"')")} and
${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by B.area_code,B.cus_code

select area_code,area_name from dim_region


select cus_code,cus_name from dim_cus where ${if(len(area_code)==0,"1=1","area_code in ('"+area_code+"')")}

select E.area_code,E.cus_code,sum(E.tran_num) as vip_sale_count
from dm_transaction E
left join dim_cus D on E.area_code=D.area_code and to_char(E.cus_code)=D.cus_code
where E.is_vip='Y' and E.sale_date >= to_date('${StartDate}','yyyy/mm/dd') and E.sale_date <= to_date('${EndDate}','yyyy/mm/dd') and
${if(len(area_code)==0,"1=1","E.area_code in ('"+area_code+"')")} and
${if(len(cus_code)==0,"1=1","E.cus_code in ('"+cus_code+"')")} and
${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by E.area_code,E.cus_code

select E.area_code,E.cus_code,sum(E.tran_num) as sale_count
from dm_transaction E
left join dim_cus D on E.area_code=D.area_code and to_char(E.cus_code)=D.cus_code
where E.sale_date >= to_date('${StartDate}','yyyy-mm-dd') and E.sale_date <= to_date('${EndDate}','yyyy-mm-dd') and
${if(len(area_code)==0,"1=1","E.area_code in ('"+area_code+"')")} and
${if(len(cus_code)==0,"1=1","E.cus_code in ('"+cus_code+"')")} and
${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by E.area_code,E.cus_code

select B.area_code,B.cus_code,count(insiderid) as sale_vip_count
from dim_vip B
left join dim_cus D on B.area_code=D.area_code and B.cus_code=D.cus_code
where 
B.credate >= to_date('${StartDate}','yyyy/mm/dd') and B.credate<=to_date('${EndDate}','yyyy/mm/dd') and
${if(len(area_code)==0,"1=1","B.area_code in ('"+area_code+"')")} and
${if(len(cus_code)==0,"1=1","B.cus_code in ('"+cus_code+"')")} and
${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by B.area_code,B.cus_code

select B.area_code,B.cus_code,count(insiderid) as vip_count
from dim_vip B
left join dim_cus D on B.area_code=D.area_code and B.cus_code=D.cus_code
where B.credate <= to_date('${EndDate}','yyyy/mm/dd') and
${if(len(area_code)==0,"1=1","B.area_code in ('"+area_code+"')")} and
${if(len(cus_code)==0,"1=1","B.cus_code in ('"+cus_code+"')")} and
${if(len(attribute)==0,"1=1","D.attribute in ('"+attribute+"')")}
group by B.area_code,B.cus_code

SELECT DISTINCT AREA_NAME
FROM  
DIM_REGION 
WHERE  
AREA_CODE IN ('${area_code}')

