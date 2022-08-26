select t.*
  from view_cell_pss_prod t
 where t.materieltype_all_code in ('11.11', '11.12')
   and t.grade_id = '1'
   and t.finance_category not in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)      
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_prod t
 where t.materieltype_all_code = '11.10'
   and t.grade_id = '6'
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_prod t
 where t.materieltype_all_code = '11.10'
   and t.grade_id = '1'
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_prod t
 where t.materieltype_all_code in ('11.11', '11.12')
   and t.grade_id = '6'
   and t.finance_category not in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)      
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select distinct to_char(month, 'yyyy') year, month
  from (select month
          from view_cell_pss_prod
        union
        select month
          from view_cell_pss_out_sal
        union
        select month
          from view_cell_pss_mod_sal
        union
        select month from view_cell_pss_stock)
 where (month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (month <= to_date('${monthEnd}', 'yyyy-mm') or '${monthEnd}' is null)

select t.*
  from view_cell_pss_prod t
 where t.materieltype_all_code = '11.11'
   and t.grade_id = '1'
   and t.finance_category in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)      
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_prod t
 where t.materieltype_all_code = '11.11'
   and t.grade_id = '6'
   and t.finance_category in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)      
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_out_sal t
 where t.materieltype_all_code = '11.10'
   and t.grade_id = '1'
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_out_sal t
 where t.materieltype_all_code = '11.10'
   and t.grade_id = '6'
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_out_sal t
 where t.materieltype_all_code in ('11.11', '11.12')
   and t.grade_id = '1'
   and t.finance_category not in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_out_sal t
 where t.materieltype_all_code in ('11.11', '11.12')
   and t.grade_id = '6'
   and t.finance_category not in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_out_sal t
 where t.materieltype_all_code = '11.11'
   and t.grade_id = '1'
   and t.finance_category in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_out_sal t
 where t.materieltype_all_code = '11.11'
   and t.grade_id = '6'
   and t.finance_category in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_mod_sal t
 where t.materieltype_all_code = '11.10'
   and t.grade_id = '1'
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_mod_sal t
 where t.materieltype_all_code = '11.10'
   and t.grade_id = '6'
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_mod_sal t
 where t.materieltype_all_code in ('11.11', '11.12')
   and t.grade_id = '1'
   and t.finance_category not in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_mod_sal t
 where t.materieltype_all_code in ('11.11', '11.12')
   and t.grade_id = '6'
   and t.finance_category not in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_mod_sal t
 where t.materieltype_all_code = '11.11'
   and t.grade_id = '1'
   and t.finance_category in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_mod_sal t
 where t.materieltype_all_code = '11.11'
   and t.grade_id = '6'
   and t.finance_category in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_stock t
 where t.materieltype_all_code = '11.10'
   and t.grade_id = '1'
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_stock t
 where t.materieltype_all_code = '11.10'
   and t.grade_id = '6'
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_stock t
 where t.materieltype_all_code in ('11.11', '11.12')
   and t.grade_id = '1'
   and t.finance_category not in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_stock t
 where t.materieltype_all_code in ('11.11', '11.12')
   and t.grade_id = '6'
   and t.finance_category not in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_stock t
 where t.materieltype_all_code = '11.11'
   and t.grade_id = '1'
   and t.finance_category in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

select t.*
  from view_cell_pss_stock t
 where t.materieltype_all_code = '11.11'
   and t.grade_id = '6'
   and t.finance_category in ('14', '15', '16')
   and (t.month >= to_date('${monthBegin}', 'yyyy-mm') or
       '${monthBegin}' is null)
   and (t.month <= to_date('${monthEnd}', 'yyyy-mm') or
       '${monthEnd}' is null)

