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
STREAM_ID, 
stream_name,
org_department_id ,
starter_id,
case when flow_run_time is null or flow_run_time ='' then TIMESTAMPDIFF(SECOND, start_time,now()) else flow_run_time end flow_run_time,
start_time,
NODE_MEMBER_ID,
node_receive_time,
node_complete_time,
case when node_run_time is null or node_run_time ='' then TIMESTAMPDIFF(SECOND, node_receive_time,now()) else node_run_time end node_run_time,
flow_state,
FLOW_LEVEL
from it_oa_stream A
where 1=1
and
flow_type NOT IN ('其他', '收文')
${if(len(FLOW_STATUS)=0,"","and flow_status in ('"+FLOW_STATUS+"')")} 
${if(len(FLOW_STATE)=0,"","and FLOW_STATE in ('"+FLOW_STATE+"')")} 
${if(len(isimp)=0,"","and flow_level in ('"+isimp+"')")} 
${if(FLOW_STATUS='未结',"","AND DATE(NODE_COMPLETE_TIME) BETWEEN '"+SDATE+"' AND '"+EDATE+"'")}

),
t2 as(
SELECT DISTINCT 
dep_ID,
level2,    -- level2 level3 level4
level3,
level4,
level5,
ORG_NAME
FROM it_dim_dep 
),
t3 as(
select DISTINCT 
user_name,
user_id
from it_dim_user
),
t4 as
(
select 
user_name,
user_id,
org_department_id
from it_dim_user
),
t5 as(
SELECT 
dep_ID,
ORG_NAME,
level2,    -- level2 level3 level4
level3,
level4,
level5
FROM it_dim_dep 
)

select
concat(ifnull(t2.level2,''),'-',ifnull(t2.level3,''),'-',ifnull(t2.level4,''),'-',ifnull(t2.level5,'')) starter_dep,
concat(ifnull(t5.level2,''),'-',ifnull(t5.level3,''),'-',ifnull(t5.level4,''),'-',ifnull(t5.level5,'')) node_dep,
stream_id,
stream_name,
start_time,
round(flow_run_time/86400,2) lcsc,
t3.user_name starter_name,
t4.user_name node_name,
node_receive_time,
node_complete_time,
case when round(node_run_time/86400,2)<0.01 then '<0.01天' else round(node_run_time/86400,2) end node_run_time,
flow_state

from
t1 
left join  t2 on t1.org_department_id=t2.dep_id
left join  t3 on t1.starter_id = t3.user_id
left join  t4 on t1.node_member_id = t4.user_id -- t4 t5 通过审批人关联部门
left join  t5 on t4.org_department_id=t5.dep_id

where 1=1
-- 用户权限过滤 
${IF(INARRAY("股份流程效率全权限", fine_role)>0,""," AND t5.level2 in (select distinct level2 from it_user_dep_view where login_name = '"+fine_username+"')")}
${IF(INARRAY("股份流程效率全权限", fine_role)>0,""," AND (t5.level3 is null or t5.level3 in (select distinct level3 from it_user_dep_view where login_name = '"+fine_username+"'))")}
${IF(INARRAY("股份流程效率全权限", fine_role)>0||INARRAY("OA房产主业管理员", fine_role)>0||INARRAY("OA职能公司管理员", fine_role)>0,"","AND (t5.LEVEL2 = '珠海华发实业股份有限公司' OR t5.level4 is null or t5.level4 in (select distinct level4 from it_user_dep_view where login_name = '"+fine_username+"'))")}
-- 下拉框过滤
${if(len(level2)=0,"","and case when t5.level2 = '珠海华发实业股份有限公司' then '股份本部' else t5.level2 end in ('"+level2+"')")}     
${if(len(level3)=0,"","and t5.level3 in ('"+level3+"')")}   
${if(len(level4)=0,"","and t5.level4 in ('"+level4+"')")}   
${if(len(emp_name)=0,"","and t4.user_name in ('"+emp_name+"')")}   

order by 
node_complete_time ,
t5.level2,  
t5.level3,
t5.level4,
t4.user_name



select distinct  level4
from it_dim_dep
where 
level2 <> '其他'
-- 用户权限控制
${IF(INARRAY("股份流程效率全权限", fine_role)>0||INARRAY("OA房产主业管理员", fine_role)>0||INARRAY("OA职能公司管理员", fine_role)>0, fine_role)>0,""," AND (level2 = '珠海华发实业股份有限公司' or level4 is null or level4 in (select distinct level4 from it_user_dep_view where login_name = '"+fine_username+"'))")}
-- 下拉框控制
${if(len(level2)=0,"","and case when level2 = '珠海华发实业股份有限公司' then '股份本部' else level2 end in ('"+level2+"')")}
${if(len(level3)=0,"","and level3 in ('"+level3+"')")}

select 
distinct 
user_name 
from it_oa_stream a 
left join it_dim_user b on a.node_member_id = b.user_id 
left join  it_dim_dep c on b.org_department_id=c.dep_id
where 1=1
${if(len(level3)=0,"and level3 in ('"+level3+"')")}
${if(len(level4)=0,"and level4 in ('"+level4+"')")}

select distinct flow_state from it_oa_stream
where flow_type NOT IN ('其他', '收文')

