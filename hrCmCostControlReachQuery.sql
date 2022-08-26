select t.*,
       (t.salary_num - t.quota_num) as excess_num, --超额情况
       (t.fixed_salary - t.fixed_amount) as excess_fixed_salary,
       (t.allowance_salary - t.allowance_amount) as excess_allowance_salary,
       (t.bonus_salary - t.bonus_amount) as excess_bonus_salary,
       (t.attendance_salary - t.work_amount) as excess_attendance_salary,
       (t.pay_salary - t.pay_amount) as excess_pay_salary
  from (select t.*,
               (t.fixed_salary + t.allowance_salary + t.bonus_salary +
               t.attendance_salary) as pay_salary
          from (select h.id,
                       h.ogn_id,
                       h.ogn_name,
                       h.ogn_dept_id,
                       h.ogn_dept_name,
                       h.year,
                       h.period_date,
                       h.quota_num, --编制人数
                       nvl(h.fixed_amount, 0) fixed_amount,
                       nvl(h.allowance_amount, 0) allowance_amount,
                       nvl(h.bonus_amount, 0) bonus_amount,
                       nvl(h.work_amount, 0) work_amount,
                       nvl(h.pay_amount, 0) pay_amount,
                       count(p.dept_id) as salary_num, --计薪人数
                       sum(nvl(p.station_salary, 0) +
                           nvl(p.duty_base_salary, 0)) as fixed_salary, --固定薪酬
                       sum(nvl(p.station_base_pay, 0) +
                           nvl(p.high_temperature_allowance, 0) +
                           nvl(p.shift_differential, 0)) as allowance_salary, --津贴
                       sum(nvl(p.new_project_bonus, 0) +
                           nvl(p.reduction_incentive_bonus, 0) +
                           nvl(p.performance_bonus, 0) +
                           nvl(p.marketing_bonus, 0) +
                           nvl(p.bidding_bonus, 0)) as bonus_salary, --奖金
                       sum(nvl(p.overtime, 0) + p.late_shift_allowance +
                           nvl(p.meal_allowance, 0) +
                           nvl(p.training_wages, 0) +
                           nvl(p.paid_leave_pay, 0) +
                           nvl(p.sick_leave_wage, 0)) as attendance_salary --出勤工资
                  from hr_cm_standard_bk h,
                       view_hr_base_org v1,
                       (select v2.*, v3.begin_date
                          from view_hr_pay_master_close v2,
                               view_hr_operation_period v3
                         where v2.period_id = v3.id
                           and v2.pay_kind = 'salary'
                           and v3.pay_kind = 'salary'
                           and v3.begin_date =
                               to_date('${periodDate}', 'yyyy-mm')) p
                 where h.ogn_dept_id = v1.id
                   and v1.org_id = p.dept_id
                   and h.period_date = to_date('${periodDate}', 'yyyy-mm')
                 group by h.id,
                          h.ogn_id,
                          h.ogn_name,
                          h.ogn_dept_id,
                          h.ogn_dept_name,
                          h.year,
                          h.period_date,
                          h.quota_num, --编制人数
                          h.fixed_amount,
                          h.allowance_amount,
                          h.bonus_amount,
                          h.work_amount,
                          h.pay_amount) t
         where 1 = 1) t
 where 1 = 1
 and t.ogn_id in nvl('${ognId}',t.ogn_id)


