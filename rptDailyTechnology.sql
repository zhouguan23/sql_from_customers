select *
  from (select m.full_id,
               m.person_member_id,
               m.prod_dept_name,
               m.prod_date,
               d.*,
               s.long_name
          from tm_gears m, tm_gears_dtl d, sa_oporg s
         where m.id = d.main_id
           and m.organ_id = s.id
           and m.status = 2000
           and m.organ_id = '${organId}'
           and (m.prod_dept_id = '${prodDeptId}' or '${prodDeptId}' is null)
           and (m.prod_date >= to_date('${prodDateBegin}', 'yyyy-mm-dd') or
               '${prodDateBegin}' is null)
           and (m.prod_date <= to_date('${prodDateEnd}', 'yyyy-mm-dd') or
               '${prodDateEnd}' is null)
         order by s.long_name,
                  m.prod_date desc,
                  m.prod_dept_name,
                  d.shift,
                  d.model_name,
                  d.lot) t
 where 1 = 1 ${authority}

select *
  from (select m.full_id,
               m.person_member_id,
               m.prod_dept_name,
               m.prod_date,
               d.*,
               s.long_name
          from tm_gears m, tm_gears_dtl d, sa_oporg s
         where m.id = d.main_id
           and m.organ_id = s.id
           and m.status = 2000
           and m.organ_id = '${organId}'
           and (m.prod_dept_id = '${prodDeptId}' or '${prodDeptId}' is null)
           and (m.prod_date >= to_date('${prodDateBegin}', 'yyyy-mm-dd') or
               '${prodDateBegin}' is null)
           and (m.prod_date <= to_date('${prodDateEnd}', 'yyyy-mm-dd') or
               '${prodDateEnd}' is null)
           and long_name = '${long_name}'
           and prod_dept_name = '${prod_dept_name}'
           and m.prod_date = to_date('${prod_date}', 'yyyy-mm-dd')
           and shift = '${shift}'
           and model_name = '${model_name}'
           and lot = '${lot}'
         order by s.long_name,
                  m.prod_date desc,
                  m.prod_dept_name,
                  d.shift,
                  d.model_name,
                  d.lot) t
 where 1 = 1 ${authority}

