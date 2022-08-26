select nvl(sum(t.fn_amount),0) fn_amount
  from view_query_mate_out t
 where t.materiel_type like '%单晶%硅片%'
   and t.trademark_name like '%永祥%'
   and t.organ_id = '${organId}'
   and (t.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (t.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(t.fn_amount),0) fn_amount
  from view_query_mate_out t
 where t.materiel_type like '%单晶%硅片%'
   and t.trademark_name like '%永祥%'
   and (t.account_code like '5101%' or t.account_code like '5001%')
   and t.organ_id = '${organId}'
   and (t.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (t.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(t.fn_amount),0) fn_amount
  from view_query_mate_out t
 where t.materiel_type like '%单晶%硅片%'
   and (t.account_code like '5101%' or t.account_code like '5001%')
   and t.organ_id = '${organId}'
   and (t.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (t.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(t.fn_amount),0) fn_amount
  from view_query_mate_out t
 where t.materiel_type like '%多晶%硅片%'
   and t.trademark_name like '%永祥%'
   and t.organ_id = '${organId}'
   and (t.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (t.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(t.fn_amount),0) fn_amount
  from view_query_mate_out t
 where t.materiel_type like '%多晶%硅片%'
   and t.trademark_name like '%永祥%'
   and (t.account_code like '5101%' or t.account_code like '5001%')
   and t.organ_id = '${organId}'
   and (t.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (t.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(t.fn_amount),0) fn_amount
  from view_query_mate_out t
 where t.materiel_type like '%多晶%硅片%'
   and (t.account_code like '5101%' or t.account_code like '5001%')
   and t.organ_id = '${organId}'
   and (t.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (t.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(t.normal_yl), 0) qty, nvl(sum(t.normal_amount), 0) amount
  from fn_cost_pdt_in t
 where t.finance_category_name like '多晶电池%'
   and t.pdt_type = '1'
   and t.organ_id = '${organId}'
   and (t.year_month_v >= '${beginDate}' or '${beginDate}' is null)
   and (t.year_month_v <= '${endDate}' or '${endDate}' is null)

select nvl(sum(t.fn_amount),0) fn_amount
  from view_query_mate_out t
 where t.materiel_type like '%单晶%电池片%'
   and t.trademark_name like '%通威%'
   and t.organ_id = '${organId}'
   and (t.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (t.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(t.fn_amount),0) fn_amount
  from view_query_mate_out t
 where t.materiel_type like '%单晶%电池片%'
   and t.trademark_name like '%通威%'
   and (t.account_code like '5101%' or t.account_code like '5001%')
   and t.organ_id = '${organId}'
   and (t.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (t.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(t.fn_amount),0) fn_amount
  from view_query_mate_out t
 where t.materiel_type like '%单晶%电池片%'
   and (t.account_code like '5101%' or t.account_code like '5001%')
   and t.organ_id = '${organId}'
   and (t.fillin_date >= to_date('${beginDate}', 'yyyy-mm') or
       '${beginDate}' is null)
   and (t.fillin_date < add_months(to_date('${endDate}', 'yyyy-mm'), 1) or
       '${endDate}' is null)

select nvl(sum(t.normal_yl), 0) qty, nvl(sum(t.normal_amount), 0) amount
  from fn_cost_pdt_in t
 where t.finance_category_name like '%单晶电池%'
   and t.pdt_type = '1'
   and t.organ_id = '${organId}'
   and (t.year_month_v >= '${beginDate}' or '${beginDate}' is null)
   and (t.year_month_v <= '${endDate}' or '${endDate}' is null)

select nvl(sum(t.normal_yl), 0) qty, nvl(sum(t.normal_amount), 0) amount
  from fn_cost_pdt_in t
 where (t.finance_category_name like '%单晶组件%' or
       t.finance_category_name like '%叠瓦组件%')
   and t.pdt_type = '1'
   and t.organ_id = '${organId}'
   and (t.year_month_v >= '${beginDate}' or '${beginDate}' is null)
   and (t.year_month_v <= '${endDate}' or '${endDate}' is null)

select nvl(sum(t.normal_yl), 0) qty, nvl(sum(t.normal_amount), 0) amount
  from fn_cost_pdt_in t
 where t.finance_category_name like '%多晶组件%'
   and t.pdt_type = '1'
   and t.organ_id = '${organId}'
   and (t.year_month_v >= '${beginDate}' or '${beginDate}' is null)
   and (t.year_month_v <= '${endDate}' or '${endDate}' is null)

select nvl(sum(t.balancetotal), 0) balancetotal
  from fn_erp_balance_na t, v_fn_accountinfo_new c, fn_itemdetailv i
 where t.accountid = c.account_id
   and t.organ_id = c.organ_id
   and t.itemdtlid = i.itemdtlid
   and t.currencyid = '0' --综合本位币
   and t.has_total is null
   and t.itemclassname like '%多晶电池%'
   and (c.account_code like '1405%' or c.account_code like '1406%')
   and i.itemclassid = '3003' --核算项目类别=产品
   and t.organ_id = '${organId}'
   and (t.yearmonth = '${endDate}' or '${endDate}' is null)

select nvl(sum(t.balancetotal), 0) balancetotal
  from fn_erp_balance_na t, v_fn_accountinfo_new c, fn_itemdetailv i
 where t.accountid = c.account_id
   and t.organ_id = c.organ_id
   and t.itemdtlid = i.itemdtlid
   and t.currencyid = '0' --综合本位币
   and t.has_total is null
   and t.itemclassname like '%单晶电池%'
   and (c.account_code like '1405%' or c.account_code like '1406%')
   and i.itemclassid = '3003' --核算项目类别=产品
   and t.organ_id = '${organId}'
   and (t.yearmonth = '${endDate}' or '${endDate}' is null)

select nvl(sum(t.balancetotal), 0) balancetotal
  from fn_erp_balance_na t, v_fn_accountinfo_new c, fn_itemdetailv i
 where t.accountid = c.account_id
   and t.organ_id = c.organ_id
   and t.itemdtlid = i.itemdtlid
   and t.currencyid = '0' --综合本位币
   and t.has_total is null
   and (t.itemclassname like '%单晶组件%' or t.itemclassname like '%叠瓦组件%')
   and (c.account_code like '1405%' or c.account_code like '1406%')
   and i.itemclassid = '3003' --核算项目类别=产品
   and t.organ_id = '${organId}'
   and (t.yearmonth = '${endDate}' or '${endDate}' is null)

select nvl(sum(t.balancetotal), 0) balancetotal
  from fn_erp_balance_na t, v_fn_accountinfo_new c, fn_itemdetailv i
 where t.accountid = c.account_id
   and t.organ_id = c.organ_id
   and t.itemdtlid = i.itemdtlid
   and t.currencyid = '0' --综合本位币
   and t.has_total is null
   and t.itemclassname like '%多晶组件%'
   and (c.account_code like '1405%' or c.account_code like '1406%')
   and i.itemclassid = '3003' --核算项目类别=产品
   and t.organ_id = '${organId}'
   and (t.yearmonth = '${endDate}' or '${endDate}' is null)

select tt.organ_name,
       tt.itemname,
       nvl(sum(tt.sr), 0) sr,
       nvl(sum(tt.cb), 0) cb,
       decode(nvl(sum(tt.sr), 0),
              0,
              0,
              (sum(tt.sr) - nvl(sum(tt.cb), 0)) / sum(tt.sr)) rate
  from (select a.itemname,
               a.organ_id,
               a.cus_id,
               a.companyname,
               a.yearmonth,
               a.sr,
               b.cb,
               a.organ_name
          from (select d.itemname,
                       t.organ_name,
                       t.organ_id,
                       c.companyname,
                       t.yearmonth,
                       a.account_name,
                       t.fcreditqty,
                       t.monthcredittotal sr,
                       c.id               cus_id
                  from fn_erp_balance       t,
                       v_fn_accountinfo_new a,
                       fn_iteminfo          d,
                       fn_itemdetailv       b,
                       fn_itemdetailv       b2,
                       com_grp_party        c
                 where t.accountid = a.account_id
                   and t.organ_id = a.organ_id
                   and t.itemdtlid = b.itemdtlid
                   and t.itemdtlid = b2.itemdtlid
                   and b2.itemid = c.id
                   and b.itemid = d.itemid
                   and a.account_code like '6001%'
                   and a.child_num = 0
                   and b2.itemid <> '9999'
                   and b.itemclassid = '3003'
                   and t.currencyid = '0') a
          left join (select d.itemname,
                           t.organ_name,
                           t.organ_id,
                           c.companyname,
                           t.yearmonth,
                           a.account_name,
                           t.monthdebittotal cb,
                           c.id              cus_id
                      from fn_erp_balance       t,
                           v_fn_accountinfo_new a,
                           fn_iteminfo          d,
                           fn_itemdetailv       b,
                           fn_itemdetailv       b2,
                           com_grp_party        c
                     where t.accountid = a.account_id
                       and t.organ_id = a.organ_id
                       and t.itemdtlid = b.itemdtlid
                       and t.itemdtlid = b2.itemdtlid
                       and b2.itemid = c.id
                       and b.itemid = d.itemid
                       and a.account_code like '6401%'
                       and a.child_num = 0
                       and b2.itemid <> '9999'
                       and b.itemclassid = '3003'
                       and t.currencyid = '0') b
            on a.itemname = b.itemname
           and a.organ_name = b.organ_name
           and a.cus_id = b.cus_id
           and a.yearmonth = b.yearmonth
        union all
        select a.itemname,
               a.organ_id,
               a.cus_id,
               a.companyname,
               a.yearmonth,
               a.sr,
               null cb,
               a.organ_name
          from (select d.itemname,
                       t.organ_name,
                       t.organ_id,
                       c.companyname,
                       t.yearmonth,
                       a.account_name,
                       t.fcreditqty,
                       t.monthcredittotal sr,
                       c.id               cus_id
                  from fn_erp_balance       t,
                       v_fn_accountinfo_new a,
                       fn_iteminfo          d,
                       fn_itemdetailv       b,
                       fn_itemdetailv       b2,
                       com_grp_party        c
                 where t.accountid = a.account_id
                   and t.organ_id = a.organ_id
                   and t.itemdtlid = b.itemdtlid
                   and t.itemdtlid = b2.itemdtlid
                   and b2.itemid = c.id
                   and b.itemid = d.itemid
                   and a.account_code like '6051%'
                   and a.child_num = 0
                   and b2.itemid <> '9999'
                   and b.itemclassid = '3003'
                   and t.currencyid = '0') a
        union all
        select a.materieltype_name itemname,
               a.organ_id,
               a.cus_id,
               a.companyname,
               a.yearmonth,
               a.sr,
               a.dj * a.qty cb,
               a.organ_name
          from (select d.materieltype_name,
                       a.companyname,
                       t.organ_name,
                       b.unit_cname,
                       sum(abs(f.qty)) qty,
                       sum(abs(f.total)) sr,
                       t.organ_id,
                       a.mainid cus_id,
                       d.id type_id,
                       to_char(e.fillin_date, 'yyyy-mm') yearmonth,
                       g.accountname,
                       (select b.unitprice dj
                          from fn_vouchererp         t,
                               fn_vouchererpdtl      b,
                               fn_accountinfo        a,
                               fn_account_period_dtl c,
                               fn_itemdetailv        d,
                               fn_iteminfo           e
                         where t.vouchererpid = b.vouchererpid
                           and b.accountid = a.id
                           and a.accountcode = '1604.05.01.03'
                           and t.monthid = c.id
                           and b.itemdtlid = d.itemdtlid
                           and d.itemid = e.itemid
                           and d.itemclassid = '3003'
                           and rownum = 1) dj
                  from fn_ar_sale_invoice     t,
                       view_customer_all      a,
                       fn_ar_sale_invoice_dtl b,
                       com_materiel_info      c,
                       view_com_materieltype  d,
                       view_com_materieltype  d2,
                       fn_vouchererp          e,
                       fn_vouchererpdtl       f,
                       fn_accountinfo         g
                 where t.customer_id = a.id
                   and a.is_internal = '1'
                   and t.id = b.main_id
                   and c.materiel_code = b.product_code
                   and e.vouchererpid = f.vouchererpid
                   and f.accountid = g.id
                   and g.accountcode = '1604.05.01.02'
                   and d.all_code =
                       solar_scm_qa.f_get_com_materieltype_secode(c.materieltype_id)
                   and d2.all_code =
                       solar_scm_qa.f_get_com_materieltype_code(c.materieltype_id)
                   and d2.materieltype_code = '11'
                   and e.sourceid = t.id
                   and t.status = 2000
                   and e.status = 2000
                   and f.isdc = '1'
                 group by a.companyname,
                          t.organ_name,
                          b.unit_cname,
                          d.materieltype_name,
                          to_char(e.fillin_date, 'yyyy-mm'),
                          t.organ_id,
                          a.mainid,
                          d.id,
                          g.accountname) a
        union all
        select a.materieltype_name itemname,
               a.organ_id,
               a.cus_id,
               a.companyname,
               a.yearmonth,
               a.sr,
               b.cb,
               a.organ_name
          from (select d.materieltype_name,
                       a.companyname,
                       t.organ_name,
                       b.unit_cname,
                       sum(b.qty) qty,
                       sum(b.oc_amount) sr,
                       t.organ_id,
                       a.mainid cus_id,
                       d.id type_id,
                       to_char(e.fillin_date, 'yyyy-mm') yearmonth
                  from fn_ar_sale_invoice     t,
                       view_customer_all      a,
                       fn_ar_sale_invoice_dtl b,
                       com_materiel_info      c,
                       view_com_materieltype  d,
                       view_com_materieltype  d2,
                       fn_vouchererp          e
                 where t.customer_id = a.id
                   and a.is_internal = '1'
                   and t.id = b.main_id
                   and c.materiel_code = b.product_code
                   and d.all_code =
                       solar_scm_qa.f_get_com_materieltype_secode(c.materieltype_id)
                   and d2.all_code =
                       solar_scm_qa.f_get_com_materieltype_code(c.materieltype_id)
                   and d2.materieltype_code != '11'
                   and e.sourceid = t.id
                   and t.status = 2000
                   and e.status = 2000
                 group by a.companyname,
                          t.organ_name,
                          b.unit_cname,
                          d.materieltype_name,
                          to_char(e.fillin_date, 'yyyy-mm'),
                          t.organ_id,
                          a.mainid,
                          d.id) a
          left join (select a.materieltype_name,
                            a.organ_name,
                            a.companyname,
                            a.unit_cname,
                            sum(a.fn_amount) cb,
                            a.organ_id,
                            a.mainid cus_id,
                            a.id type_id,
                            a.yearmonth
                       from (select distinct g.materieltype_name,
                                             b.organ_name,
                                             a.companyname,
                                             t.unit_cname,
                                             t.fn_amount,
                                             b.organ_id,
                                             a.mainid,
                                             g.id,
                                             to_char(h.fillin_date, 'yyyy-mm') yearmonth
                               from view_query_mate_out    t,
                                    view_customer_all      a,
                                    st_mate_out            b,
                                    fn_ar_sale_invoice     c,
                                    fn_ar_sale_invoice_dtl d,
                                    st_mate_out_dtl        e,
                                    com_materiel_info      f,
                                    view_com_materieltype  g,
                                    view_com_materieltype  g2,
                                    fn_vouchererp          h
                              where t.account_code = '6402.01.01.01'
                                and t.id = b.id
                                and b.id = e.main_id
                                and b.customer_id = a.id
                                and a.is_internal = '1'
                                and c.id = d.main_id
                                and d.source_dtl_id = e.id
                                and d.product_code = f.materiel_code
                                and g.all_code =
                                    solar_scm_qa.f_get_com_materieltype_secode(f.materieltype_id)
                                and g2.all_code =
                                    solar_scm_qa.f_get_com_materieltype_code(f.materieltype_id)
                                and g2.materieltype_code != '11'
                                and h.sourceid = c.id
                                and c.status = 2000
                                and h.status = 2000
                             union all
                             select '单晶硅片',
                                    '通威太阳能（合肥）有限公司',
                                    '通威太阳能（成都）有限公司',
                                    'PCS',
                                    13793,
                                    '03452C3942BE4D04A79CA4CFFEA8EC2D',
                                    '8A4FEA73281C8073E0530100007F578A',
                                    '8A06C196412841359439ED1E22566B69',
                                    '2020-03'
                               from dual) a
                      group by a.organ_name,
                               a.companyname,
                               a.materieltype_name,
                               a.unit_cname,
                               a.yearmonth,
                               a.organ_id,
                               a.mainid,
                               a.id) b
            on a.type_id = b.type_id
           and a.organ_id = b.organ_id
           and a.cus_id = b.cus_id
           and a.unit_cname = b.unit_cname
           and a.yearmonth = b.yearmonth) tt
 where tt.itemname in ('单晶电池A级', '多晶电池A级', '单晶硅片', '多晶硅片')
   and tt.cus_id = '${cusId}'
   and tt.yearmonth >= nvl('${beginDate}', tt.yearmonth)
   and tt.yearmonth <= nvl('${endDate}', tt.yearmonth)
 group by tt.organ_name, tt.itemname
 order by tt.organ_name, tt.itemname

select v.companyname company_aside,
       d.materiel_type,
       nvl(sum(d.income), 0) income,
       nvl(sum(d.cost), 0) cost,
       decode(nvl(sum(d.income), 0),
              0,
              0,
              (sum(d.income) - nvl(sum(d.cost), 0)) / sum(d.income)) rate
  from fn_insider_dealing m, fn_insider_dealing_dtl d,com_grp_party v
 where m.id = d.main_id
   and m.organ_id = '${organId}'
   and m.period_code >= nvl('${beginDate}', m.period_code)
   and m.period_code <= nvl('${endDate}', m.period_code)
   and d.company_id = v.id
 group by v.companyname, d.materiel_type
 order by v.companyname, d.materiel_type

