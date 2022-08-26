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
brs.project_id,
bp.project_name, -- 项目名称
bp.city_id,
bc.city_name, -- 城市名称
bp.org_id,
bo.org_name, -- 所属公司
bvc.visit_name as visit_channel, -- 获客渠道
sum(brs.order_total_price) as order_total_price, -- 成交金额
sum(bsm.charge_sum) as charge_sum, -- 回款金额
(CASE WHEN brs.contract_total_price != ''
THEN brs.contract_total_price - bsm.charge_sum
ELSE brs.order_total_price - bsm.charge_sum END ) as not_charge_sum, -- 未回款金额
sum(bs.js_amount) as js_amount, -- 代理费金额
sum(sfdetail.sf_amount) as sf_amount, -- 已付代理费金额
sum(bs.js_amount) - sum(sfdetail.sf_amount) as rm_amount, -- 未付代理费金额
sum(bs.yf_amount) - sum(sfdetail.sf_amount) as rea_rm_amount -- 其中：已达结佣条件的未付金额
from base_room_sale brs
inner join base_project bp on bp.project_id = brs.project_id
inner join base_city bc on bc.city_id = bp.city_id and bc.area_id = bp.area_id
inner join base_org bo on bo.org_id = bp.org_id and bo.area_id = bp.area_id and bo.city_id = bp.city_id
inner join bill_sales bs on bs.sales_no = brs.sales_no and brs.valid_time < NOW() and brs.invalid_time > NOW()
left join (select SUM(charge_sum) as charge_sum, sale_id from base_sale_money where del_flag = 0 GROUP BY sale_id) bsm on bsm.sale_id = brs.sales_no
left join base_visit_channel bvc on bvc.visit_id = brs.visit_channel
left join bill_sf_fee_item_detail sfdetail on sfdetail.bill_sales_id = bs.id and sfdetail.sf_id = (select id from bill_sf_fee_item where id = sfdetail.sf_id and audit_status = 5)
left join (select DISTINCT bur.project_id, osi.account from base_project_user bur
  inner join obj_staff_info osi on osi.staff_no = bur.user_no
) bpu on bpu.project_id = brs.project_id
where bs.bill_sales_status = 1 and bs.bill_sales_type =1
${if(len(fine_username)==0,'',"and bpu.account='"+ fine_username +"'")}
${if(len(city)==0,'',"and bc.city_id='"+ city +"'")}
${if(len(project)==0,'',"and bp.project_id='"+ project +"'")}
${if(len(org)==0,'',"and bo.org_id='"+ org +"'")}
${if(len(orderdatestart)==0,'',"and date_format(brs.order_date,'%Y-%m-%d') between '"+ orderdatestart +"'")}
${if(len(orderdateend)==0,'',"and '"+ orderdateend +"'")}
${if(len(updatestart)==0,'',"and date_format(sfdetail.update_date,'%Y-%m-%d') between '"+ updatestart +"'")}
${if(len(updateend)==0,'',"and '"+ updateend +"'")}
GROUP BY brs.project_id,
bp.project_name,
bp.city_id,
bc.city_name,
bp.org_id,
bo.org_name,
brs.visit_channel;

