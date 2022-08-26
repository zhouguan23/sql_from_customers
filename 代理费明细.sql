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
 org_id, -- 所属公司id
 org_name -- 所属公司名称
 from base_org where city_id = '${city}';

select
 period_id, -- 分期id
 project_id, -- 项目id
 period_name -- 分期名称
 from base_period
 where project_id = '${project}';

select
bs.id,
bs.bill_sales_id,
bs.sales_no,
brs.project_id,
brs.product_id,
brs.period_id,
brs.building_id,
br.id as room_id,
brs.room_code, -- 房源id
bp.project_name, -- 项目名称
bpd.period_name, -- 分期
bb.building_name, -- 楼栋
bpt.name as product_name, -- 业态
br.room_name, -- 房源名称
br.unite_no, -- 单元号
bos.order_status_name as order_status, -- 认购状态
bcs.contract_status_name  as contract_state, -- 合同状态
DATE_FORMAT(brs.achieve_count_date, '%Y-%m-%d') as achieve_count_date, -- 业绩统计日期
DATE_FORMAT(brs.order_date, '%Y-%m-%d') as order_date, -- 认购日期
DATE_FORMAT(brs.initial_contract_date, '%Y-%m-%d') as initial_contract_date, -- 草签日期
DATE_FORMAT(brs.contract_date, '%Y-%m-%d') as contract_date, -- 	签约日期
brs.total_price, -- 成交表价
brs.order_total_price, -- 认购总额
brs.contract_total_price,
bsm.charge_sum, -- 回款额
(CASE WHEN brs.contract_total_price != ''
THEN brs.contract_total_price - bsm.charge_sum
ELSE brs.order_total_price - bsm.charge_sum END ) AS not_charge_sum, -- 未回款额
brs.sale_consultant_name, -- 置业顾问
brs.sale_consultant_role, -- 销售角色
brs.sele_team_name, -- 销售人员所属公司
brs.sale_team_vendor_id, -- 销售人员公司商编
brs.nm_agent_id, -- 推荐人编码
brs.report_agent_name, -- 报备人姓名
brs.channel_name, -- 推荐人所属公司
brs.channel_way_vendor_id, -- 推荐人公司商编
bvc.visit_name as visit_channel, -- 获客渠道
brs.special_tag, -- 特殊交易标签
bs.channel_type, -- 代理类型
case 
when bs.channel_type = '1113001' then '内部一手代理'
when bs.channel_type = '1113002' then '外部一手代理'
when bs.channel_type = '1113003' then '内部二手代理'
when bs.channel_type = '1113004' then '外部二手代理'
when bs.channel_type = '1113005' then '内部拓客'
when bs.channel_type = '1113006' then '外部拓客'
when bs.channel_type = '1113007' then '其他'
when bs.channel_type = '9999999' then '全民营销'
else '-' end channel_type_name,
brs.is_loan, -- 认购付款方式
brs.cus_name, -- 客户名称
brs.online_agent_name, -- 上线经纪人名称
brs.online_agent_status, -- 上线经济人类型
brs.online_vendor_id, -- 上线经纪人所属商编
bcl.channel_name as online_channel_name, -- 上线经纪人所属公司
bs.agency_rate_no_tax, -- 代理费率(不含税）
bs.qh_contract_no, -- 企划合同编号
bs.qh_contract_name, -- 企划合同名称
bs.order_total_price_no_tax, -- 认购总额(不含税）
bs.tax_method, -- 计税方法
bs.js_amount, -- 应付代理费总额（含税）
bs.yf_amount,
ifnull(sfdetail.sf_amount,0) sf_amount, -- 已付代理费（含税）
bs.rm_amount, -- 应计提代理费（含税）
bs.js_amount_no_tax, -- 应付代理费总额（不含税）
bs.sf_amount_no_tax, -- 已付代理费（不含税）
bs.rm_amount_no_tax, -- 应计提代理费（不含税）
ifnull(bs.yc_amount,0) yc_amount,
ifnull(bs.sc_amount,0) sc_amount
from bill_sales_detail bs
inner join base_room_sale brs on brs.sales_no = bs.sales_no
inner join base_room br on br.room_code = brs.room_code
inner join base_project bp on bp.project_id = brs.project_id
inner join base_period bpd on bpd.period_id = brs.period_id
inner join base_building bb on bb.building_id = brs.building_id
inner join base_city bc on bc.city_id = bp.city_id and bc.area_id = bp.area_id
inner join base_org bo on bo.org_id = bp.org_id and bo.area_id = bp.area_id and bo.city_id = bp.city_id
left join base_product_type bpt on bpt.product_id = brs.product_id
left join base_order_status bos on bos.order_status_code = brs.order_status
left join base_contract_status bcs on bcs.contract_status_code = brs.contract_state
left join (select SUM(charge_sum) as charge_sum, sale_id from base_sale_money where del_flag = 0 GROUP BY sale_id) bsm on bsm.sale_id = brs.sales_no
left join base_visit_channel bvc on bvc.visit_id = brs.visit_channel
left join base_channel bcl on bcl.channel_id = brs.online_channel_id
left join bill_sf_fee_item_detail sfdetail on sfdetail.bill_sales_detail_id = bs.id and sfdetail.sf_id = (select id from bill_sf_fee_item where id = sfdetail.sf_id and audit_status = 5)
left join (select DISTINCT bur.project_id, osi.account from base_project_user bur
  inner join obj_staff_info osi on osi.staff_no = bur.user_no
) bpu on bpu.project_id = brs.project_id
where now() between brs.valid_time and brs.invalid_time
and bs.bill_sales_status = 1 and bs.bill_sales_type =1
${if(len(fine_username)==0,'',"and bpu.account='"+ fine_username +"'")}
${if(len(city)==0,'',"and bc.city_id='"+ city +"'")}
${if(len(project)==0,'',"and bp.project_id='"+ project +"'")}
${if(len(org)==0,'',"and bo.org_id='"+ org +"'")}
${if(len(period)==0,'',"and bpd.period_id='"+ period +"'")}
${if(len(orderdatestart)==0,'',"and date_format(brs.order_date,'%Y-%m-%d') between '"+ orderdatestart +"'")}
${if(len(orderdateend)==0,'',"and '"+ orderdateend +"'")}
${if(len(updatestart)==0,'',"and date_format(sfdetail.update_date,'%Y-%m-%d') between '"+ updatestart +"'")}
${if(len(updateend)==0,'',"and '"+ updateend +"'")}

