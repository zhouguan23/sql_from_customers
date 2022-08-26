select
bp.project_id,
bp.project_name, -- 项目名称
bpd.period_id,
bpd.period_name, -- 分期
bb.building_id,
bb.building_name, -- 楼栋
br.room_name, -- 房源名称
brs.room_code, -- 房源ID
bpt.`name` as product_name, -- 业态
brs.cus_name, -- 客户名称
bvc.visit_name as visit_channel, -- 获客渠道
brs.is_loan, -- 付款方式
brs.sale_consultant_name, -- 置业顾问
brs.report_agent_name, -- 报备人姓名
bcl.channel_id, -- 代理公司编码
bcl.channel_name, -- 代理公司全称
brs.order_date, -- 认购日期
brs.achieve_count_date, -- 业绩统计日期
bcs.contract_status_name, -- 合同状态
brs.contract_date, -- 签约日期
brs.order_total_price as order_total_price, -- 认购金额
bsm.charge_sum, -- 回款金额
(CASE WHEN brs.contract_total_price != ''
THEN brs.contract_total_price - bsm.charge_sum
ELSE brs.order_total_price - bsm.charge_sum END ) AS not_charge_sum, -- 未回款金额
sum(bs.js_amount) as room_amount, -- 其中：基础佣金及跳点佣金
sum(bs.yf_amount) as yf_amount, -- 应结算金额
sum(sfdetail.sf_amount) as sf_amount -- 实际已结算金额
from
base_room_sale brs
inner join base_channel_project bcp on bcp.project_id = brs.project_id
inner join base_channel bcl on bcl.channel_id = bcp.channel_id
inner join base_project bp on bp.project_id = brs.project_id
inner join base_period bpd on bpd.period_id = brs.period_id
inner join base_building bb on bb.building_id = brs.building_id
inner join base_room br on br.room_code = brs.room_code
inner join base_product_type bpt on bpt.product_id = brs.product_id
left join base_visit_channel bvc on bvc.visit_id = brs.visit_channel
left join base_contract_status bcs ON bcs.contract_status_code = brs.contract_state
left join base_sale_money bsm on bsm.sale_id = brs.sales_no
left join bill_sales_detail bs on bs.sales_no = brs.sales_no
left join bill_sf_fee_item_detail sfdetail on sfdetail.bill_sales_id = bs.id and sfdetail.sf_id = (select id from bill_sf_fee_item where id = sfdetail.sf_id and audit_status = 5)
left join (select DISTINCT bur.project_id, osi.account from base_project_user bur
  inner join obj_staff_info osi on osi.staff_no = bur.user_no
) bpu on bpu.project_id = brs.project_id
where bcp.del_flag = 0
and bs.bill_sales_status = 1
and bs.sales_order_status = 1
and bs.bill_sales_type = 1
and brs.valid_time < NOW() and brs.invalid_time > NOW()
${if(len(fine_username)==0,'',"and bpu.account='"+ fine_username +"'")}
${if(len(city)==0,'',"and bp.city_id='"+ city +"'")}
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
brs.room_code,
bcl.channel_id

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

