with t1 as
(
select
dep_ID,
dep_name,
ORG_NAME,
level2,
level3,
level4,
STREAM_ID, 
stream_name,
start_time,
user_name,
b.org_department_id ,
flow_run_time lcsc,
count(NODE_MEMBER_ID) jds,
SUM(NODE_RUN_TIME)/count(NODE_MEMBER_ID) jdsc,
max(node_run_time) max_node
from it_oa_stream A
left join it_dim_user b on a.starter_id = b.user_id
LEFT JOIN it_dim_dep c ON b.org_department_id=c.dep_id
where flow_type NOT IN ('其他', '收文')
-- and FLOW_STATUS = '已结'
  ${if(len(isimp)=0,"","and flow_level in ('"+isimp+"')")} 
-- 下拉框过滤
${if(len(level2)=0,"","and case when level2 = '珠海华发实业股份有限公司' then '股份本部' else level2 end in ('"+level2+"')")}     
${if(len(level3)=0,"","and (level3 is null or level3 in ('"+level3+"'))")}   
${if(len(level4)=0,"","and (level4 is null or level4 in ('"+level4+"'))")} 
${if(len(form_name)=0,"","and form_appid in ('"+form_name+"')")}  
AND DATE(start_time) BETWEEN  '${SDATE}' AND '${EDATE}'
and form_name in (
'HFYX18-引进全民经纪人、二手渠道、拓客公司的申请方案（含合同）',
'HFYX08-项目开盘方案（含付款政策）呈文审批表',
'SD11-项目开盘方案（含付款政策）及营销系统设置呈文审批表',
'SD12-项目备案价、折实价、折扣体系（含付款方式）（含付款政策）及营销系统设置呈文审批表',
'HFYX01-项目付款政策呈文审批表',
'HFYX04-营销政策统一申请呈文审批表（股份发起）',
'HFYX07-项目备案价、折实价、折扣体系（含付款方式）申请方案'
)
${if(len(iscomp)=0,"","and flow_status in ('"+iscomp+"')")}  

group by 
dep_ID,
dep_name,
level2,
level3,
level4,
dep_ID,
ORG_NAME,
level3,
STREAM_ID, 
stream_name,
start_time,
user_name,
ORG_DEPARTMENT_ID,
lcsc

)
select
distinct
ORG_NAME,
dep_name,
level2,
level3,
level4,
stream_id,
stream_name,
start_time,
user_name,
round(lcsc/86400,2) lcsc,
jds,
round(jdsc/86400,2) jdsc,
round(max_node/86400,2) max_node
from
t1 
where 1=1
 order by ${if(type1='1','lcsc','jdsc')} desc -- limit 3000

select 
distinct 
case when level2 = '珠海华发实业股份有限公司' then '股份本部' else level2 end LEVEL2 from it_dim_dep 
where level2 <> '其他'


select 
distinct
level3 
from it_dim_dep
where level2 <> '其他'
${if(len(level2)=0,"","and case when level2 = '珠海华发实业股份有限公司' then '股份本部' else level2 end in ('"+level2+"')")}


select distinct  level4
from it_dim_dep
where 
level2 <> '其他'

-- 下拉框控制
${if(len(level2)=0,"","and case when level2 = '珠海华发实业股份有限公司' then '股份本部' else level2 end in ('"+level2+"')")}
${if(len(level3)=0,"","and level3 in ('"+level3+"')")}

select distinct form_appid, form_name
from it_oa_stream a
LEFT JOIN it_dim_dep c ON a.org_department_id=c.dep_id
where 1=1
-- 下拉框控制
${if(len(level2)=0,"","and case when level2 = '珠海华发实业股份有限公司' then '股份本部' else level2 end in ('"+level2+"')")}
${if(len(level3)=0,"","and level3 in ('"+level3+"')")}
${if(len(level4)=0,"","and level4 in ('"+level4+"')")}
and form_name in (
'HFYX18-引进全民经纪人、二手渠道、拓客公司的申请方案（含合同）',
'HFYX08-项目开盘方案（含付款政策）呈文审批表',
'SD11-项目开盘方案（含付款政策）及营销系统设置呈文审批表',
'SD12-项目备案价、折实价、折扣体系（含付款方式）（含付款政策）及营销系统设置呈文审批表',
'HFYX01-项目付款政策呈文审批表',
'HFYX04-营销政策统一申请呈文审批表（股份发起）',
'HFYX07-项目备案价、折实价、折扣体系（含付款方式）申请方案'
)

