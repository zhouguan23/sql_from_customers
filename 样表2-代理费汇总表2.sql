select
t.city_id,
t.city_name,
t.project_id,
t.project_name,
t.org_id,
t.org_name,
t.channel_type,
t.channel_type_name,
t.order_total_price,
sum(t.charge_sum) as charge_sum,
sum(t.not_charge_sum) as not_charge_sum,
sum(t.room_amount) as room_amount,
sum(t.bonus_amount) as bonus_amount,
sum(t.sf_amount) as sf_amount,
sum(t.rm_amount) as rm_amount,
sum(t.rea_rm_amount) as rea_rm_amount
from(
select
bc.city_id,
bc.city_name,
bp.project_id,
bp.project_name,
bp.org_id,
bo.org_name, -- 所属公司
detail.channel_type, -- 代理类别
case 
when detail.channel_type = '1113001' then '内部一手代理'
when detail.channel_type = '1113002' then '外部一手代理'
when detail.channel_type = '1113003' then '内部二手代理'
when detail.channel_type = '1113004' then '外部二手代理'
when detail.channel_type = '1113005' then '内部拓客'
when detail.channel_type = '1113006' then '外部拓客'
when detail.channel_type = '1113007' then '其他'
when detail.channel_type = '9999999' then '全民营销'
else '-' end channel_type_name,
sum(brs.order_total_price) as order_total_price, -- 成交金额
sum(bsm.charge_sum) as charge_sum, -- 回款金额
(CASE WHEN brs.contract_total_price != ''
THEN brs.contract_total_price - bsm.charge_sum
ELSE brs.order_total_price - bsm.charge_sum END ) as not_charge_sum, -- 未回款金额
sum(detail.js_amount) as room_amount, -- 其中：基础佣金及跳点佣金
0 as bonus_amount, -- 其中：奖励金
sum(sfdetail.sf_amount) as sf_amount, -- 已付代理费金额
sum(detail.js_amount) - sum(sfdetail.sf_amount) as rm_amount, -- 未付代理费金额
sum(detail.yf_amount) - sum(sfdetail.sf_amount) as rea_rm_amount -- 其中：已达结佣条件的未付金额
-- rm_amount - rea_rm_amount as -- 其中：未达结佣条件的未付金额
from bill_sales_detail detail
inner join base_room_sale brs on brs.sales_no = detail.sales_no and brs.valid_time < NOW() and brs.invalid_time > NOW()
inner join base_project bp on bp.project_id = brs.project_id
inner join base_city bc on bc.city_id = bp.city_id and bc.area_id = bp.area_id
inner join base_org bo on bo.org_id = bp.org_id and bo.area_id = bp.area_id and bo.city_id = bp.city_id
left join (select SUM(charge_sum) as charge_sum, sale_id from base_sale_money where del_flag = 0 GROUP BY sale_id) bsm on bsm.sale_id = brs.sales_no
left join bill_sf_fee_item_detail sfdetail on sfdetail.bill_sales_detail_id = detail.id and sfdetail.sf_id = (select id from bill_sf_fee_item where id = sfdetail.sf_id and audit_status = 5)
left join (select DISTINCT bur.project_id, osi.account from base_project_user bur
  inner join obj_staff_info osi on osi.staff_no = bur.user_no
) bpu on bpu.project_id = bp.project_id
where detail.bill_sales_status = 1
and detail.bill_sales_type =1
${if(len(fine_username)==0,'',"and bpu.account='"+ fine_username +"'")}
${if(len(city)==0,'',"and bc.city_id='"+ city +"'")}
${if(len(project)==0,'',"and bp.project_id='"+ project +"'")}
${if(len(org)==0,'',"and bo.org_id='"+ org +"'")}
${if(len(orderdatestart)==0,'',"and date_format(brs.order_date,'%Y-%m-%d') between '"+ orderdatestart +"'")}
${if(len(orderdateend)==0,'',"and '"+ orderdateend +"'")}
${if(len(updatestart)==0,'',"and date_format(sfdetail.update_date,'%Y-%m-%d') between '"+ updatestart +"'")}
${if(len(updateend)==0,'',"and '"+ updateend +"'")}
GROUP BY
bc.city_id,
bc.city_name,
bp.project_id,
bp.project_name,
bp.org_id,
bo.org_name, -- 所属公司
detail.channel_type

UNION All

select
bc.city_id,
bc.city_name,
bp.project_id,
bp.project_name,
bp.org_id,
bo.org_name, -- 所属公司
byf.channel_type, -- 代理类别
case 
when byf.channel_type = '1113001' then '内部一手代理'
when byf.channel_type = '1113002' then '外部一手代理'
when byf.channel_type = '1113003' then '内部二手代理'
when byf.channel_type = '1113004' then '外部二手代理'
when byf.channel_type = '1113005' then '内部拓客'
when byf.channel_type = '1113006' then '外部拓客'
when byf.channel_type = '1113007' then '其他'
when byf.channel_type = '9999999' then '全民营销'
else '-' end channel_type_name,
0 as order_total_price,
0 as charge_sum,
0 as not_charge_sum,
0 as room_amount, -- 其中：基础佣金及跳点佣金
sum(byf.yf_amount) as bonus_amount, -- 其中：奖励金
sum(sf.sf_amount) as sf_amount, -- 已付代理费金额
sum(byf.yf_amount) - sum(sf.sf_amount) as rm_amount, -- 未付代理费金额
sum(byf.yf_amount) - sum(sf.sf_amount) as rea_rm_amount -- 其中：已达结佣条件的未付金额
from bill_yf_fee_item byf
inner join base_project bp on bp.project_id = byf.project_id
inner join base_city bc on bc.city_id = bp.city_id and bc.area_id = bp.area_id
inner join base_org bo on bo.org_id = bp.org_id and bo.area_id = bp.area_id and bo.city_id = bp.city_id
left join bill_sf_fee_item sf on sf.yf_id = byf.id and sf.audit_status = 5
left join (select DISTINCT bur.project_id, osi.account from base_project_user bur
  inner join obj_staff_info osi on osi.staff_no = bur.user_no
) bpu on bpu.project_id = bp.project_id
where
not EXISTS(
select 1 from bill_yf_fee_item_detail detail where detail.yf_id = byf.id
)
${if(len(fine_username)==0,'',"and bpu.account='"+ fine_username +"'")}
${if(len(city)==0,'',"and bc.city_id='"+ city +"'")}
${if(len(project)==0,'',"and bp.project_id='"+ project +"'")}
${if(len(org)==0,'',"and bo.org_id='"+ org +"'")}
${if(len(updatestart)==0,'',"and date_format(sf.update_date,'%Y-%m-%d') between '"+ updatestart +"'")}
${if(len(updateend)==0,'',"and '"+ updateend +"'")}
GROUP BY
bc.city_id,
bc.city_name,
bp.project_id,
bp.project_name,
bp.org_id,
bo.org_name,
byf.channel_type
) t
GROUP BY
t.city_id,
t.city_name,
t.project_id,
t.project_name,
t.org_id,
t.org_name,
t.channel_type
order by t.city_id desc

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

