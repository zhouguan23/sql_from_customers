select m.annual_bonus_frequency,
       m.annual_bonus_year,
       d1.name station_text_view,
       d2.name employ_type_text_view,
       d3.name leave_sort_text_view,
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
       v_sa_dictionary d3,
       hr_pay_approve  a
 where t.main_id = m.id
   and t.belong_dept_id = h.id
   and t.station = d1.value
   and d1.code = 'station'
   and t.employ_type = d2.value
   and d2.code = 'employType'
   and t.leave_sort = d3.value
   and d3.code = 'leaveSort'
   and m.annual_bonus_year = a.belong_year
   and t.pay_kind = a.pay_kind
   and t.period_id = a.period_id
   and a.id = '${mainId}'
   and t.duty in
       (select d.duty from hr_pay_approve_duty d where d.main_id = a.id)
   and t.pay_organ_id in (select d.org_unit_id
                            from hr_pay_approve_org_dtl d
                           where d.main_id = a.id)
   and (t.pay_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = a.id
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code) or
       t.belong_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = a.id
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code))
--员工组织
${if(len(dtlFullId) == 0, "", "and t.full_id like '" + dtlFullId + "%'") }
--工资归属组织id
${if(len(belongFullId) == 0, "", "and h.full_id like '" + belongFullId + "%'") }
--姓名
${if(len(archiveName) == 0, "", "and t.archive_name like '%" + archiveName + "%'") }
--工号
${if(len(employeeno) == 0, "", "and t.employeeno like '%" + employeeno + "%'") }
 order by t.employeeno asc, m.annual_bonus_frequency asc

select '第' || m.annual_bonus_frequency || '次发放' bonus_frequency,
       m.annual_bonus_frequency
  from hr_pay_master t, hr_pay_main m, sa_oporg h, hr_pay_approve a
 where t.main_id = m.id
   and t.belong_dept_id = h.id
   and m.annual_bonus_year = a.belong_year
   and t.pay_kind = a.pay_kind
      --and t.period_id = a.period_id
   and a.id = '${mainId}'
   and t.duty in
       (select d.duty from hr_pay_approve_duty d where d.main_id = a.id)
   and t.pay_organ_id in (select d.org_unit_id
                            from hr_pay_approve_org_dtl d
                           where d.main_id = a.id)
   and (t.pay_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = a.id
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code) or
       t.belong_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = a.id
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code))
--员工组织
${if(len(dtlFullId) == 0, "", "and t.full_id like '" + dtlFullId + "%'") }
--工资归属组织id
${if(len(belongFullId) == 0, "", "and h.full_id like '" + belongFullId + "%'") }
--姓名
${if(len(archiveName) == 0, "", "and t.archive_name like '%" + archiveName + "%'") }
--工号
${if(len(employeeno) == 0, "", "and t.employeeno like '%" + employeeno + "%'") }
 group by m.annual_bonus_frequency
 order by m.annual_bonus_frequency asc

