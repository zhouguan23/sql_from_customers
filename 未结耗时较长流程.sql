select 
distinct 
case when level2 = '珠海华发实业股份有限公司' then '股份本部' else level2 end LEVEL2 from it_dim_dep 
where level2 <> '其他'
${IF(INARRAY("股份流程效率全权限", fine_role)>0,""," AND level2 in (select distinct level2 from it_user_dep_view where login_name = '"+fine_username+"')")}


select 
distinct
level3 
from it_dim_dep
where level2 <> '其他'
${if(len(level2)=0,"","and case when level2 = '珠海华发实业股份有限公司' then '股份本部' else level2 end in ('"+level2+"')")}
${IF(INARRAY("股份流程效率全权限", fine_role)>0,""," AND (level3 is null or level3 in (select distinct level3 from it_user_dep_view where login_name = '"+fine_username+"'))")}

with t1 as
(
select
c.ORG_NAME start_org,
c.level2,
c.level3,
c.level4,
concat(e.level2,'-',e.level3,'-',e.level4) receive_org,
STREAM_ID, 
stream_name,
b.user_name,
b.org_department_id ,
d.user_name node_member,
timestampdiff(second,node_receive_time,ifnull(node_complete_time,now()))  zlsc,
timestampdiff(second,start_time,ifnull(end_time,now())) lcsc,
count(case when date(node_complete_time)>'${EDATE}' or node_complete_time is null then 1 else null end) jds,
SUM(case when date(node_complete_time)>'${EDATE}' or node_complete_time is null then timestampdiff(second,node_receive_time,ifnull(node_complete_time,now())) else 0  end) jdsc
from it_oa_stream A
left join it_dim_user b on a.starter_id = b.user_id
LEFT JOIN it_dim_dep c ON b.org_department_id=c.dep_id
left join it_dim_user d on a.node_member_id = d.user_id
LEFT JOIN it_dim_dep e ON d.org_department_id=e.dep_id
where  flow_type in ('流程','发文')
-- and flow_status = '未结'
AND DATE(start_time) < '${EDATE}'
AND (DATE(END_TIME) IS NULL OR DATE(END_TIME)>'${EDATE}')
  ${if(len(isimp)=0,"","and flow_level in ('"+isimp+"')")} 

-- 用户权限过滤 
${IF(INARRAY("股份流程效率全权限", fine_role)>0,""," AND c.level2 in (select distinct level2 from it_user_dep_view where login_name = '"+fine_username+"')")}
${IF(INARRAY("股份流程效率全权限", fine_role)>0,""," AND (c.level3 is null or c.level3 in (select distinct level3 from it_user_dep_view where login_name = '"+fine_username+"'))")}
${IF(INARRAY("股份流程效率全权限", fine_role)>0||INARRAY("OA房产主业管理员", fine_role)>0||INARRAY("OA职能公司管理员", fine_role)>0,""," AND (c.level2 = '珠海华发实业股份有限公司' or c.level4 is null or c.level4 in (select distinct level4 from it_user_dep_view where login_name = '"+fine_username+"'))")}

-- 下拉框过滤

${if(len(level2)=0,"","and case when c.level2 = '珠海华发实业股份有限公司' then '股份本部' else c.level2 end in ('"+level2+"')")}     
${if(len(level3)=0,"","and  c.level3 in ('"+level3+"')")}   
${if(len(level4)=0,"","and  c.level4 in ('"+level4+"')")}  

 
group by 
start_org,
c.level2,
c.level3,
c.level4,
receive_org,
STREAM_ID, 
stream_name,
b.user_name,
ORG_DEPARTMENT_ID,
node_member,
zlsc,
lcsc
-- having count(case when flow_state in ( '待办已读' ,'待办未读') then 1 else 0 end)>0
)
select
distinct
start_org,
level2,
level3,
level4,
receive_org,
stream_id,
stream_name,
user_name,
node_member,
round(lcsc/86400,2) lcsc,
jds,
round(jdsc/JDS/86400,2) jdsc,
round(zlsc/86400,2) zlsc
from
t1 
where 1=1
and jds<>'0'
 order by ${if(type1='1','lcsc','jdsc')} desc -- limit 2000

select distinct  level4
from it_dim_dep
where 
level2 <> '其他'
-- 用户权限控制
${IF(INARRAY("股份流程效率全权限", fine_role)>0,""," AND (level3 is null or level3 in (select distinct level3 from it_user_dep_view where login_name = '"+fine_username+"'))")}
${IF(INARRAY("股份流程效率全权限", fine_role)>0||INARRAY("OA房产主业管理员", fine_role)>0||INARRAY("OA职能公司管理员", fine_role)>0,""," AND (level2 = '珠海华发实业股份有限公司' or level4 is null or level4 in (select distinct level4 from it_user_dep_view where login_name = '"+fine_username+"'))")}
-- 下拉框控制
${if(len(level2)=0,"","and case when level2 = '珠海华发实业股份有限公司' then '股份本部' else level2 end in ('"+level2+"')")}
${if(len(level3)=0,"","and level3 in ('"+level3+"')")}

