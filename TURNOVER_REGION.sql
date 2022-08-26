select AREA_CODE,
substr(date1,6,7) as months,

(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))*(add_months(to_Date(date1||'01','yyyy-mm-dd'),1) - to_Date(date1||'01','yyyy-mm-dd')) end) as dczzts,


(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))=0 then null else
(sum(nvl(dckc,0))+sum(nvl(zykc,0)))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))*(add_months(to_Date(date1||'01','yyyy-mm-dd'),1) - to_Date(date1||'01','yyyy-mm-dd')) end) as zzzts,

(case when sum(nvl(zycb,0))=0 then null else
sum(nvl(zykc,0))/sum(nvl(zycb,0))*(add_months(to_Date(date1||'01','yyyy-mm-dd'),1) - to_Date(date1||'01','yyyy-mm-dd')) end) as zyzzts



from DM_TURNOVER_ALL
where substr(Date1,1,4)='${date}'
and 1=1 ${IF(LEN(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or gather='集采DTP')","")}

group by area_code,date1

SELECT AREA_CODE, AREA_NAME,UNION_AREA_NAME 
FROM DIM_REGION
WHERE 
1=1
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME in ('"+UNION_AREA+"')")}
 ${if(len(AREA)=0,""," and area_code in ('"+AREA+"')")}
order by sorted

select distinct gather from DM_TURNOVER_ALL


select (CASE WHEN to_char(sysdate,'YYYY')>'${Date}' 
THEN count(*)
ELSE ADD_MONTHS(trunc(sysdate,'mm'),-0)-TRUNC(SYSDATE, 'YYYY') END) as days
from dim_day
where to_char(DDATE,'YYYY')='${Date}'

select AREA_CODE,sum(sum_amount) as up

from dw_sum_cost_area_type
where 
--substr(Date1,1,4)='${date}'
DATE1=to_char('${date}')-1||'-12' 
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by area_code

select area_code,(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)))




from DM_TURNOVER_ALL

WHERE substr(date1,1,4)='${date}' and date1 < to_char(sysdate,'yyyy-mm')

and 1=1 ${IF(LEN(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or gather='集采DTP')","")}

group by area_code

select AREA_CODE, sum(dckc_amount)

from dw_sum_cost_area_type
where DATE1=to_char('${date}')-1||'-12'
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}
group by area_code

select AREA_CODE, sum(zykc_amount) 

from dw_sum_cost_area_type
where DATE1=to_char('${date}')-1||'-12'
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}
group by area_code

select area_code,sum(nvl(zycb,0))

from DM_TURNOVER_ALL

WHERE substr(date1,1,4)='${date}' and date1 < to_char(sysdate,'yyyy-mm')

