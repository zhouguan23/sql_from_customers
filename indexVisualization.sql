select d.grade_id, nvl(sum(d.qty), 0) qty, nvl(sum(d.watt), 0) watt
  from st_cell_in m, st_cell_in_dtl d, st_storage s, st_operation_type o
 where m.id = d.main_id
   and d.storage_id = s.id
   and m.operation_type_id = o.id
   and s.storage_type != '4'
   and o.business_code = '3' --生产入库
   and m.organ_id = '${organId}'
   and (m.dept_name like '%${deptName}%' or '${deptName}' is null)
   and (m.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (m.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)
 group by d.grade_id

select d.grade_id, nvl(sum(d.qty), 0) qty, nvl(sum(d.watt), 0) watt
  from st_cell_out m, st_cell_out_dtl d, st_storage s, st_operation_type o
 where m.id = d.main_id
   and d.storage_id = s.id
   and m.operation_type_id = o.id
   and s.storage_type != '4'
   and o.business_code = '30' --生产出库
   and m.organ_id = '${organId}'
   and (m.use_dept_name like '%${deptName}%' or '${deptName}' is null)
   and (m.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (m.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)
 group by d.grade_id

select nvl(sum(d.qty), 0) qty
  from st_cell_out m, st_cell_out_dtl d, st_storage s, st_operation_type o
 where m.id = d.main_id
   and d.storage_id = s.id
   and m.operation_type_id = o.id
   and s.storage_type = '4'
   and o.business_code = '30' --生产出库
   and m.organ_id = '${organId}'
   and (m.use_dept_name like '%${deptName}%' or '${deptName}' is null)
   and (m.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (m.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(d.qty), 0) qty
  from st_cell_in m, st_cell_in_dtl d, st_storage s, st_operation_type o
 where m.id = d.main_id
   and d.storage_id = s.id
   and m.operation_type_id = o.id
   and s.storage_type = '4'
   and o.business_code = '3' --生产入库
   and m.organ_id = '${organId}'
   and (m.dept_name like '%${deptName}%' or '${deptName}' is null)
   and (m.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (m.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select t.value from sa_parameter t where t.code = 'cellArea'

select c.all_code, nvl(sum(d.qty), 0) qty
  from st_mate_out           m,
       st_mate_out_dtl       d,
       st_operation_type     o,
       com_materiel_info_dtl dt,
       com_materiel_info     mt,
       com_materieltype      c,
       com_fnorg             f
 where m.id = d.main_id
   and m.operation_type_id = o.id
   and o.business_code in ('11', '33') --业务类型：生产、办公领料，实验物料出库
   and d.materiel_id = dt.id
   and dt.main_id = mt.id
   and mt.materieltype_id = c.id
   and d.fn_use_dept_id = f.id
   and f.ismfc = 1
   and (c.all_code like '12%' or c.all_code like '13%')
   and m.organ_id = '${organId}'
   and (m.use_dept_name like '%${deptName}%' or '${deptName}' is null)
   and (m.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (m.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)
 group by c.all_code

select nvl(sum(d.qty), 0) qty
  from st_cell_out m, st_cell_out_dtl d, st_operation_type o
 where m.id = d.main_id
   and m.operation_type_id = o.id
   and o.business_code in ('9', '31', '58', '13', '18', '32')
   and d.grade_id = '1'
   and m.organ_id = '${organId}'
   and (m.use_dept_name like '%${deptName}%' or '${deptName}' is null)
   and (m.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (m.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(d.qty), 0) qty
  from st_cell_in m, st_cell_in_dtl d, st_operation_type o
 where m.id = d.main_id
   and m.operation_type_id = o.id
   and o.business_code in ('9', '31', '58', '13', '18', '32')
   and d.grade_id = '1'
   and m.organ_id = '${organId}'
   and (m.dept_name like '%${deptName}%' or '${deptName}' is null)
   and (m.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (m.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select sum(t.end_amount) end_amount
  from fn_st_in_out_end      t,
       com_materiel_info_dtl dt,
       com_materiel_info     mt,
       com_materieltype      c
 where t.materiel_id = dt.id
   and dt.main_id = mt.id
   and mt.materieltype_id = c.id
   and c.all_code like '14%'
   and t.organ_id = '${organId}'
   and t.yearmonth = '${left(endDate,7)}'

select t.line_number
  from pp_line_number t
 where t.status = 2000
   and t.organ_id = '${organId}'
   and t.line_month = to_date('${endDate}', 'yyyy-mm')

select sum(t.start_amount) start_amount,
       sum(t.end_amount) end_amount,
       sum(t.out_amount) out_amount
  from fn_st_in_out_end      t,
       com_materiel_info_dtl dt,
       com_materiel_info     mt,
       com_materieltype      c
 where t.materiel_id = dt.id
   and dt.main_id = mt.id
   and mt.materieltype_id = c.id
   and (c.all_code like '12.10%' or c.all_code like '12.11%' or
       c.all_code like '12.12%' or c.all_code like '13.10%' or
       c.all_code like '13.11.10%')
   and t.organ_id = '${organId}'
   and t.yearmonth = '${left(endDate,7)}'

select sum(t.end_amount) end_amount
  from fn_st_in_out_end      t,
       com_materiel_info_dtl dt,
       com_materiel_info     mt,
       com_materieltype      c
 where t.materiel_id = dt.id
   and dt.main_id = mt.id
   and mt.materieltype_id = c.id
   and (c.all_code like '12.10%' or c.all_code like '12.11%' or
       c.all_code like '12.12%')
   and t.organ_id = '${organId}'
   and t.yearmonth = '${left(endDate,7)}'

select nvl(sum(d.receive_qty), 0) receive_qty, nvl(sum(d.qty), 0) qty
  from st_mate_in            t,
       st_mate_in_dtl        d,
       st_storage            s,
       com_materiel_info_dtl dt,
       com_materiel_info     mt,
       com_materieltype      c
 where t.id = d.main_id
   and t.storage_id = s.id
   and d.materiel_id = dt.id
   and dt.main_id = mt.id
   and mt.materieltype_id = c.id
   and (c.all_code like '12.10%' or c.all_code like '12.11%' or
       c.all_code like '12.12%')
   and t.operation_code = 'buyMateIn'
   and s.storage_attr = '1'
   and t.organ_id = '${organId}'
   and (t.fillin_date >= to_date('${endDate}', 'yyyy-mm'))
   and (t.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1))

select c.all_code, nvl(sum(d.qty), 0) qty
  from st_mate_out           m,
       st_mate_out_dtl       d,
       st_operation_type     o,
       com_materiel_info_dtl dt,
       com_materiel_info     mt,
       com_materieltype      c,
       com_fnorg             f,
       st_storage            s
 where m.id = d.main_id
   and m.operation_type_id = o.id
   and o.business_code in ('11', '33') --业务类型：生产、办公领料，实验物料出库
   and d.materiel_id = dt.id
   and dt.main_id = mt.id
   and mt.materieltype_id = c.id
   and d.fn_use_dept_id = f.id
   and d.storage_id = s.id
   and s.storage_attr = '1'
   and f.ismfc = 1
   and (c.all_code like '12%' or c.all_code like '13%')
   and m.organ_id = '${organId}'
   and (m.use_dept_name like '%${deptName}%' or '${deptName}' is null)
   and (m.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (m.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)
 group by c.all_code

select nvl(sum(oc_sales_amount),0) oc_sales_amount
  from st_mate_out           m,
       st_mate_out_dtl       d,
       com_materiel_info_dtl dt,
       com_materiel_info     mt,
       com_materieltype      c
 where m.id = d.main_id
   and d.materiel_id = dt.id
   and dt.main_id = mt.id
   and mt.materieltype_id = c.id
   and (c.all_code like '12.10%' or c.all_code like '12.11%' or
       c.all_code like '12.12%' or c.all_code like '13.10%' or
       c.all_code like '13.11.10%')
   and m.operation_code = 'materielSaleOut'
   and m.organ_id = '${organId}'
   and (m.fillin_date >= to_date('${endDate}', 'yyyy-mm') or
       '${endDate}' is null)
   and (m.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

