select ts.*, sum(watt) over(partition by ts.salesman) as s_watt
  from (select month,
               property_value dept_type,
               employeestatus,
               business_group_name,
               salesman,
               grade,
               round(sum(watt) / 1000000, 2) watt
          from (select to_char(m.fillin_date, 'mm') month,
                       h.dept_id,
                       h.employeestatus,
                       h.business_group_name,
                       h.name || '(' || h.employeeno || ')' salesman,
                       decode(d.grade_id, '1', '1', '2') grade,
                       d.watt
                  from st_cell_out m,
                       st_cell_out_dtl d,
                       (select od.bill_code con_code,
                               ot.salesman_id,
                               ot.salesman,
                               '0' b_type
                          from sal_cell_delivery_notice od, sal_cell_order ot
                         where od.source_id = ot.id
                        union all
                        select od.bill_code con_code,
                               ot.salesman_id,
                               ot.salesman_name salesman,
                               '1' b_type
                          from sal_cell_delivery_notice od, sal_cell_sample ot
                         where od.source_id = ot.id
                        union all
                        select od.bill_code con_code,
                               ot.salesman_id,
                               ot.salesman_name salesman,
                               '0' b_type
                          from sal_cell_delivery_notice od,
                               sal_cell_return_exchange ot
                         where od.source_id = ot.id
                        union all
                        select id con_code,
                               salesman_id,
                               salesman_name salesman,
                               '0' b_type
                          from sal_cell_return_exchange
                        union all
                        select to_char(mono_id) con_code,
                               salesman_id,
                               salesman_name salesman,
                               '0' b_type
                          from sal_cell_return_exchange) o,
                       hr_humanarchive h
                 where m.id = d.main_id
                   and nvl(m.consignment_note, m.source_id) = o.con_code
                   and o.salesman_id = h.person_id
                   and (nvl(d.oc_price, 0) <> 0 or o.b_type = '0')
                   and nvl(m.out_type, 0) != 3
                   and m.organ_id in
                       (select column_value as full_id
                          from table(split('${organId}')))
                   and m.fillin_date between
                       trunc(to_date('${year}', 'yyyy'), 'y') and
                       add_months(trunc(to_date('${year}', 'yyyy'), 'y'), 12)
                union all
                select to_char(m.fillin_date, 'mm') month,
                       h.dept_id,
                       h.employeestatus,
                       h.business_group_name,
                       h.name || '(' || h.employeeno || ')' salesman,
                       nvl(d.grade_id, 0) grade,
                       d.watt
                  from st_module_out m,
                       st_module_out_dtl d,
                       (select od.bill_code     con_code,
                               ot.salesman_id,
                               ot.salesman_name salesman
                          from sal_module_delivery_notice od,
                               sal_module_order           ot
                         where od.source_id = ot.id
                        union all
                        select od.bill_code  con_code,
                               ot.saler_id   salesman_id,
                               ot.saler_name salesman
                          from sal_module_delivery_notice od, st_sal_sample ot
                         where od.source_id = ot.id
                        union all
                        select od.bill_code con_code,
                               ot.salesman_id,
                               ot.salesman
                          from sal_module_delivery_notice od,
                               sal_module_return_apply    ot
                         where od.source_id = ot.id
                        union all
                        select id con_code, rt.salesman_id, rt.salesman
                          from sal_module_return_apply rt
                        union all
                        select to_char(mono_id) con_code,
                               rt.salesman_id,
                               rt.salesman
                          from sal_module_return_apply rt) o,
                       hr_humanarchive h
                 where m.id = d.main_id
                   and nvl(m.consignment_note, m.source_id) = o.con_code
                   and o.salesman_id = h.person_id
                   and m.organ_id in
                       (select column_value as full_id
                          from table(split('${organId}')))
                   and m.fillin_date between
                       trunc(to_date('${year}', 'yyyy'), 'y') and
                       add_months(trunc(to_date('${year}', 'yyyy'), 'y'), 12)) t,
               (select id,
                       decode(property_value, '6', '6', '9') property_value
                  from v_sa_oporgproperty
                 where property_name = 'deptAdminKind'
                   and property_value = '6') v
         where t.dept_id = v.id(+)
         group by month,
                  property_value,
                  employeestatus,
                  business_group_name,
                  salesman,
                  grade) ts

