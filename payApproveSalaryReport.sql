select t.period_name, --期间
       t.organ_name, --公司
       t.dept_name, --部门
       t.employeeno, --工号
       t.archive_name, --姓名
       t.station, --岗位
       t.employ_type, --用工性质
       t.enter_date, --入职日期
       t.current_station_salary, --职位薪酬
       t.leave_sort, --人员类别
       t.duty, --职等
       t.base_salary, --基本工资底薪       
       t.pos_pay, --岗位技能工资底薪
       t.shift_name, --班次
       t.att_rate, --出勤率
       t.base_pay, --基本工资
       t.station_skill_pay, --岗位技能工资
       t.job_allowance, --职务津贴
       t.station_base_pay, --岗位技能津贴
       t.zw_salary, --中威工资
       t.high_temperature_allowance, --高温津贴
       t.internal_trainer_allowance, --内训师津贴
       t.safety_officer_subsidy, --安全员津贴
       t.trade_union_member, --工会委员津贴
       t.safety_reward, --安全奖励
       t.tqm_bonus, --tqm奖金
       t.internal_recommendation_award, --内部推荐奖励
       t.new_project_bonus, --专项奖金
       t.bidding_bonus, --招标奖金
       t.reduction_incentive_bonus, --降本激励奖金
       t.award, --日常奖励
       t.marketing_bonus, --销售奖金
       t.performance_bonus, --月/季度绩效奖金
       t.wage_allowance, --工资补差
       t.late_shift_allowance, --晚班津贴
       t.overtime, --加班工资
       t.sick_leave_wage, --病假工资
       t.paid_leave_pay, --带薪事假工资
       t.training_wages, --培训工资
       t.meal_allowance, --餐补        
       t.forgotten_card_penalty_a, --忘刷卡罚款
       t.absenteeism_penalty_a, --旷工罚款
       t.late_and_early_penalty_a, --迟到早退罚款
       t.deduction_a, --扣餐费
       t.taxable_pay, --应付工资
       t.pension_personal_benefit_a, --养老个人保险
       t.unemployment_personal_a, --失业个人保险
       t.medical_personal_insurance_a, --医疗个人保险
       t.personal_total_a, --公积金个人
       t.competition_compensation, --竞业补偿
       t.receive_pay, --应领工资
       t.prev_taxable_income, --上月累计应缴所得额
       t.special_deduction, --专项扣除所得数
       t.cumulative_taxable_pay, --累计应缴所得额
       t.cumulative_withhold_tax, --累计已扣个税
       t.withholding_tax, --预扣个税
       t.mutual_aid, --互助金
       t.union_dues_a, --工会会费
       t.daily_punishment, --日常惩罚
       t.labor_insurance_deduction_a, --劳保费用
       t.dormitory_maintenance_fee_a, --宿舍维修费
       t.ic_card_cost_a, --餐卡工本费
       t.foreign_training_fee, --外训费
       t.social_security_fee, --社保服务费
       t.utility_fee_a, --水电费
       t.other_deduction, --其他扣款
       t.anniversary_bonus, --周年庆奖金
       t.start_red_envelope, --开工红包
       t.shift_differential, --春节值班津贴
       t.temporary_deduction, --暂扣挂账
       t.financial_deduction, --财务扣款抵账
       t.income_tax, --本月累计应扣缴税额
       t.prev_withholding_tax, --上月个税
       t.cumulative_tax_payable, --累计应补（退）税额
       t.compensation_tax_a            compensation_tax, --上月个税补差
       t.after_tax_reissue, --税后补发
       t.net_pay, --实发工资
       t.accountno, --工资卡号
       t.bank_type, --银行名称
       t.identitycard, --身份证
       h.telephone, --个人电话
       t.leave_date, --离职日期
       t.educ_hours, --培训时数
       t.workhour17, --饭补次数
       t.night_sub_count, --夜班津贴次数
       t.workhour21, --旷工
       t.workhour52, --迟到
       t.workhour53, --早退
       t.workhour24, --未刷卡
       t.workhour26, --法定
       t.workhour27, --平时
       t.workhour28, --周末
       t.workhour15, --病假
       t.workhour62, --带薪事假小时
       t.regular_onduty_hours, --转正后实出勤小时数
       t.real_onduty_hours, --全月实出勤小时数
       t.arange_work_hours, --排班总小时数
       t.station_base_salary, --岗位技能津贴底薪
       t.duty_base_salary, --职务技能津贴底薪
       t.leave_type, --离职类型
       t.station_seq, --岗位序列
       t.pay_organ_name, --工资发放单位
       t.belong_organ_name, --工资归属单位
       t.belong_dept_name, --工资归属部门
       t.opening_bank, --开户行
       st.name                         station_text_view, --岗位
       et.name                         employ_type_text_view, --用工性质
       le.name                         leave_sort_text_view, --人员类别
       ba.name                         bank_type_text_view, --银行名称
       es.name                         leave_type_text_view, --离职类型
       po.name                         station_seq_text_view --岗位序列
  from view_hr_pay_master_adjust t,
       v_sa_dictionary           st,
       v_sa_dictionary           et,
       v_sa_dictionary           le,
       v_sa_dictionary           ba,
       v_sa_dictionary           es,
       v_sa_dictionary           po,
       hr_humanarchive h
 where t.STATION = st.value(+)
   and 'station' = st.code(+)
   and t.EMPLOY_TYPE = et.value(+)
   and 'employType' = et.code(+)
   and t.LEAVE_SORT = le.value(+)
   and 'leaveSort' = le.code(+)
   and t.BANK_TYPE = ba.value(+)
   and 'bankType' = ba.code(+)
   and t.LEAVE_TYPE = es.value(+)
   and 'leaveSort' = es.code(+)
   and t.STATION_SEQ = po.value(+)
   and 'positionSequence' = po.code(+)
   and t.archive_id = h.id(+)
   and t.pay_organ_id in (select d.org_unit_id
                            from hr_pay_approve_org_dtl d
                           where d.main_id = '${mainId}')
   and (t.pay_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = '${mainId}'
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code) or
       t.belong_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = '${mainId}'
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code))
   and t.pay_kind = '${payKind}'
   and t.period_id = '${periodId}' 
 ${parameter7} -- 公司id
 ${parameter1} -- 部门id
 ${parameter2} -- 姓名
 ${if(len(belongOrganId)==0,"","and t.belong_organ_id in (select * from table(split('"+belongOrganId+"')))")} --工资归属单位id
 ${parameter4} --工资归属部门id
 ${parameter5} --职等级别 员工
 ${parameter6} --职等级别 中干

