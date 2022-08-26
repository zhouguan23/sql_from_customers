select m.annual_bonus_year,
       t.belong_organ_id,
       t.belong_organ_name,
       t.belong_dept_id,
       t.belong_dept_name,
       h.full_sequence,
       count(*) person_qty,
       sum(t.year_bonus_base) year_bonus_base,
       sum(t.year_bonus_payable) year_bonus_payable,
       sum(t.chairman_special_award) chairman_special_award,
       sum(t.year_other_bonuses) year_other_bonuses,
       sum(t.year_bonus_payable_total) year_bonus_payable_total,
       sum(t.year_award_advance) year_award_advance,
       sum(t.year_income_tax) year_income_tax,
       sum(t.leave_office_withhold) leave_office_withhold,
       sum(t.year_bonus_payable_after_tax) year_bonus_payable_after_tax,
       sum(t.year_temporary_deduction) year_temporary_deduction,
       sum(t.actual_release_this_month) actual_release_this_month,
       sum(t.year_remaining_bonus) year_remaining_bonus,
       sum(t.year_total_bonus_paid) year_total_bonus_paid
  from hr_pay_master t, hr_pay_main m, sa_oporg h
 where t.main_id = m.id
   and t.belong_dept_id = h.id
--奖金归属年份
${if(len(bonusYear) == 0, "", "and m.annual_bonus_year = '" + bonusYear + "'") }
--期间
${if(len(periodId) == 0, "", "and t.period_id = '" + periodId + "'") }
--员工组织
${if(len(fullId) == 0, "", "and t.full_id like '" + fullId + "%'") }
--姓名
${if(len(archiveName) == 0, "", "and t.archive_name like '%" + archiveName + "%'") }
--工资发放单位
${if(len(payOrganId) == 0, "", "and t.pay_organ_id = '" + payOrganId + "'") }
--期间类型
${if(len(payKind) == 0, "", "and t.pay_kind = '" + payKind + "'") }
--工号
${if(len(employeeno) == 0, "", "and t.employeeno like '%" + employeeno + "%'") }
--工资归属单位id
${if(len(belongOrganId) == 0, "", "and t.belong_organ_id in (select column_value from table(split('" + belongOrganId + "')))") }
--工资归属部门id
${if(len(belongDeptId) == 0, "", "and t.belong_dept_id = '" + belongDeptId + "'") }
 group by m.annual_bonus_year,
          t.belong_organ_id,
          t.belong_organ_name,
          t.belong_dept_id,
          t.belong_dept_name,
          h.full_sequence
 order by h.full_sequence asc

select '第' || m.annual_bonus_frequency || '次发放' bonus_frequency,m.annual_bonus_frequency
  from hr_pay_master t, hr_pay_main m
 where t.main_id = m.id
   and m.annual_bonus_frequency is not null
--奖金归属年份
${if(len(bonusYear) == 0, "", "and m.annual_bonus_year = '" + bonusYear + "'") }
--期间
${if(len(periodId) == 0, "", "and t.period_id = '" + periodId + "'") }
--员工组织
${if(len(fullId) == 0, "", "and t.full_id like '" + fullId + "%'") }
--姓名
${if(len(archiveName) == 0, "", "and t.archive_name like '%" + archiveName + "%'") }
--工资发放单位
${if(len(payOrganId) == 0, "", "and t.pay_organ_id = '" + payOrganId + "'") }
--期间类型
${if(len(payKind) == 0, "", "and t.pay_kind = '" + payKind + "'") }
--工号
${if(len(employeeno) == 0, "", "and t.employeeno like '%" + employeeno + "%'") }
--工资归属单位id
${if(len(belongOrganId) == 0, "", "and t.belong_organ_id in select column_value from table(split('" + belongOrganId + "'))") }
--工资归属部门id
${if(len(belongDeptId) == 0, "", "and t.belong_dept_id = '" + belongDeptId + "'") }
 group by m.annual_bonus_frequency
 order by m.annual_bonus_frequency asc

select m.annual_bonus_frequency,
       m.annual_bonus_year,
       t.belong_dept_id,
       h.full_sequence,
       sum(t.year_total_bonus_paid) year_total_bonus_paid,
       sum(t.actual_release_this_month) actual_release_this_month
  from hr_pay_master t, hr_pay_main m, sa_oporg h
 where t.main_id = m.id
   and t.belong_dept_id = h.id
   and m.annual_bonus_frequency is not null
--奖金归属年份
${if(len(bonusYear) == 0, "", "and m.annual_bonus_year = '" + bonusYear + "'") }
--期间
${if(len(periodId) == 0, "", "and t.period_id = '" + periodId + "'") }
--员工组织
${if(len(fullId) == 0, "", "and t.full_id like '" + fullId + "%'") }
--姓名
${if(len(archiveName) == 0, "", "and t.archive_name like '%" + archiveName + "%'") }
--工资发放单位
${if(len(payOrganId) == 0, "", "and t.pay_organ_id = '" + payOrganId + "'") }
--期间类型
${if(len(payKind) == 0, "", "and t.pay_kind = '" + payKind + "'") }
--工号
${if(len(employeeno) == 0, "", "and t.employeeno like '%" + employeeno + "%'") }
--工资归属单位id
${if(len(belongOrganId) == 0, "", "and t.belong_organ_id in (select column_value from table(split('" + belongOrganId + "')))") }
--工资归属部门id
${if(len(belongDeptId) == 0, "", "and t.belong_dept_id = '" + belongDeptId + "'") }
 group by m.annual_bonus_frequency,
          m.annual_bonus_year,
          t.belong_dept_id,
          h.full_sequence
 order by h.full_sequence asc, m.annual_bonus_frequency asc

