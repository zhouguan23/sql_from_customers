select m.annual_bonus_frequency,
       m.annual_bonus_year,
       d1.name                  station_text_view,
       d2.name                  employ_type_text_view,
       d3.name                  leave_sort_text_view,
       t.*,
       decode(t.annual_attendance_rate,
              null,
              null,
              round(t.annual_attendance_rate, 2) || '%') annual_attendance_rate_p
  from hr_pay_master   t,
       hr_pay_main     m,
       sa_oporg        h,
       v_sa_dictionary d1,
       v_sa_dictionary d2,
       v_sa_dictionary d3
 where t.main_id = m.id
   and t.belong_dept_id = h.id
   and t.station = d1.value
   and d1.code = 'station'
   and t.employ_type = d2.value
   and d2.code = 'employType'
   and t.leave_sort = d3.value
   and d3.code = 'leaveSort'
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
 order by t.employeeno asc, m.annual_bonus_frequency asc

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
       t.employeeno,
       sum(t.year_total_bonus_paid) year_total_bonus_paid,
       sum(t.actual_release_this_month) actual_release_this_month
  from hr_pay_master t, hr_pay_main m
 where t.main_id = m.id
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
 group by m.annual_bonus_frequency, m.annual_bonus_year, t.employeeno
 order by t.employeeno asc, m.annual_bonus_frequency asc

