SELECT account_code,
       account_name,
       nvl(sum(year_month01), 0) as year_month01,
       nvl(sum(year_month02), 0) as year_month02,
       nvl(sum(year_month03), 0) as year_month03,
       nvl(sum(year_month04), 0) as year_month04,
       nvl(sum(year_month05), 0) as year_month05,
       nvl(sum(year_month06), 0) as year_month06,
       nvl(sum(year_month07), 0) as year_month07,
       nvl(sum(year_month08), 0) as year_month08,
       nvl(sum(year_month09), 0) as year_month09,
       nvl(sum(year_month10), 0) as year_month10,
       nvl(sum(year_month11), 0) as year_month11,
       nvl(sum(year_month12), 0) as year_month12
  FROM (select account_code,
               '1' as is_no_account,
               itemdtlid,
               account_name,
               year_month01,
               year_month02,
               year_month03,
               year_month04,
               year_month05,
               year_month06,
               year_month07,
               year_month08,
               year_month09,
               year_month10,
               year_month11,
               year_month12
          from (select c.account_code,
                       t.itemdtlid,
                       replace(c.account_name, h.parent_name || '_', '') as account_name,
                       nvl(t.monthdebittotal, 0) as monthdebittotal,
                       substr(t.yearmonth, 6, 2) yearmonth
                  from fn_erp_balance_na t,
                       (select * from v_fn_accountinfo_new) c,
                       fn_account_book e,
                       fn_accountbook_org f,
                       fn_accountinfo h
                 where 1 = 1
                   and t.accountid = c.account_id
                   and t.organ_id = c.organ_id
                   and t.currencyid = '0'
                   and t.yearmonth like SUBSTR('${yearmonth}', 1, 4) || '%'
                   and t.has_total is null
                   and f.accountbook_id = e.id
                   and f.organ_id = t.organ_id
                   and c.level_count = 4
                   and c.account_code like '5301%'
                   and c.account_id = h.id
                   and e.id = '${accountbookId}'
                   and t.itemdtlid = 0
                   ${parameter1} -- 公司id
                   and case
                         when nvl(t.priortotal, 0) = 0 and
                              nvl(t.monthdebittotal, 0) = 0 and
                              nvl(t.monthcredittotal, 0) = 0 and
                              nvl(t.balancetotal, 0) = 0 and
                              nvl(t.yeardebittotal, 0) = 0 and
                              nvl(t.yearcredittotal, 0) = 0 then
                          0
                         else
                          1
                       end = 1) pivot(sum(monthdebittotal) for yearmonth in('01' as
                                                                            year_month01,
                                                                            '02' as
                                                                            year_month02,
                                                                            '03' as
                                                                            year_month03,
                                                                            '04' as
                                                                            year_month04,
                                                                            '05' as
                                                                            year_month05,
                                                                            '06' as
                                                                            year_month06,
                                                                            '07' as
                                                                            year_month07,
                                                                            '08' as
                                                                            year_month08,
                                                                            '09' as
                                                                            year_month09,
                                                                            '10' as
                                                                            year_month10,
                                                                            '11' as
                                                                            year_month11,
                                                                            '12' as
                                                                            year_month12))
        
        union all
        
        select account_code,
               '0' as is_no_account,
               itemdtlid,
               account_name,
               year_month01,
               year_month02,
               year_month03,
               year_month04,
               year_month05,
               year_month06,
               year_month07,
               year_month08,
               year_month09,
               year_month10,
               year_month11,
               year_month12
          from (select c.account_code,
                       t.itemdtlid,
                       replace(c.account_name, h.parent_name || '_', '') as account_name,
                       nvl(t.monthdebittotal, 0) as monthdebittotal,
                       substr(t.yearmonth, 6, 2) yearmonth
                  from fn_erp_balance t,
                       (select * from v_fn_accountinfo_new) c,
                       fn_account_book e,
                       fn_accountbook_org f,
                       fn_accountinfo h
                 where 1 = 1
                   and t.accountid = c.account_id
                   and t.organ_id = c.organ_id
                   and t.currencyid = '0'
                   and t.yearmonth like SUBSTR('${yearmonth}', 1, 4) || '%'
                   and t.has_total is null
                   and f.accountbook_id = e.id
                   and f.organ_id = t.organ_id
                   and c.level_count = 4
                   and c.account_code like '5301%'
                   and c.account_id = h.id
                   and e.id = '${accountbookId}'
                   and t.itemdtlid = 0
                   ${parameter1} -- 公司id
                   and case
                         when nvl(t.priortotal, 0) = 0 and
                              nvl(t.monthdebittotal, 0) = 0 and
                              nvl(t.monthcredittotal, 0) = 0 and
                              nvl(t.balancetotal, 0) = 0 and
                              nvl(t.yeardebittotal, 0) = 0 and
                              nvl(t.yearcredittotal, 0) = 0 then
                          0
                         else
                          1
                       end = 1) pivot(sum(monthdebittotal) for yearmonth in('01' as
                                                                            year_month01,
                                                                            '02' as
                                                                            year_month02,
                                                                            '03' as
                                                                            year_month03,
                                                                            '04' as
                                                                            year_month04,
                                                                            '05' as
                                                                            year_month05,
                                                                            '06' as
                                                                            year_month06,
                                                                            '07' as
                                                                            year_month07,
                                                                            '08' as
                                                                            year_month08,
                                                                            '09' as
                                                                            year_month09,
                                                                            '10' as
                                                                            year_month10,
                                                                            '11' as
                                                                            year_month11,
                                                                            '12' as
                                                                            year_month12))) t
 where t.is_no_account = '${isNoAccount}'
 group by account_code,
                
                account_name


