select to_char(t.fillin_date, 'yyyy') as year
  from st_module_in t
 group by to_char(t.fillin_date, 'yyyy')
 order by to_char(t.fillin_date, 'yyyy') desc

-- 通威产出
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
          from st_module_in t, st_module_in_dtl d, st_storage s
         where t.id = d.main_id
           and d.storage_id = s.id
           and s.storage_tag = 0 -- 不是代工
         group by to_char(t.fillin_date, 'yyyy'),
                  to_char(t.fillin_date, 'yyyy-mm')) d
 group by d.tyear

--协鑫代工产出
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
          from st_module_in t, st_module_in_dtl d, st_storage s
         where t.id = d.main_id
           and d.storage_id = s.id
           and s.storage_tag = 1 -- 代工
            and d.storage_name like '%协鑫%'
         group by to_char(t.fillin_date, 'yyyy'),
                  to_char(t.fillin_date, 'yyyy-mm')) d
 group by d.tyear


--晶澳代工产出
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
          from st_module_in t, st_module_in_dtl d, st_storage s
         where t.id = d.main_id
           and d.storage_id = s.id
           and s.storage_tag = 1 -- 代工
            and d.storage_name like '%晶澳%'
         group by to_char(t.fillin_date, 'yyyy'),
                  to_char(t.fillin_date, 'yyyy-mm')) d
 group by d.tyear


--晶科代工产出
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
          from st_module_in t, st_module_in_dtl d, st_storage s
         where t.id = d.main_id
           and d.storage_id = s.id
           and s.storage_tag = 1 -- 代工
            and d.storage_name like '%晶科%'
         group by to_char(t.fillin_date, 'yyyy'),
                  to_char(t.fillin_date, 'yyyy-mm')) d
 group by d.tyear


-- 晶澳代工出货
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
          from st_module_out       t,
               sal_module_contract b,
               st_module_out_dtl   d,
               st_operation_type   p
         where t.sales_contract = b.contact_no(+)
           and t.id = d.main_id
           and t.operation_type_id = p.id
           and p.business_code = 12
           and b.customer like '%晶澳%'
           and b.SAL_TYPE_ID = '3' -- 代工出货
         group by to_char(t.fillin_date, 'yyyy'),
                  to_char(t.fillin_date, 'yyyy-mm')) d
 group by d.tyear

-- 晶科代工出货
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
          from st_module_out       t,
               sal_module_contract b,
               st_module_out_dtl   d,
               st_operation_type   p
         where t.sales_contract = b.contact_no(+)
           and t.id = d.main_id
           and t.operation_type_id = p.id
           and p.business_code = 12
           and b.customer like '%晶科%'
           and b.SAL_TYPE_ID = '3' -- 代工出货
         group by to_char(t.fillin_date, 'yyyy'),
                  to_char(t.fillin_date, 'yyyy-mm')) d
 group by d.tyear

-- 协鑫代工出货
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
          from st_module_out       t,
               sal_module_contract b,
               st_module_out_dtl   d,
               st_operation_type   p
         where t.sales_contract = b.contact_no(+)
           and t.id = d.main_id
           and t.operation_type_id = p.id
           and p.business_code = 12
           and b.customer like '%协鑫%'
           and b.SAL_TYPE_ID = '3' -- 代工出货
         group by to_char(t.fillin_date, 'yyyy'),
                  to_char(t.fillin_date, 'yyyy-mm')) d
 group by d.tyear

-- 通威出货
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
          from st_module_out       t,
               sal_module_contract b,
               st_module_out_dtl   d,
               st_operation_type   p
         where t.sales_contract = b.contact_no(+)
           and t.id = d.main_id
           and t.operation_type_id = p.id
           and p.business_code = 12
           
           and b.SAL_TYPE_ID != '3' -- 非代工出货
         group by to_char(t.fillin_date, 'yyyy'),
                  to_char(t.fillin_date, 'yyyy-mm')) d
 group by d.tyear