and 1=1 ${IF(LEN(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or gather='集采DTP')","")}

group by area_code

select union_area_name from 
(
Select  purchase union_area_name,min(sorted) sorted from DIM_region where 1=1
 ${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME in ('"+UNION_AREA+"')")}
 ${if(len(AREA)=0,""," and area_code in ('"+AREA+"')")}
 group by purchase
union 
select '全国' union_area_name,10000 sorted from dual
) order by sorted

select purchase union_area_name,(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)-nvl(nbglcb,0))) sum_amount

from DM_TURNOVER_ALL A left join dim_region B on a.area_code=b.area_code

WHERE substr(date1,1,4)='${date}' and date1 < to_char(sysdate,'yyyy-mm')

and 1=1 ${IF(LEN(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
--and trans_party_relation='Y'
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or gather='集采DTP')","")}

group by purchase

union
select '全国' as union_area_name,(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))) sum_amount

from DM_TURNOVER_ALL A left join dim_region B on a.area_code=b.area_code

WHERE substr(date1,1,4)='${date}' and date1 < to_char(sysdate,'yyyy-mm')

and 1=1 ${IF(LEN(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or gather='集采DTP')","")}

group by '全国'

select union_area_name, sum(zykc_amount)  

from dw_sum_cost_area_type a left join dim_region b on a.area_code=b.area_code
where DATE1=to_char('${date}')-1||'-12' 
--substr(Date1,1,4)='${date}'
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
and trans_party_relation='Y'
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by union_area_name

union
select '全国' as union_area_name, sum(zykc_amount)  

from dw_sum_cost_area_type a left join dim_region b on a.area_code=b.area_code
where DATE1=to_char('${date}')-1||'-12' 
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by '全国'


select union_area_name,sum(nvl(zycb,0))

from DM_TURNOVER_ALL A left join dim_region B on a.area_code=b.area_code

WHERE substr(date1,1,4)='${date}' and date1 < to_char(sysdate,'yyyy-mm')

and 1=1 ${IF(LEN(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
and trans_party_relation='Y'
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or gather='集采DTP')","")}
group by union_area_name
union

select '全国' as union_area_name,sum(nvl(zycb,0))

from DM_TURNOVER_ALL A left join dim_region B on a.area_code=b.area_code

WHERE substr(date1,1,4)='${date}' and date1 < to_char(sysdate,'yyyy-mm')

and 1=1 ${IF(LEN(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or gather='集采DTP')","")}

group by '全国'

select purchase union_area_name, sum(dckc_amount)

from dw_sum_cost_area_type A left join DIM_REGION B on a.area_code=b.area_code
where DATE1=to_char('${date}')-1||'-12'
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
--and trans_party_relation='Y'
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by  purchase
union
select '全国' as union_area_name, sum(dckc_amount)

from dw_sum_cost_area_type A left join DIM_REGION B on a.area_code=b.area_code
where DATE1=to_char('${date}')-1||'-12'
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by  '全国'

select purchase union_area_name, sum(sum_amount) as up

from dw_sum_cost_area_type A left join DIM_REGION B on a.area_code=b.area_code
where --substr(Date1,1,4)='${date}'
DATE1=to_char('${date}')-1||'-12' 
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
--and trans_party_relation='Y'
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by purchase

union
select '全国' as union_area_name, sum(sum_amount) as up

from dw_sum_cost_area_type A left join DIM_REGION B on a.area_code=b.area_code
where --substr(Date1,1,4)='${date}'
DATE1=to_char('${date}')-1||'-12' 
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}

${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}
group by '全国'


select purchase union_area_name,
substr(date1,6,7) as months,

(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)-nvl(nbglcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)-nvl(nbglcb,0)))*(add_months(to_Date(date1||'01','yyyy-mm-dd'),1) - to_Date(date1||'01','yyyy-mm-dd')) end) as dczzts,


(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)-nvl(nbglcb,0)))=0 then null else
(sum(nvl(dckc,0))+sum(nvl(zykc,0)))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0))+sum(nvl(glcb,0)-nvl(nbglcb,0)))*(add_months(to_Date(date1||'01','yyyy-mm-dd'),1) - to_Date(date1||'01','yyyy-mm-dd')) end) as zzzts,

(case when sum(nvl(zycb,0))=0 then null else
sum(nvl(zykc,0))/sum(nvl(zycb,0))*(add_months(to_Date(date1||'01','yyyy-mm-dd'),1) - to_Date(date1||'01','yyyy-mm-dd')) end) as zyzzts



from DM_TURNOVER_ALL A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE
where substr(Date1,1,4)='${date}'
and 1=1 ${IF(LEN(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
--and trans_party_relation='Y'
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or gather='集采DTP')","")}
group by purchase,date1

union

select '全国' as union_area_name,
substr(date1,6,7) as months,

(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0)))=0 then null else
sum(nvl(dckc,0))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0)))*(add_months(to_Date(date1||'01','yyyy-mm-dd'),1) - to_Date(date1||'01','yyyy-mm-dd')) end) as dczzts,


(case when (sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0)))=0 then null else
(sum(nvl(dckc,0))+sum(nvl(zykc,0)))/(sum(nvl(zycb,0))+sum(nvl(jmcb,0))+sum(nvl(pfcb,0)))*(add_months(to_Date(date1||'01','yyyy-mm-dd'),1) - to_Date(date1||'01','yyyy-mm-dd')) end) as zzzts,

(case when sum(nvl(zycb,0))=0 then null else
sum(nvl(zykc,0))/sum(nvl(zycb,0))*(add_months(to_Date(date1||'01','yyyy-mm-dd'),1) - to_Date(date1||'01','yyyy-mm-dd')) end) as zyzzts