SELECT account_code,
       is_no_account,
       nvl(sum(monthdebittotal), 0) as monthdebittotal,
       nvl(sum(yeardebittotal), 0) as yeardebittotal
  FROM (select c.account_code,
               '1' as is_no_account,
               t.monthdebittotal,
               t.yeardebittotal
          from fn_erp_balance_na t,
               (select * from v_fn_accountinfo_new) c,
               fn_account_book e,
               fn_accountbook_org f,
               fn_accountinfo h
         where 1 = 1
           and t.accountid = c.account_id
           and t.organ_id = c.organ_id
           and t.currencyid = '0'
           and t.yearmonth = '${yearmonth}'
           and t.has_total is null
           and f.accountbook_id = e.id
           and f.organ_id = t.organ_id
           and c.level_count = 4
           and c.account_code like '5301%'
           and c.account_id = h.id
           and e.id = '${accountbookId}'
           and t.itemdtlid = 0
           and case
                 when nvl(t.priortotal, 0) = 0 and
                      nvl(t.monthdebittotal, 0) = 0 and
                      nvl(t.monthcredittotal, 0) = 0 and
                      nvl(t.balancetotal, 0) = 0 and
                      nvl(t.yeardebittotal, 0) = 0 and
                      nvl(t.yearcredittotal, 0) = 0 then
                  0
                 else
                  1
               end = 1
               ${parameter1} -- 公司id
        
        union all
        
        select c.account_code,
               '0' as is_no_account,
               t.monthdebittotal,
               t.yeardebittotal
          from fn_erp_balance t,
               (select * from v_fn_accountinfo_new) c,
               fn_account_book e,
               fn_accountbook_org f,
               fn_accountinfo h
         where 1 = 1
           and t.accountid = c.account_id
           and t.organ_id = c.organ_id
           and t.currencyid = '0'
           and t.yearmonth = '${yearmonth}'
           and t.has_total is null
           and f.accountbook_id = e.id
           and f.organ_id = t.organ_id
           and c.level_count = 4
           and c.account_code like '5301%'
           and c.account_id = h.id
           and e.id = '${accountbookId}'
           
           and t.itemdtlid = 0
           and case
                 when nvl(t.priortotal, 0) = 0 and
                      nvl(t.monthdebittotal, 0) = 0 and
                      nvl(t.monthcredittotal, 0) = 0 and
                      nvl(t.balancetotal, 0) = 0 and
                      nvl(t.yeardebittotal, 0) = 0 and
                      nvl(t.yearcredittotal, 0) = 0 then
                  0
                 else
                  1
               end = 1
               ${parameter1} -- 公司id
               ) t
 where 1 = 1
 and  t.is_no_account = '${isNoAccount}'
 group by account_code, is_no_account


SELECT account_code,
       is_no_account,
       nvl(sum(monthdebittotal), 0) as monthdebittotal,
       nvl(sum(yeardebittotal), 0) as yeardebittotal
  FROM (select c.account_code,
               '1' as is_no_account,
               t.monthdebittotal,
               t.yeardebittotal
          from fn_erp_balance_na t,
               (select * from v_fn_accountinfo_new) c,
               fn_account_book e,
               fn_accountbook_org f,
               fn_accountinfo h
         where 1 = 1
           and t.accountid = c.account_id
           and t.organ_id = c.organ_id
           and t.currencyid = '0'
           and t.yearmonth = to_char(add_months(to_date('${yearmonth}','yyyy-mm'),-12),'yyyy-mm')
           and t.has_total is null
           and f.accountbook_id = e.id
           and f.organ_id = t.organ_id
           and c.level_count = 4
           and c.account_code like '5301%'
           and c.account_id = h.id
           and e.id = '${accountbookId}'
           and t.itemdtlid = 0
           ${parameter1} -- 公司id
           and case
                 when nvl(t.priortotal, 0) = 0 and
                      nvl(t.monthdebittotal, 0) = 0 and
                      nvl(t.monthcredittotal, 0) = 0 and
                      nvl(t.balancetotal, 0) = 0 and
                      nvl(t.yeardebittotal, 0) = 0 and
                      nvl(t.yearcredittotal, 0) = 0 then
                  0
                 else
                  1
               end = 1
        
        union all
        
        select c.account_code,
               '0' as is_no_account,
               t.monthdebittotal,
               t.yeardebittotal
          from fn_erp_balance t,
               (select * from v_fn_accountinfo_new) c,
               fn_account_book e,
               fn_accountbook_org f,
               fn_accountinfo h
         where 1 = 1
           and t.accountid = c.account_id
           and t.organ_id = c.organ_id
           and t.currencyid = '0'
           and t.yearmonth = to_char(add_months(to_date('${yearmonth}','yyyy-mm'),-12),'yyyy-mm')
           and t.has_total is null
           and f.accountbook_id = e.id
           and f.organ_id = t.organ_id
           and c.level_count = 4
           and c.account_code like '5301%'
           and c.account_id = h.id
           and e.id = '${accountbookId}'
           and t.itemdtlid = 0
           ${parameter1} -- 公司id
           and case
                 when nvl(t.priortotal, 0) = 0 and
                      nvl(t.monthdebittotal, 0) = 0 and
                      nvl(t.monthcredittotal, 0) = 0 and
                      nvl(t.balancetotal, 0) = 0 and
                      nvl(t.yeardebittotal, 0) = 0 and
                      nvl(t.yearcredittotal, 0) = 0 then
                  0
                 else
                  1
               end = 1) t
 where 1 = 1 and  t.is_no_account = '${isNoAccount}'
 group by account_code, is_no_account


