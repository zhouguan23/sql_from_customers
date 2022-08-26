select
bc.channel_id, -- 代理公司编码
bc.channel_name, -- 代理公司全称
bp.project_name, -- 代理项目名称
bcp.contract_id, -- 代理合同ID
bcp.beg_date, -- 代理开始时间
bcp.end_date, -- 代理结束时间
bcp.channel_type, -- 代理类型
bcp.channel_factor, -- 代理方式
bp.project_id,
sum(case when bcq.`month`='1' then bcq.quota end) as quota_qty1,
sum(case when bcq.`month`='2' then bcq.quota end) as quota_qty2,
sum(case when bcq.`month`='3' then bcq.quota end) as quota_qty3,
sum(case when bcq.`month`='4' then bcq.quota end) as quota_qty4,
sum(case when bcq.`month`='5' then bcq.quota end) as quota_qty5,
sum(case when bcq.`month`='6' then bcq.quota end) as quota_qty6,
sum(case when bcq.`month`='7' then bcq.quota end) as quota_qty7,
sum(case when bcq.`month`='8' then bcq.quota end) as quota_qty8,
sum(case when bcq.`month`='9' then bcq.quota end) as quota_qty9,
sum(case when bcq.`month`='10' then bcq.quota end) as quota_qty10,
sum(case when bcq.`month`='11' then bcq.quota end) as quota_qty11,
sum(case when bcq.`month`='12' then bcq.quota end) as quota_qty12
from base_channel bc
inner join base_channel_project bcp on bcp.channel_id = bc.channel_id
left join base_project bp on bcp.project_id= bp.project_id
left join base_channel_quota bcq on bcq.contract_id = bcp.contract_id
left join (select DISTINCT bur.project_id, osi.account from base_project_user bur
  inner join obj_staff_info osi on osi.staff_no = bur.user_no
) bpu on bpu.project_id = bcp.project_id
where bcp.del_flag=0
and bcq.quota_type = '1115001'
${if(len(fine_username)==0,'',"and bpu.account='"+ fine_username +"'")}
${if(len(project)==0,'',"and bp.project_name='"+ project +"'")}
${if(len(channeltype)==0,'',"and bcp.channel_type='"+ channeltype +"'")}
${if(len(year)==0,'',"and bcq.year='"+ year +"'")}
GROUP BY bcp.channel_id;

select 
  DISTINCT bp.project_id,
	bp.project_name 
FROM
	base_project bp,
	base_project_user bpu,
	obj_staff_info osi
WHERE
	bp.project_id = bpu.project_id
	and osi.staff_no = bpu.user_no
	${if(len(fine_username)==0,'',"and osi.account='"+ fine_username +"'")}