select m.annual_bonus_frequency,
       m.annual_bonus_year,
       t.employeeno,
       sum(t.year_total_bonus_paid) year_total_bonus_paid,
       sum(t.actual_release_this_month) actual_release_this_month
  from hr_pay_master   t,
       hr_pay_main     m,
       sa_oporg        h,
       hr_pay_approve  a
 where t.main_id = m.id
   and t.belong_dept_id = h.id
   and m.annual_bonus_year = a.belong_year
   and t.pay_kind = a.pay_kind
   --and t.period_id = a.period_id
   and a.id = '${mainId}'
   and t.duty in
       (select d.duty from hr_pay_approve_duty d where d.main_id = a.id)
   and t.pay_organ_id in (select d.org_unit_id
                            from hr_pay_approve_org_dtl d
                           where d.main_id = a.id)
   and (t.pay_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = a.id
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code) or
       t.belong_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = a.id
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code))
--员工组织
${if(len(dtlFullId) == 0, "", "and t.full_id like '" + dtlFullId + "%'") }
--工资归属组织id
${if(len(belongFullId) == 0, "", "and h.full_id like '" + belongFullId + "%'") }
--姓名
${if(len(archiveName) == 0, "", "and t.archive_name like '%" + archiveName + "%'") }
--工号
${if(len(employeeno) == 0, "", "and t.employeeno like '%" + employeeno + "%'") }
 group by m.annual_bonus_frequency, m.annual_bonus_year, t.employeeno
 order by t.employeeno asc, m.annual_bonus_frequency asc

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
  from hr_pay_master   t,
       hr_pay_main     m,
       sa_oporg        h,
       hr_pay_approve  a
 where t.main_id = m.id
   and t.belong_dept_id = h.id
   and m.annual_bonus_year = a.belong_year
   and t.pay_kind = a.pay_kind
   and t.period_id = a.period_id
   and a.id = '${mainId}'
   and t.duty in
       (select d.duty from hr_pay_approve_duty d where d.main_id = a.id)
   and t.pay_organ_id in (select d.org_unit_id
                            from hr_pay_approve_org_dtl d
                           where d.main_id = a.id)
   and (t.pay_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = a.id
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code) or
       t.belong_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = a.id
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code))
--员工组织
${if(len(dtlFullId) == 0, "", "and t.full_id like '" + dtlFullId + "%'") }
--工资归属组织id
${if(len(belongFullId) == 0, "", "and h.full_id like '" + belongFullId + "%'") }
--姓名
${if(len(archiveName) == 0, "", "and t.archive_name like '%" + archiveName + "%'") }
--工号
${if(len(employeeno) == 0, "", "and t.employeeno like '%" + employeeno + "%'") }
 group by m.annual_bonus_year,
          t.belong_organ_id,
          t.belong_organ_name,
          t.belong_dept_id,
          t.belong_dept_name,
          h.full_sequence
 order by h.full_sequence asc

select m.annual_bonus_frequency,
       m.annual_bonus_year,
       t.belong_dept_id,
       h.full_sequence,
       sum(t.year_total_bonus_paid) year_total_bonus_paid,
       sum(t.actual_release_this_month) actual_release_this_month
  from hr_pay_master   t,
       hr_pay_main     m,
       sa_oporg        h,
       hr_pay_approve  a
 where t.main_id = m.id
   and t.belong_dept_id = h.id
   and m.annual_bonus_year = a.belong_year
   and t.pay_kind = a.pay_kind
   --and t.period_id = a.period_id
   and a.id = '${mainId}'
   and t.duty in
       (select d.duty from hr_pay_approve_duty d where d.main_id = a.id)
   and t.pay_organ_id in (select d.org_unit_id
                            from hr_pay_approve_org_dtl d
                           where d.main_id = a.id)
   and (t.pay_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = a.id
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code) or
       t.belong_organ_id in
       (select d.org_unit_id
           from hr_pay_approve_org_dtl d, sa_oporg o, sa_oporg p
          where d.main_id = a.id
            and d.org_unit_id = o.id
            and o.org_kind_id = 'ogn'
            and o.parent_id = p.id
            and p.code = solar_hr.f_get_def_org_root_code))
--员工组织
${if(len(dtlFullId) == 0, "", "and t.full_id like '" + dtlFullId + "%'") }
--工资归属组织id
${if(len(belongFullId) == 0, "", "and h.full_id like '" + belongFullId + "%'") }
--姓名
${if(len(archiveName) == 0, "", "and t.archive_name like '%" + archiveName + "%'") }
--工号
${if(len(employeeno) == 0, "", "and t.employeeno like '%" + employeeno + "%'") }
 group by m.annual_bonus_frequency,
          m.annual_bonus_year,
          t.belong_dept_id,
          h.full_sequence
 order by h.full_sequence asc, m.annual_bonus_frequency asc

