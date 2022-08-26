 WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)
select 
left(${if(version=1,"credate","date")},7) yearmonth,
case when left(right(${if(version=1,"credate","date")},2),1)=0 then right(${if(version=1,"credate","date")},1) else right(${if(version=1,"credate","date")},2) end credate,
len(case when left(right(${if(version=1,"credate","date")},2),1)=0 then right(${if(version=1,"credate","date")},1) else right(${if(version=1,"credate","date")},2) end),
areaname,cityname,projectname,PERIODNAME,SHORTNAME,ratio,
sum(${if(version=1,"DAY_ORDERNUM","ORDERSUIT")}) DAY_ORDERNUM,
sum(${if(version=1,"DAY_ORDERPRICE/10000","ORDERAMOUNT/10000")}) DAY_ORDERPRICE,
sum(${if(version=1,"DAY_ORDERNUM","ORDERSUIT")}*ratio) QY_DAY_ORDERNUM,
sum(${if(version=1,"DAY_ORDERPRICE/10000","ORDERAMOUNT/10000")}*ratio) QY_DAY_ORDERPRICE,
sum(${if(version=1,"DAY_ORDERNUM","ORDERSUIT")}*hf_ratio) HF_QY_DAY_ORDERNUM,
sum(${if(version=1,"DAY_ORDERPRICE/10000","ORDERAMOUNT/10000")}*hf_ratio) HF_QY_DAY_ORDERPRICE
from ${if(version='1',"F_MKT_PROJECT_SALE_DAILY","F_MKT_PROJECT_SALE")} a
left join DIM_PRODUCT_TYPE b on a.PRODUCTID=b.PRODUCTID
left join (select distinct PERIODID,RATIO,hf_ratio,areaid,cityid,CASE WHEN CP_FLAG = 'N'  THEN 0 ELSE 1 END CP_FLAG from DIM_MKT_PROJECT) c on a.PERIODID=c.PERIODID
where 1=1
-- ${if(len(YEARMONTH)=0,"",if(version=1,"and left(credate,7)  in ('"+YEARMONTH+"')","and left(date,7) in ('"+YEARMONTH+"')"))}
${if(len(AREANAME)=0,"","and areaid in ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and cityid in ('"+CITYNAME+"')")}
${if(len(PROJNAME)=0,"","and PROJECTID in ('"+PROJNAME+"')")}
and left(${if(version=1,"credate","date")},4)>='2020'
AND ${if(version=1,"credate","date")} BETWEEN '${SDATE}' AND '${EDATE}'
and PROJECTID IN(	SELECT DEPT_ID FROM user_org)
${if(len(cp_flag)=0,"","and cp_flag in ('"+cp_flag+"')")}
group by 
left(${if(version=1,"credate","date")},7) ,
len(case when left(right(${if(version=1,"credate","date")},2),1)=0 then right(${if(version=1,"credate","date")},1) else right(${if(version=1,"credate","date")},2) end),
case when left(right(${if(version=1,"credate","date")},2),1)=0 then right(${if(version=1,"credate","date")},1) else right(${if(version=1,"credate","date")},2) end,areaname,cityname,projectname,PERIODNAME,SHORTNAME,ratio 
order by 
left(${if(version=1,"credate","date")},7),
len(case when left(right(${if(version=1,"credate","date")},2),1)=0 then right(${if(version=1,"credate","date")},1) else right(${if(version=1,"credate","date")},2) end),
case when left(right(${if(version=1,"credate","date")},2),1)=0 then right(${if(version=1,"credate","date")},1) else right(${if(version=1,"credate","date")},2) end ,
charindex(areaname,'全部|珠海区域|华南区域|华东区域|华中区域|山东区域|北方区域|北京公司'),cityname,projectname,PERIODNAME,SHORTNAME



/*
select '2020-07' YEARMONTH
union all 
select '2020-08' YEARMONTH
union all 
select '2020-09' YEARMONTH
*/

select distinct the_month 
from dim_time 
where 
the_date
 between '2020-01-01' AND getdate()

 WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)
select distinct A.projectid,A.projectname
from F_MKT_PROJECT_SALE_DAILY A
left join (select distinct PERIODID,RATIO,AREAID,CITYID from DIM_MKT_PROJECT) c on a.PERIODID=c.PERIODID
where 1=1
${if(len(AREANAME)=0,"","AND AREAID IN('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND CITYID IN('"+CITYNAME+"')")}
and PROJECTID IN(	SELECT DEPT_ID FROM user_org )
ORDER BY projectid

 WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)
select distinct areaid,areaname,charindex(areaname,'全部|珠海区域|华南区域|华东区域|华中区域|山东区域|北方区域|北京公司')
from dim_mkt_project
where areaid is not null
and PROJECTID IN(	SELECT DEPT_ID FROM user_org )
ORDER BY
charindex(areaname,'全部|珠海区域|华南区域|华东区域|华中区域|山东区域|北方区域|北京公司')

 WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)
select distinct cityid,cityname
from dim_mkt_project
where areaid is not null
and PROJECTID IN(	SELECT DEPT_ID FROM user_org )
${if(len(AREANAME)=0,"","AND AREAID IN('"+AREANAME+"')")}

