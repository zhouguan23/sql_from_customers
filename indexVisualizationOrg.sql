select t.*
  from (select m.organ_id,
               m.organ_name,
               nvl(d.materiel_type_name, -1) materiel_type_name,
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
           and m.line_month >=
               nvl(to_date('${beginDate}', 'yyyy-mm'), m.line_month)
           and m.line_month <=
               nvl(to_date('${endDate}', 'yyyy-mm'), m.line_month)
         group by m.organ_id,
                  m.organ_name,
                  d.materiel_type_name,
                  d.index_item) t,
       sa_oporg os
 where t.organ_id = os.id
 order by os.sequence

select m.organ_name,
       nvl(d.materiel_type_name, -1) materiel_type_name,
       nvl(sum(d.line_number), 0) line_number
  from pp_line_number m, pp_line_number_dtl d
 where m.id = d.main_id
   and m.status = '2000'
   and m.organ_id in
       (select column_value as full_id from table(split('${organId}')))
   and m.line_month >=
       nvl(to_date('${beginDate}', 'yyyy-mm'), m.line_month)
   and m.line_month <= nvl(to_date('${endDate}', 'yyyy-mm'), m.line_month)
 group by m.organ_name, d.materiel_type_name

