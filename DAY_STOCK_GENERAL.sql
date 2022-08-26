select A.*,B.area_name from DAY_DM_STOCK_GENERAL A inner join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE
where 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}  
--and ddate=last_day(to_date('${Date}'||'-01','yyyy-mm-dd'))



ORDER BY A.AREA_CODE ASC

select A.*,B.area_name from DM_STOCK_GENERAL A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE
where 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}   and ddate=last_day(add_months(to_date('${Date}'||'-01','yyyy-mm-dd'),-12))


ORDER BY A.AREA_CODE ASC

select A.*,B.area_name from DM_STOCK_GENERAL A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE
where 1=1 ${if(len(region)=0,"", "and A.Area_code in ('"+region+"')")}  and ddate=last_day(add_months(to_date('${Date}'||'-01','yyyy-mm-dd'),-1))



ORDER BY A.AREA_CODE ASC

--select A.AREA_CODE,B.area_name from DM_STOCK_GENERAL A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE
select AREA_CODE,area_name from DIM_REGION


SELECT DISTINCT dr.AREA_CODE, dr.AREA_NAME 
FROM DIM_REGION dr,USER_AUTHORITY  ua

WHERE 
1=1 
${if(len(region)=0,""," and AREA_CODE in ('"+region+"')")}
and (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
order by dr.AREA_CODE asc

select aa.area_code,aa.dczzts,bb.last_year_dczzts,cc.last_dczzts from 
 
(select AREA_CODE,
(case when (sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))
*to_number(add_months(to_date('${Date}', 'YYYY-MM'),1) -to_date('${Date}', 'YYYY-MM'))
end) as dczzts
from DM_TURNOVER_ALL
where Date1='${Date}'
AND 1=1 ${if(len(region)=0,""," and area_code in ('"+region+"')")}
group by area_code) aa,

(select AREA_CODE,
(case when (sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))
*to_number(add_months(add_months(to_date('${Date}', 'YYYY-MM'),1),-12) -add_months(to_date('${Date}', 'YYYY-MM'),-12))
end) as last_year_dczzts
from DM_TURNOVER_ALL
where  Date1 = to_char(add_months(to_date('${Date}','yyyy-mm'),-12),'yyyy-mm')
AND 1=1 ${if(len(region)=0,""," and area_code in ('"+region+"')")}
group by area_code) bb,

(select AREA_CODE,
(case when (sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))
*to_number(add_months(add_months(to_date('${Date}', 'YYYY-MM'),1),-1) -add_months(to_date('${Date}', 'YYYY-MM'),-1))
end) as last_dczzts
from DM_TURNOVER_ALL
where Date1=to_char(add_months(to_date('${Date}','yyyy-mm'),-1),'yyyy-mm')
AND 1=1 ${if(len(region)=0,""," and area_code in ('"+region+"')")}
group by area_code) cc

where aa.area_code=bb.area_code(+)
  and aa.area_code=cc.area_code(+)

select aa.dczzts,bb.last_year_dczzts,cc.last_dczzts from 
 
(select 
(case when (sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))
*to_number(add_months(to_date('${Date}', 'YYYY-MM'),1) -to_date('${Date}', 'YYYY-MM'))
end) as dczzts
from DM_TURNOVER_ALL
where Date1='${Date}'
AND 1=1 ${if(len(region)=0,""," and area_code in ('"+region+"')")}) aa,

(select 
(case when (sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))
*to_number(add_months(add_months(to_date('${Date}', 'YYYY-MM'),1),-12) -add_months(to_date('${Date}', 'YYYY-MM'),-12))
end) as last_year_dczzts
from DM_TURNOVER_ALL
where  Date1 = to_char(add_months(to_date('${Date}','yyyy-mm'),-12),'yyyy-mm')
AND 1=1 ${if(len(region)=0,""," and area_code in ('"+region+"')")}) bb,

(select 
(case when (sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zypscb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))
*to_number(add_months(add_months(to_date('${Date}', 'YYYY-MM'),1),-1) -add_months(to_date('${Date}', 'YYYY-MM'),-1))
end) as last_dczzts
from DM_TURNOVER_ALL
where Date1=to_char(add_months(to_date('${Date}','yyyy-mm'),-1),'yyyy-mm')
AND 1=1 ${if(len(region)=0,""," and area_code in ('"+region+"')")}
) cc

