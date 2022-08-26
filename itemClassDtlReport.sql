select a.organ_id,
       a.itemdtlid,
       a.itemdtlidname,
       a.yearmonth,
       a.period_no,
       a.period_year,
       a.accountcode,
       a.accountname,
       a.vouchertypeno,
       a.sourcebilldate,
       a.vouchererpid,
       case
         when a.yearmonth is not null and a.accountname is null then
          '本期合计'
         when a.itemdtlidname is not null and a.yearmonth is null then
          '查询期间合计'
         when a.accountname is not null and a.vouchertypeno is null and
              a.priortotal is null then
          '科目合计'
         else
          a.summaryname
       end summaryname,
       a.postername,
       a.currency_id,
       decode(a.isdc,
              null,
              nvl(a.original_debit_amount, a.o_debit_sum),
              a.original_debit_amount) original_debit_amount,
       decode(a.isdc,
              null,
              nvl(a.original_credit_amount, a.o_credit_sum),
              a.original_credit_amount) original_credit_amount,
       a.isdc,
       decode(a.isdc, null, nvl(a.debit_total, a.debit_sum), a.debit_total) debit_total,
       decode(a.isdc,
              null,
              nvl(a.credit_total, a.credit_sum),
              a.credit_total) credit_total,
       a.dtlnumber,
       case
         when a.balance_total > 0 then
          a.balance_total
         when a.balance_total < 0 then
          (-1) * a.balance_total
       end balance_total,
       a.balance_total_for,
       a.priortotal,
       a.beginbalancefor,
       a.dir,
       a.debit_sum,
       a.credit_sum,
       a.o_debit_sum,
       a.o_credit_sum
  from (select a.organ_id,
               a.yearmonth,
               a.period_no,
               a.period_year,
               a.vouchertypeno,
               a.sourcebilldate,
               a.summaryname,
               a.accountcode,
               a.accountname,
               a.currency_id,
               a.original_debit_amount,
               a.original_credit_amount,
               a.isdc,
               a.debit_total,
               a.credit_total,
               a.dtlnumber,
               a.balance_total,
               a.balance_total_for,
               a.priortotal,
               a.beginbalancefor,
               a.dir,
               a.vouchererpid,
               a.postername,
               a.itemdtlid,
               a.itemdtlidname,
               sum(a.debit_total) debit_sum,
               sum(a.credit_total) credit_sum,
               sum(a.original_debit_amount) o_debit_sum,
               sum(a.original_credit_amount) o_credit_sum
          from (select t.organ_id,
                       m.period_code yearmonth,
                       m.period_no,
                       m.period_year,
                       t.vouchertypeno,
                       t.sourcebilldate,
                       d.summaryname,
                       a.accountcode,
                       a.accountname,
                       b.id currency_id,
                       t.vouchererpid,
                       decode(nvl(d.isdc, 0), 1, d.oc_total, null) original_debit_amount,
                       decode(nvl(d.isdc, 0), 0, d.oc_total, null) original_credit_amount,
                       d.isdc,
                       decode(nvl(d.isdc, 0), 1, d.total, null) debit_total,
                       decode(nvl(d.isdc, 0), 0, d.total, null) credit_total,
                       d.dtlnumber,
                       d.itemdtlid,
                       d.itemdtlidname,
                       case
                         when (sum(decode(nvl(d.isdc, 0),
                                          1,
                                          d.total,
                                          0,
                                          d.total))
                               over(partition by m.period_code,
                                    a.accountcode,
                                    d.itemdtlid order by t.sourcebilldate,
                                    t.vouchertypeno,
                                    d.dtlnumber,
                                    d.erpdtlid) + nvl(priortotal, 0)) > 0 then
                          sum(decode(nvl(d.isdc, 0),
                                     1,
                                     d.total,
                                     0,
                                     d.total * (-1)))
                          over(partition by m.period_code,
                               a.accountcode,
                               d.itemdtlid order by t.sourcebilldate,
                               t.vouchertypeno,
                               d.dtlnumber,
                               d.erpdtlid) + nvl(priortotal, 0)
                         when (sum(decode(nvl(d.isdc, 0),
                                          1,
                                          d.total,
                                          0,
                                          d.total * (-1)))
                               over(partition by m.period_code,
                                    a.accountcode,
                                    d.itemdtlid order by t.sourcebilldate,
                                    t.vouchertypeno,
                                    d.dtlnumber,
                                    d.erpdtlid) + nvl(priortotal, 0)) < 0 then
                          abs(sum(decode(nvl(d.isdc, 0),
                                         1,
                                         d.total,
                                         0,
                                         d.total * (-1)))
                              over(partition by m.period_code,
                                   a.accountcode,
                                   d.itemdtlid order by t.sourcebilldate,
                                   t.vouchertypeno,
                                   d.dtlnumber,
                                   d.erpdtlid) + nvl(priortotal, 0))
                         else
                          0
                       end balance_total,
                       case
                         when (sum(decode(nvl(d.isdc, 0),
                                          1,
                                          d.oc_total,
                                          0,
                                          d.oc_total * (-1)))
                               over(partition by m.period_code,
                                    a.accountcode,
                                    d.itemdtlid order by t.sourcebilldate,
                                    t.vouchertypeno,
                                    d.dtlnumber,
                                    d.erpdtlid) + nvl(beginbalancefor, 0)) > 0 then
                          sum(decode(nvl(d.isdc, 0),
                                     1,
                                     d.oc_total,
                                     0,
                                     d.oc_total * (-1)))
                          over(partition by m.period_code,
                               a.accountcode,
                               d.itemdtlid order by t.sourcebilldate,
                               t.vouchertypeno,
                               d.dtlnumber,
                               d.erpdtlid) + nvl(beginbalancefor, 0)
                         when (sum(decode(nvl(d.isdc, 0),
                                          1,
                                          d.oc_total,
                                          0,
                                          d.oc_total * (-1)))
                               over(partition by m.period_code,
                                    a.accountcode,
                                    d.itemdtlid order by t.sourcebilldate,
                                    t.vouchertypeno,
                                    d.dtlnumber,
                                    d.erpdtlid) + nvl(beginbalancefor, 0)) < 0 then
                          abs(sum(decode(nvl(d.isdc, 0),
                                         1,
                                         d.oc_total,
                                         0,
                                         d.oc_total * (-1)))
                              over(partition by m.period_code,
                                   a.accountcode,
                                   d.itemdtlid order by t.sourcebilldate,
                                   t.vouchertypeno,
                                   d.dtlnumber,
                                   d.erpdtlid) + nvl(beginbalancefor, 0))
                         else
                          0
                       end balance_total_for,
                       nvl(priortotal, 0) priortotal,
                       nvl(beginbalancefor, 0) beginbalancefor,
                       case
                         when (sum(decode(nvl(d.isdc, 0),
                                          1,
                                          d.total,
                                          0,
                                          d.total * (-1)))
                               over(partition by m.period_code,
                                    a.accountcode,
                                    d.itemdtlid order by t.sourcebilldate,
                                    t.vouchertypeno,
                                    d.dtlnumber,
                                    d.erpdtlid) + nvl(priortotal, 0)) > 0 then
                          '借'
                         when (sum(decode(nvl(d.isdc, 0),
                                          1,
                                          d.total,
                                          0,
                                          d.total * (-1)))
                               over(partition by m.period_code,
                                    a.accountcode,
                                    d.itemdtlid order by t.sourcebilldate,
                                    t.vouchertypeno,
                                    d.dtlnumber,
                                    d.erpdtlid) + nvl(priortotal, 0)) < 0 then
                          '贷'
                         else
                          '平'
                       end dir,
                       p.name postername
                  from fn_vouchererp t,
                       fn_datasource da,
                       sa_oporg o,
                       fn_account_period_dtl m,
                       sa_opperson p,
                       fn_vouchererpdtl d,
                       fn_accountinfo a,
                       fn_accountitem e,
                       fn_currencyinfo b,
                       fn_erp_balance c,
                       fn_itemdetailv h,
                       (SELECT t.cost_id, t.organ_id
                          FROM (select k2.cost_id, k2.organ_id
                                  from fn_cost_subject_config         k,
                                       fn_cost_subject_config_dtl     k1,
                                       fn_cost_subject_config_dtl_dtl k2,
                                       fn_org_cost                    k4
                                 where k.id = k1.main_id
                                   and k1.id = k2.main_id
                                   and k.dept_id = k4.org_id
                                   and k.status = '1'
                                   and k.config_type = '1'
                                   and k.type = '2'
                                   and k4.cost_id in
                                       (select * from table(split('${itemid}')))
                                   and k.organ_id = '${organId}'
                                union all
                                select k2.cost_id, k1.organ_id
                                  from fn_cost_subject_config     k,
                                       fn_cost_subject_config_dtl k1,
                                       fn_org_cost                k2,
                                       fn_org_cost                k4
                                 where k.id = k1.main_id
                                   and k1.dept_id = k2.org_id
                                   and k.dept_id = k4.org_id
                                   and k.status = '1'
                                   and k.config_type = '1'
                                   and k.type = '2'
                                   and k4.cost_id in
                                       (select * from table(split('${itemid}')))
                                   and k.organ_id = '${organId}'
                                union all
                                select k.column_value as cost_id,
                                       '${organId}' as organ_id
                                  from (select * from table(split('${itemid}'))) k) t
                         group by t.cost_id, t.organ_id) h1
                 where t.datasourceid = da.id(+)
                   and t.organ_id = o.id(+)
                   and t.monthid = m.id(+)
                   and t.posterid = p.id(+)
                   and t.vouchererpid = d.vouchererpid
                   and d.accountid = a.id(+)
                   and nvl(t.currency_id, 1) = b.id(+)
                   and d.accountid(+) = c.accountid
                   and t.organ_id(+) = c.organ_id
                   and m.period_code = c.yearmonth
                   and d.itemdtlid(+) = c.itemdtlid
                   and t.currency_id(+) = c.currencyid
                   and d.accountid = e.accountid
                   and m.period_code >= '${yearmonthBegin}'
                   and m.period_code <= '${yearmonthEnd}'
                   and t.currency_id = decode('0', '0', t.currency_id, '0')
                   and t.status = 2000
                   and c.itemdtlid = h.itemdtlid
                   and h.itemid = h1.cost_id
                   and t.organ_id = h1.organ_id
                   and e.itemclassid = '2'
                   and a.accountcode in
                       (select k1.ACCOUNT_CODE
                          from FN_COST_SUBJECT_CONFIG     K,
                               FN_COST_SUBJECT_CONFIG_DTL K1
                         where k.id = k1.main_id
                           and k.status = '1'
                           and k.type = '1'
                           and k.code = '${code}')
                   and nvl(t.is_account, 0) =
                       decode('1', '0', '1', '1', nvl(t.is_account, 0))) a
         group by rollup(a.organ_id,
                         a.itemdtlid,
                         a.itemdtlidname,
                         a.yearmonth,
                         a.period_no,
                         a.period_year,
                         a.accountcode,
                         a.accountname,
                         a.vouchertypeno,
                         a.sourcebilldate,
                         a.vouchererpid,
                         a.summaryname,
                         a.postername,
                         a.currency_id,
                         a.original_debit_amount,
                         a.original_credit_amount,
                         a.isdc,
                         a.debit_total,
                         a.credit_total,
                         a.dtlnumber,
                         a.balance_total,
                         a.balance_total_for,
                         a.priortotal,
                         a.beginbalancefor,
                         a.dir)
         order by a.itemdtlid,
                  a.itemdtlidname,
                  a.yearmonth,
                  a.accountcode,
                  a.sourcebilldate,
                  a.vouchertypeno,
                  a.dtlnumber) a
 where 1 = 1
   and ((a.yearmonth is null and a.itemdtlidname is not null) or
       (a.yearmonth is not null and a.period_no is null) or
       a.dir is not null or
       (a.vouchertypeno is null and a.accountname is not null))
   and decode(a.isdc,
              null,
              nvl(nvl(a.debit_total, a.debit_sum), 0),
              nvl(a.debit_total, 0)) != 0


