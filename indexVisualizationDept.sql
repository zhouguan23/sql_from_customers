select t.*
  from (select m.organ_id,
               m.organ_name,
               d.prod_dept_id,
               d.prod_dept_name,
               d.materiel_type_name,
               d.index_item,
               nvl(sum(d.index_value), 0) index_value
          from pp_index_adjust m, pp_index_adjust_dtl d
         where m.id = d.main_id
           and m.operation_code in ('ppIndexAdjust', 'ppIndexCalculate')
           and m.status = '2000'
           and nvl(m.workshop_type, '1') = '1'
           and m.organ_id in
               (select column_value as full_id
                  from table(split('${organId}')))
           and d.prod_dept_id = nvl('${deptId}', d.prod_dept_id)
           and m.line_month >=
               nvl(to_date('${beginDate}', 'yyyy-mm'), m.line_month)
           and m.line_month <=
               nvl(to_date('${endDate}', 'yyyy-mm'), m.line_month)
         group by m.organ_id,
                  m.organ_name,
                  d.prod_dept_id,
                  d.prod_dept_name,
                  d.materiel_type_name,
                  d.index_item) t,
       sa_oporg os,
       sa_oporg ds
 where t.organ_id = os.id
   and t.prod_dept_id = ds.id
 order by os.sequence, ds.sequence

