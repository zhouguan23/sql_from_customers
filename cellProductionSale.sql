select d.tyear,
       max(case substr(d.tmonth, -2)
             when '01' then
              d.watt
           end) as month_01,
       max(case substr(d.tmonth, -2)
             when '02' then
              d.watt
           end) as month_02,
       max(case substr(d.tmonth, -2)
             when '03' then
              d.watt
           end) as month_03,
       max(case substr(d.tmonth, -2)
             when '04' then
              d.watt
           end) as month_04,
       max(case substr(d.tmonth, -2)
             when '05' then
              d.watt
           end) as month_05,
       max(case substr(d.tmonth, -2)
             when '06' then
              d.watt
           end) as month_06,
       max(case substr(d.tmonth, -2)
             when '07' then
              d.watt
           end) as month_07,
       max(case substr(d.tmonth, -2)
             when '08' then
              d.watt
           end) as month_08,
       max(case substr(d.tmonth, -2)
             when '09' then
              d.watt
           end) as month_09,
       max(case substr(d.tmonth, -2)
             when '10' then
              d.watt
           end) as month_10,
       max(case substr(d.tmonth, -2)
             when '11' then
              d.watt
           end) as month_11,
       max(case substr(d.tmonth, -2)
             when '12' then
              d.watt
           end) as month_12
  from (select to_char(t.fillin_date, 'yyyy') as tyear,
               to_char(t.fillin_date, 'yyyy-mm') as tmonth,
               sum(d.watt) watt
          from st_cell_out                t,
               st_cell_out_dtl            d,
               sa_oporgproperty           b,
               sa_oporgpropertydefinition a
         where t.id = d.main_id
           and t.operation_code = 'consumeOutDtl'
           and a.id = b.property_definition_id
           and a.name = 'workshopType'
           and b.property_value = '2'
           and t.use_dept_id = b.org_id
         group by to_char(t.fillin_date, 'yyyy'),
                  to_char(t.fillin_date, 'yyyy-mm')) d
 group by d.tyear

select d.tyear,
       max(case substr(d.tmonth, -2)
             when '01' then
              d.watt
           end) as month_01,
       max(case substr(d.tmonth, -2)
             when '02' then
              d.watt
           end) as month_02,
       max(case substr(d.tmonth, -2)
             when '03' then
              d.watt
           end) as month_03,
       max(case substr(d.tmonth, -2)
             when '04' then
              d.watt
           end) as month_04,
       max(case substr(d.tmonth, -2)
             when '05' then
              d.watt
           end) as month_05,
       max(case substr(d.tmonth, -2)
             when '06' then
              d.watt
           end) as month_06,
       max(case substr(d.tmonth, -2)
             when '07' then
              d.watt
           end) as month_07,
       max(case substr(d.tmonth, -2)
             when '08' then
              d.watt
           end) as month_08,
       max(case substr(d.tmonth, -2)
             when '09' then
              d.watt
           end) as month_09,
       max(case substr(d.tmonth, -2)
             when '10' then
              d.watt
           end) as month_10,
       max(case substr(d.tmonth, -2)
             when '11' then
              d.watt
           end) as month_11,
       max(case substr(d.tmonth, -2)
             when '12' then
              d.watt
           end) as month_12
  from (select h.tyear, h.tmonth, sum(h.in_watt) - sum(h.out_watt) as watt
          from (select to_char(t.fillin_date, 'yyyy') as tyear,
                       to_char(t.fillin_date, 'yyyy-mm') as tmonth,
                       d.watt as in_watt,
                       0 as out_watt
                  from st_cell_in t, st_cell_in_dtl d, st_operation_type p
                 where t.id = d.main_id
                   and t.operation_type_id = p.id
                   and p.business_code = '3'
                union all
                select to_char(t.fillin_date, 'yyyy') as tyear,
                       to_char(t.fillin_date, 'yyyy-mm') as tmonth,
                       0 as in_watt,
                       d.watt as out_watt
                  from st_cell_out t, st_cell_out_dtl d, st_operation_type p
                 where t.id = d.main_id
                   and t.operation_type_id = p.id
                   and p.business_code = '30') h
         group by tyear, tmonth) d
 group by d.tyear


select d.tyear,
       max(case substr(d.tmonth, -2)
             when '01' then
              d.watt
           end) as month_01,
       max(case substr(d.tmonth, -2)
             when '02' then
              d.watt
           end) as month_02,
       max(case substr(d.tmonth, -2)
             when '03' then
              d.watt
           end) as month_03,
       max(case substr(d.tmonth, -2)
             when '04' then
              d.watt
           end) as month_04,
       max(case substr(d.tmonth, -2)
             when '05' then
              d.watt
           end) as month_05,
       max(case substr(d.tmonth, -2)
             when '06' then
              d.watt
           end) as month_06,
       max(case substr(d.tmonth, -2)
             when '07' then
              d.watt
           end) as month_07,
       max(case substr(d.tmonth, -2)
             when '08' then
              d.watt
           end) as month_08,
       max(case substr(d.tmonth, -2)
             when '09' then
              d.watt
           end) as month_09,
       max(case substr(d.tmonth, -2)
             when '10' then
              d.watt
           end) as month_10,
       max(case substr(d.tmonth, -2)
             when '11' then
              d.watt
           end) as month_11,
       max(case substr(d.tmonth, -2)
             when '12' then
              d.watt
           end) as month_12
  from (select h.tyear, h.tmonth, sum(h.sale_watt) - sum(h.receive_watt) as watt
          from (select to_char(t.fillin_date, 'yyyy') as tyear,
                       to_char(t.fillin_date, 'yyyy-mm') as tmonth,
                       0 as receive_watt,
                       d.watt as sale_watt
                  from st_cell_out t, st_cell_out_dtl d
                 where t.id = d.main_id
                 and  t.operation_code = 'saleOutDtl'
                union all
                select to_char(t.fillin_date, 'yyyy') as tyear,
                       to_char(t.fillin_date, 'yyyy-mm') as tmonth,
                       d.watt as receive_watt,
                       0 as sale_watt
                  from st_cell_out t, st_cell_out_dtl d
                 where t.id = d.main_id
                 and  t.operation_code = 'receiveProductApply') h
         group by tyear, tmonth) d
 group by d.tyear

select to_char(t.fillin_date, 'yyyy') as year
  from st_cell_out t
 group by to_char(t.fillin_date, 'yyyy')
 order by to_char(t.fillin_date, 'yyyy') desc

