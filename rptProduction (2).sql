select t.*
  from rpt_production t
 where t.status = 2000
   and t.organ_id = '${organId}'
   and (t.prod_dept_id = '${prodDeptId}' or '${prodDeptId}' is null)
   and (t.prod_date >= to_date('${prodDateBegin}', 'yyyy-mm-dd') or
       '${prodDateBegin}' is null)
   and (t.prod_date <= to_date('${prodDateEnd}', 'yyyy-mm-dd') or
       '${prodDateEnd}' is null)
   ${authority}
 order by t.prod_date desc, t.prod_dept_name

