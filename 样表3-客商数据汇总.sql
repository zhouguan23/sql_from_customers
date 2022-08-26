select
t.city_id,
t.city_name,
t.project_id,
t.project_name, -- 代理项目名称
t.channel_id, -- 代理公司编码
t.channel_name, -- 代理公司全称
t.contract_id, -- 代理合同ID
t.channel_factor, -- 代理方式
t.channel_type, -- 代理类型
sum(t.room_amount) as room_amount, -- 其中：基础佣金及跳点佣金
sum(t.bonus_amount) as bonus_amount, -- 其中：奖励金
sum(t.yf_amount) as yf_amount, -- 累计应付金额
sum(t.sf_amount) as sf_amount, -- 累计已付金额
sum(t.yf_amount) - sum(t.sf_amount) as rm_amount, -- 应付未付金额
sum(t.quota) as quota, -- 当期业绩目标
sum(t.order_total_price) as order_total_price -- 实际完成业绩
from
(
select
bc.city_id,
bc.city_name,
bp.project_id,
bp.project_name, -- 代理项目名称
bcl.channel_id, -- 代理公司编码
bcl.channel_name, -- 代理公司全称
bcp.contract_id, -- 代理合同ID
bcp.channel_factor, -- 代理方式
bcp.channel_type, -- 代理类型
sum(bs.js_amount) as room_amount, -- 其中：基础佣金及跳点佣金
0 as bonus_amount, -- 其中：奖励金
sum(bs.yf_amount) as yf_amount, -- 累计应付金额
sum(sfdetail.sf_amount) as sf_amount, -- 累计已付金额
sum(bs.yf_amount) - sum(sfdetail.sf_amount) as rm_amount, -- 应付未付金额
sum(bcq.quota) as quota, -- 当期业绩目标
sum(brs.order_total_price) as order_total_price -- 实际完成业绩
from
base_channel_project bcp
inner join base_project bp on bp.project_id = bcp.project_id
inner join base_city bc on bc.city_id = bp.city_id and bc.area_id = bp.area_id
inner join base_channel bcl on bcl.channel_id = bcp.channel_id
left join bill_sales_detail bs on bs.project_id = bcp.project_id and bs.vendor_id = bcl.vendor_id and bs.channel_type = bcp.channel_type
left join base_room_sale brs on brs.sales_no = bs.sales_no and brs.valid_time < NOW() and brs.invalid_time > NOW()
left join bill_sf_fee_item_detail sfdetail on sfdetail.bill_sales_id = bs.id and sfdetail.sf_id = (select id from bill_sf_fee_item where id = sfdetail.sf_id and audit_status = 5)
left join base_channel_quota bcq on bcq.contract_id = bcp.contract_id
left join (select DISTINCT bur.project_id, osi.account from base_project_user bur
  inner join obj_staff_info osi on osi.staff_no = bur.user_no
) bpu on bpu.project_id = bcp.project_id
where bcp.del_flag = 0
and bs.bill_sales_status = 1
and bs.sales_order_status = 1
and bs.bill_sales_type = 1
${if(len(fine_username)==0,'',"and bpu.account='"+ fine_username +"'")}
${if(len(city)==0,'',"and bc.city_id='"+ city +"'")}
${if(len(project)==0,'',"and bp.project_id='"+ project +"'")}
${if(len(period)==0,'',"and bpd.period_id='"+ period +"'")}
${if(len(channelid)==0,'',"and bcl.channel_id='"+ channelid +"'")}
${if(len(channelname)==0,'',"and bcl.channel_name='"+ channelname +"'")}
${if(len(channeltype)==0,'',"and bcp.channel_type='"+ channeltype +"'")}
${if(len(orderdatestart)==0,'',"and date_format(brs.order_date,'%Y-%m-%d') between '"+ orderdatestart +"'")}
${if(len(orderdateend)==0,'',"and '"+ orderdateend +"'")}
${if(len(updatestart)==0,'',"and date_format(sfdetail.update_date,'%Y-%m-%d') between '"+ updatestart +"'")}
${if(len(updateend)==0,'',"and '"+ updateend +"'")}
GROUP BY
bc.city_id,
bc.city_name,
bp.project_id,
bp.project_name,
bcl.channel_id,
bcl.channel_name,
bcp.contract_id,
bcp.channel_factor,
bcp.channel_type

UNION ALL

select 
bc.city_id,
bc.city_name,
bp.project_id,
bp.project_name, -- 代理项目名称
bcl.channel_id, -- 代理公司编码
bcl.channel_name, -- 代理公司全称
bcp.contract_id, -- 代理合同ID
bcp.channel_factor, -- 代理方式
bcp.channel_type, -- 代理类型
0 as room_amount, -- 其中：基础佣金及跳点佣金
sum(byf.yf_amount) as bonus_amount, -- 其中：奖励金
sum(byf.yf_amount) as yf_amount, -- 累计应付金额
sum(sf.sf_amount) as sf_amount, -- 累计已付金额
sum(byf.yf_amount) - sum(sf.sf_amount) as rm_amount, -- 应付未付金额
sum(bcq.quota) as quota, -- 当期业绩目标
0 as order_total_price -- 实际完成业绩
from 
base_channel_project bcp
inner join base_project bp on bp.project_id = bcp.project_id
inner join base_city bc on bc.city_id = bp.city_id and bc.area_id = bp.area_id
inner join base_channel bcl on bcl.channel_id = bcp.channel_id
left join bill_yf_fee_item byf on byf.project_id = bcp.project_id and byf.vendor_id = bcl.vendor_id and byf.channel_type = bcp.channel_type
left join bill_sf_fee_item sf on sf.yf_id = byf.id and sf.audit_status = 5
left join base_channel_quota bcq on bcq.contract_id = bcp.contract_id
left join (select DISTINCT bur.project_id, osi.account from base_project_user bur
  inner join obj_staff_info osi on osi.staff_no = bur.user_no
) bpu on bpu.project_id = bcp.project_id
where
not EXISTS(
select 1 from bill_yf_fee_item_detail detail where detail.yf_id = byf.id
)
${if(len(fine_username)==0,'',"and bpu.account='"+ fine_username +"'")}
${if(len(city)==0,'',"and bc.city_id='"+ city +"'")}
${if(len(project)==0,'',"and bp.project_id='"+ project +"'")}
${if(len(period)==0,'',"and bpd.period_id='"+ period +"'")}
${if(len(channelid)==0,'',"and bcl.channel_id='"+ channelid +"'")}
${if(len(channelname)==0,'',"and bcl.channel_name='"+ channelname +"'")}
${if(len(channeltype)==0,'',"and bcp.channel_type='"+ channeltype +"'")}
${if(len(updatestart)==0,'',"and date_format(sf.update_date,'%Y-%m-%d') between '"+ updatestart +"'")}
${if(len(updateend)==0,'',"and '"+ updateend +"'")}
GROUP BY
bc.city_id,
bc.city_name,
bp.project_id,
bp.project_name,
bcl.channel_id,
bcl.channel_name,
bcp.contract_id,
bcp.channel_factor,
bcp.channel_type
)t
GROUP BY
t.city_id,
t.city_name,
t.project_id,
t.project_name,
t.channel_id,
t.channel_name,
t.contract_id,
t.channel_factor,
t.channel_type


select
 city_id, -- 城市id
 city_name -- 城市名称
 from base_city;

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
	${if(len(city)==0,'',"and bp.city_id='"+ city +"'")}

select
 period_id, -- 分期id
 project_id, -- 项目id
 period_name -- 分期名称
 from base_period
 where project_id = '${project}';

