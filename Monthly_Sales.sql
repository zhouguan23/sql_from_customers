select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='直营常规' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计'  as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='直营常规' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='直营常规' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='直营常规' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='直营常规' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-1) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-1) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='直营常规' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-1) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-1) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='OTO' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='OTO' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='OTO' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='OTO' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='OTO' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-1) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-1) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='OTO' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-1) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-1) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select distinct AREA_code,area_name from DIM_REGION
WHERE 
1=1 ${if(len(UNION_AREA)=0,"", "anD  UNION_AREA_NAME  in ('"+UNION_AREA+"')")}

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_region B on A.AREA_CODE=B.AREA_CODE

where accountname='DTP' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}
group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_region B on A.AREA_CODE=B.AREA_CODE

where accountname='DTP' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}
group by '0','合计'



select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='DTP' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-1) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-1) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name

union

select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='DTP' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-1) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-1) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='DTP' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='DTP' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 'test' from dual
/*select 区域代码,区域名称,sum(销售额),1-(SUM(NO_TAX_COST)/sum(NO_TAX_AMOUNT)) as 毛利率 from

(select 
area_code as 区域代码,
area_name as 区域名称,
NO_TAX_AMOUNT as 销售额, 
NO_TAX_COST,
NO_TAX_AMOUNT 
from FACT_sale
where (sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and Area_code in ('"+region+"')")}
and goods_code in (select goods_code from DIM_DTP where create_month=substr('${StartDate}',1,7)) 

UNION
select 
area_code as 区域代码,
area_name as 区域名称,
NO_TAX_AMOUNT as 销售额, 
NO_TAX_COST,
NO_TAX_AMOUNT 
from FACT_DELIVERY
where (sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and Area_code in ('"+region+"')")}
and goods_code in (select goods_code from DIM_DTP where create_month=substr('${StartDate}',1,7)) 
 )

group by 区域代码,区域名称*/

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='加盟' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='加盟' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='加盟' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union

select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='加盟' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='加盟' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-1) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-1) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='加盟' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-1) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-1) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'


select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='批发' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='批发' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='批发' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-1) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-1) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='批发' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-1) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-1) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='关联交易' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率
from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='关联交易' and 
(sale_date between to_date('${StartDate}','yyyy-mm-dd') and to_date('${EndDate}','yyyy-mm-dd')) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='关联交易' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A left join DIM_Region B on A.area_code=B.area_code

where accountname='关联交易' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select 
A.area_code as 区域代码,
B.area_name as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='批发' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by A.area_code,B.area_name
union
select 
'0' as 区域代码,
'合计' as 区域名称,
sum(NO_TAX_AMOUNT) as 销售额,
(case when sum(no_tax_amount)=0 then 0 else 
1-(sum(NO_TAX_COST)/SUM(NO_TAX_AMOUNT)) end) as 毛利率

from  DM_MONTHLY_SALE A LEFT JOIN DIM_REGION B ON A.AREA_CODE=B.AREA_CODE

where accountname='批发' and 
(sale_date between add_months(to_date('${StartDate}','yyyy-mm-dd'),-12) and  add_months(to_date('${EndDate}','yyyy-mm-dd'),-12) ) and 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}

group by '0','合计'

select * from (Select area_code,area_name from DIM_REGION where 1=1  ${if(len(region)=0,"", "and Area_code in ('"+region+"')")}
${if(len(UNION_AREA)=0,"", "anD  UNION_AREA_NAME  in ('"+UNION_AREA+"')")}
union
select '0' as area_Code,'合计' as area_name from dual)
ORDER BY decode(area_code,'0',100,area_code)

SELECT  
DISTINCT  
UNION_AREA_NAME  
FROM  
DIM_REGION