select t.id, t.main_id, t.item, t.remark, t.sequence
  from hr_pay_approve_item_remark t
 where t.main_id = '${mainId}'

select t.period_name, --期间
       t.belong_organ_name, --工资归属单位
       t.belong_dept_name, --工资归属部门
       count(*) person_qty, --人数
       sum(t.base_salary) base_salary, --基本工资底薪
       sum(t.base_pay) base_pay, --基本工资
       sum(t.station_skill_pay) station_skill_pay, --岗位技能工资
       sum(t.job_allowance) job_allowance, --职务津贴
       sum(t.station_base_pay) station_base_pay, --岗位技能津贴
       sum(t.competition_compensation) competition_compensation, --竞业补偿
       sum(t.zw_salary) zw_salary, --中威工资
       sum(t.high_temperature_allowance) high_temperature_allowance, --高温津贴
       sum(t.internal_trainer_allowance) internal_trainer_allowance, --内训师津贴
       sum(t.safety_officer_subsidy) safety_officer_subsidy, --安全员津贴
       sum(t.safety_reward) safety_reward, --安全奖励
       sum(t.tqm_bonus) tqm_bonus, --TQM奖金
       sum(t.internal_recommendation_award) internal_recommendation_award, --内部推荐奖励
       sum(t.anniversary_bonus) anniversary_bonus, --周年庆奖金
       sum(t.start_red_envelope) start_red_envelope, --开工红包
       sum(t.shift_differential) shift_differential, --春节值班津贴
       sum(t.new_project_bonus) new_project_bonus, --专项奖金
       sum(t.reduction_incentive_bonus) reduction_incentive_bonus, --降本激励奖金
       sum(t.award) award, --日常奖励
       sum(t.marketing_bonus) sale_award, --销售奖金
       sum(t.performance_bonus) performance_bonus, --月/季度绩效奖金
       sum(t.wage_allowance) wage_allowance, --工资补差
       sum(t.late_shift_allowance) late_shift_allowance, --晚班津贴
       sum(t.overtime) overtime, --加班工资
       sum(t.sick_leave_wage) sick_leave_wage, --病假工资
       sum(t.paid_leave_pay) paid_leave_pay, --带薪事假工资
       sum(t.training_wages) training_wages, --培训工资
       sum(t.meal_allowance) meal_allowance, --餐补
       sum(t.forgotten_card_penalty_a) forgotten_card_penalty, --忘刷卡罚款
       sum(t.absenteeism_penalty_a) absenteeism_penalty, --旷工罚款
       sum(t.late_and_early_penalty_a) late_and_early_penalty, --迟到早退罚款
       sum(t.deduction_a) deduction, --扣餐费
       sum(t.taxable_pay) taxable_pay, --应付工资
       sum(t.pension_personal_benefit_a) pension_personal_benefit, --养老个人保险
       sum(t.unemployment_personal_a) unemployment_personal_insuranc, --失业个人保险
       sum(t.medical_personal_insurance_a) medical_personal_insurance, --医疗个人保险
       sum(t.personal_total_a) personal_total, --公积金个人
       sum(t.receive_pay) receive_pay, --应领工资
       sum(t.prev_taxable_income) prev_taxable_income, --上月累计应缴所得额
       sum(t.special_deduction) special_deduction, --专项扣除所得数
       sum(t.cumulative_taxable_pay) cumulative_taxable_pay, --累计应缴所得额
       sum(t.cumulative_withhold_tax) cumulative_withhold_tax, --累计已扣个税
       sum(t.withholding_tax) withholding_tax, --预扣个税
       sum(t.mutual_aid) mutual_aid, --互助金
       sum(t.union_dues_a) union_dues, --工会会费
       sum(t.daily_punishment) daily_punishment, --日常惩罚
       sum(t.labor_insurance_deduction_a) labor_insurance_deduction, --劳保费用
       sum(t.dormitory_maintenance_fee_a) dormitory_maintenance_fee, --宿舍维修费
       sum(t.ic_card_cost_a) ic_card_cost, --餐卡工本费
       sum(t.foreign_training_fee) foreign_training_fee, --外训费
       sum(t.social_security_fee) social_security_fee, --社保服务费
       sum(t.utility_fee_a) utility_fee, --水电费
       sum(t.other_deduction) other_deduction, --其他扣款
       sum(t.temporary_deduction) temporary_deduction, --暂扣挂账
       sum(t.financial_deduction) financial_deduction, --财务扣款抵账
       sum(t.income_tax) income_tax, --本月累计应扣缴税额
       sum(t.prev_withholding_tax) prev_withholding_tax, --上月个税
       sum(t.cumulative_tax_payable) cumulative_tax_payable, --累计应补（退）税额
       sum(t.compensation_tax_a) compensation_tax, --上月个税补差
       sum(t.after_tax_reissue) after_tax_reissue, --税后补发
       sum(t.net_pay) net_pay, --实发工资
       sum(t.trade_union_member) trade_union_member
  from view_hr_pay_master_adjust t
 where 1 = 1
   and t.pay_organ_id in (select d.org_unit_id
                            from hr_pay_approve_org_dtl d
                           where d.main_id = '${mainId}')
   and (t.pay_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = '${mainId}'
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code) or
       t.belong_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = '${mainId}'
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code))
   and t.pay_kind = '${payKind}'
   and t.period_id = '${periodId}' 
 ${parameter7} -- 公司id
 ${parameter1} -- 部门id
 ${parameter2} -- 姓名
 ${if(len(belongOrganId)==0,"","and t.belong_organ_id in (select * from table(split('"+belongOrganId+"')))")} --工资归属单位id
 ${parameter4} --工资归属部门id
 ${parameter5} --职等级别 员工
 ${parameter6} --职等级别 中干
 group by t.period_id,
          t.period_name,
          t.belong_organ_id,
          t.belong_organ_name,
          t.belong_dept_id,
          t.belong_dept_name