from DM_TURNOVER_ALL A left join DIM_REGION B ON A.AREA_CODE=B.AREA_CODE
where substr(Date1,1,4)='${date}'
and 1=1 ${IF(LEN(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or gather='集采DTP')","")}
group by '全国',date1



select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc

select AREA_CODE,sum(sum_amount) as up

from dw_sum_cost_area_type
where 

('${date}'=to_char(sysdate,'YYYY') and date1=to_char(add_months(sysdate,-1),'YYYY-MM') or 
'${date}'<to_char(sysdate,'YYYY') and date1=to_char('${date}'||'-12' ))



and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by area_code

select purchase union_area_name, sum(sum_amount) as up

from dw_sum_cost_area_type A left join DIM_REGION B on a.area_code=b.area_code
where 
('${date}'=to_char(sysdate,'YYYY') and date1=to_char(add_months(sysdate,-1),'YYYY-MM') or 
'${date}'<to_char(sysdate,'YYYY') and date1=to_char('${date}'||'-12' ))
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
--and trans_party_relation='Y'
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by purchase

union
select '全国' as union_area_name, sum(sum_amount) as up

from dw_sum_cost_area_type A left join DIM_REGION B on a.area_code=b.area_code
where 
('${date}'=to_char(sysdate,'YYYY') and date1=to_char(add_months(sysdate,-1),'YYYY-MM') or 
'${date}'<to_char(sysdate,'YYYY') and date1=to_char('${date}'||'-12' )) 
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}

${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}
group by '全国'


select AREA_CODE, sum(dckc_amount)

from dw_sum_cost_area_type
where 
('${date}'=to_char(sysdate,'YYYY') and date1=to_char(add_months(sysdate,-1),'YYYY-MM') or 
'${date}'<to_char(sysdate,'YYYY') and date1=to_char('${date}'||'-12' ))
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}
group by area_code

select purchase union_area_name, sum(dckc_amount)

from dw_sum_cost_area_type A left join DIM_REGION B on a.area_code=b.area_code
where 
('${date}'=to_char(sysdate,'YYYY') and date1=to_char(add_months(sysdate,-1),'YYYY-MM') or 
'${date}'<to_char(sysdate,'YYYY') and date1=to_char('${date}'||'-12' ))
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
and trans_party_relation='Y'
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by  purchase
union
select '全国' as union_area_name, sum(dckc_amount)

from dw_sum_cost_area_type A left join DIM_REGION B on a.area_code=b.area_code
where 
('${date}'=to_char(sysdate,'YYYY') and date1=to_char(add_months(sysdate,-1),'YYYY-MM') or 
'${date}'<to_char(sysdate,'YYYY') and date1=to_char('${date}'||'-12' ))
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by  '全国'

select AREA_CODE, sum(zykc_amount) 

from dw_sum_cost_area_type
where 
('${date}'=to_char(sysdate,'YYYY') and date1=to_char(add_months(sysdate,-1),'YYYY-MM') or 
'${date}'<to_char(sysdate,'YYYY') and date1=to_char('${date}'||'-12' ))
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}
group by area_code

select union_area_name, sum(zykc_amount) 

from dw_sum_cost_area_type a left join dim_region b on a.area_code=b.area_code
where 
('${date}'=to_char(sysdate,'YYYY') and date1=to_char(add_months(sysdate,-1),'YYYY-MM') or 
'${date}'<to_char(sysdate,'YYYY') and date1=to_char('${date}'||'-12' ))
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
and trans_party_relation='Y'
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by union_area_name

union
select '全国' as union_area_name, sum(zykc_amount) 

from dw_sum_cost_area_type a left join dim_region b on a.area_code=b.area_code
where 
('${date}'=to_char(sysdate,'YYYY') and date1=to_char(add_months(sysdate,-1),'YYYY-MM') or 
'${date}'<to_char(sysdate,'YYYY') and date1=to_char('${date}'||'-12' ))
and 1=1 ${IF(LEN(gather)=0,""," and bus_type in ('"+gather+"')")}
and 1=1 ${IF(LEN(Scate)=0,"",if(Scate='是'," and sub_category='阿胶' ","and sub_category!='阿胶'") )}
${IF(LEN(DTP)=0,""," and DTP in ('"+DTP+"')")}
${IF(JCDTP=='是'," and (DTP='是' or bus_type='集采DTP')","")}

group by '全国'


select a.area_code,a.area_name,a.UNION_AREA_NAME,a.purchase from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}

order by a.sorted 

select a.area_code,a.area_name,a.UNION_AREA_NAME,a.purchase from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
--${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by a.sorted 

