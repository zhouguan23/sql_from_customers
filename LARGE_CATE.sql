select LARGE_CATE,sum(no_tax_amount),(sum(no_tax_amount)-sum(no_tax_cost)) as raw_profit  from DM_SALE_LARGE_CATE
where 1=1
${if(len(cus)=0,""," and cus_Code in ('"+cus+"')")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
and 
TO_CHAR(sale_Date,'yyyy-mm-dd')>=(select DAY_ID from DIM_DAY where WEEK_DESC='星期一' and year_ID||WEEK_ID =(SELECT
year_ID||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy-mm-dd')='${Date}')
)
AND
TO_CHAR(sale_Date,'yyyy-mm-dd') <= (case when to_char(sysdate,'yyyy-mm-dd')>=(select DAY_ID from DIM_DAY where WEEK_DESC='星期一' and year_ID||WEEK_ID =(SELECT
year_ID||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy-mm-dd')='${Date}')) and  to_char(sysdate,'yyyy-mm-dd')<= (select DAY_ID from DIM_DAY where WEEK_DESC='星期日' and year_ID||WEEK_ID =(SELECT
(year_ID)||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy-mm-dd')='${Date}')
) then '${Date}' else 
(select DAY_ID from DIM_DAY where WEEK_DESC='星期日' and year_ID||WEEK_ID =(SELECT
(year_ID)||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy-mm-dd')='${Date}')
)
end
)
group by large_cate


select LARGE_CATE,sum(no_tax_amount),(sum(no_tax_amount)-sum(no_tax_cost)) as raw_profit
from DM_SALE_LARGE_CATE
where 1=1
${if(len(cus)=0,""," and cus_Code in ('"+cus+"')")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
and 
sale_Date>=(select ddate from DIM_DAY where WEEK_DESC='星期一' and year_ID||WEEK_ID =(SELECT
(year_ID-1)||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy-mm-dd')='${Date}')
)
AND
sale_Date<=(case when to_char(sysdate,'yyyy-mm-dd')>=(select DAY_ID from DIM_DAY where WEEK_DESC='星期一' and year_ID||WEEK_ID =(SELECT
year_ID||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy-mm-dd')='${Date}')) and  to_char(sysdate,'yyyy-mm-dd')<= (select DAY_ID from DIM_DAY where WEEK_DESC='星期日' and year_ID||WEEK_ID =(SELECT
(year_ID)||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy-mm-dd')='${Date}')
) then 



(select ddate from DIM_DAY where


 year_ID||WEEK_ID||week_desc =(SELECT
(year_ID-1)||WEEK_ID||week_desc FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy-mm-dd')='${Date}')
) else 

(select ddate from DIM_DAY where WEEK_DESC='星期日' and year_ID||WEEK_ID =(SELECT
(year_ID-1)||WEEK_ID FROM DIM_DAY WHERE TO_CHAR(DDATE,'yyyy-mm-dd')='${Date}')
)
end
)

group by large_cate


select distinct large_Cate from DM_SALE_LARGE_CATE

select LARGE_CATE,sum(no_tax_amount),(sum(no_tax_amount)-sum(no_tax_cost)) as raw_profit  from DM_SALE_LARGE_CATE
where 1=1
${if(len(cus)=0,""," and cus_Code in ('"+cus+"')")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
and 
TO_CHAR(sale_Date,'yyyy-mm-dd')>=(substr('${Date}',1,8)||'01')
AND
TO_CHAR(sale_Date,'yyyy-mm-dd')<='${Date}'

group by large_cate


select LARGE_CATE,sum(no_tax_amount),(sum(no_tax_amount)-sum(no_tax_cost)) as raw_profit  from DM_SALE_LARGE_CATE
where 1=1
${if(len(cus)=0,""," and cus_Code in ('"+cus+"')")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
and 
TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr(to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd')
,1,8)||'01')
AND
TO_CHAR(sale_Date,'yyyy/mm/dd')<=to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd')

group by large_cate


select LARGE_CATE,sum(no_tax_amount),(sum(no_tax_amount)-sum(no_tax_cost)) as raw_profit  from DM_SALE_LARGE_CATE
where 1=1
${if(len(cus)=0,""," and cus_Code in ('"+cus+"')")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
and 
TO_CHAR(sale_Date,'yyyy-mm-dd')>=(substr('${Date}',1,5)||'01-01')
AND
TO_CHAR(sale_Date,'yyyy-mm-dd')<='${Date}'

group by large_cate


select LARGE_CATE,sum(no_tax_amount),(sum(no_tax_amount)-sum(no_tax_cost)) as raw_profit  from DM_SALE_LARGE_CATE
where 1=1
${if(len(cus)=0,""," and cus_Code in ('"+cus+"')")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
and 
TO_CHAR(sale_Date,'yyyy/mm/dd')>=(substr(to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd')
,1,5)||'01/01')
AND
TO_CHAR(sale_Date,'yyyy/mm/dd')<=to_char(add_months(to_date('${Date}','yyyy/mm/dd'),-12),'yyyy/mm/dd')

group by large_cate


select distinct area_code,area_name from DIM_REGION

select distinct cus_code,cus_name from DIM_CUS
WHERE 
1=1
${if(len(area)=0,""," and area_Code in ('"+area+"')")}

