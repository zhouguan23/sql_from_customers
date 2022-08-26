select decode(nvl(length(b.code), 0) -
              nvl(length(replace(b.code, '-', '')), 0),
              2,
              '  ',
              3,
              '    ',
              '') || b.name dept_view_name,
       decode(t.act_product,
              0,
              null,
              round(t.act_hour * 10000 / t.act_product, 2)) hour_product,
       t.*
  from hr_employee_product t, view_hr_base_org b
 where t.dept_id = b.id
   and t.org_kind = upper('base')
--基地
 ${param4}
--部门
 ${param3}
--年月
 ${param2}
--年份
 ${param1}
 order by b.full_sequence asc

select decode(t.act_product,
              0,
              null,
              round(t.act_hour * 10000 / t.act_product, 2)) hour_product,
       t.*
  from hr_employee_product t, view_hr_base_org b
 where t.org_id = b.id
   and t.org_kind = upper('cell')
--基地
${param3}
--年月
 ${param2}
--年份
 ${param1}
 order by b.full_sequence asc

select decode(t.act_product,
              0,
              null,
              round(t.act_hour * 10000 / t.act_product, 2)) hour_product,
       t.*
  from hr_employee_product t, view_hr_base_org b
 where t.org_id = b.id
   and t.org_kind = upper('MODULE')
--基地
${param3}
--年月
 ${param2}
--年份
 ${param1}
 order by b.full_sequence asc

