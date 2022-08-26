select t.prod_date,
       t.prod_dept_name,
       d.*
  from rpt_storage_in t, rpt_storage_in_dtl d
 where t.id = d.main_id
   and t.status = 2000
   and t.organ_id = '${organId}'
   and (t.prod_dept_id = '${prodDeptId}' or '${prodDeptId}' is null)
   and (t.prod_date >= to_date('${prodDateBegin}', 'yyyy-mm-dd') or
       '${prodDateBegin}' is null)
   and (t.prod_date <= to_date('${prodDateEnd}', 'yyyy-mm-dd') or
       '${prodDateEnd}' is null)
   and (d.model_name like '%${modelName}%' or '${modelName}' is null)
   ${authority}
 order by t.prod_date desc, t.prod_dept_name, d.model_name

