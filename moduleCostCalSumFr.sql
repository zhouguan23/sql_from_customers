select t.id,
       round(t.fillin_date) fillin_date,
       t.bill_code,
       t.organ_id,
       t.organ_name,
       t.dept_id,
       t.dept_name,
       t.position_id,
       t.position_name,
       t.person_member_id,
       t.person_member_name,
       t.full_id,
       t.approve_finish_date,
       t.status,
       t.business_group_id,
       t.business_group_name,
       t.operation_code,
       t.remark,
       t.version,
       t.workshop_id,
       t.workshop_name,
       d.source_table,
       d.source_key,
       d.source_id,
       d.bom_id,
       d.bom_no,
       d.bom_name,
       d.day_output_qty,
       d.output_month_day,
       d.output_qty,
       d.module_watt,
       d.a_month_qty_watt,
       d.ave_demand_efficiency,
       d.cell_qty,
       d.cell_area,
       d.cell_loss_rate,
       d.module_a_rate,
       d.module_extraneous_rate,
       d.off_cell_price_reduction,
       d.one_marinade_cost,
       d.cell_price,
       d.two_marinade_cost,
       d.accessories_price,
       d.accessories_cost,
       d.artificial_cost,
       d.energy_con_cost,
       d.depreciation_cost,
       d.manufacturing_cost,
       d.module_machining_cost,
       d.cash_module_machining_cost,
       d.tax_cost,
       d.tax_cash_cost,
       d.freight_export_amount,
       d.period_amount,
       d.all_tax_cost_price,
       d.all_cash_tax_cost_price
  from st_m_cost_cal_summary t, st_m_cost_cal_summary_dtl d
  where 1=1 and t.id =d.main_id
  and t.status = 2000
${parameter1} -- 公司id
 ${parameter2} -- 车间id
 ${parameter3} -- 单据编号
 ${parameter4} -- 单据日期（起）
 ${parameter5} -- 单据日期（止）


select count(1) as rn
  from (select t.workshop_id
          from st_m_cost_cal_summary t, st_m_cost_cal_summary_dtl d
         where t.id = d.main_id
           and t.status = 2000         
           ${parameter2} -- 车间id
         group by t.workshop_id) t


