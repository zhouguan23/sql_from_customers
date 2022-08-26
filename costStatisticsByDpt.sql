select t.account_code,
       t.account_name,
       t.organ_id,
       t.organ_name,
       t.currencyid,
       decode(substr(t.yearmonth, -2, 2),
              '12',
              substr(t.yearmonth, -2, 2),
              '11',
              substr(t.yearmonth, -2, 2),
              substr(t.yearmonth, -1, 1)) || '月' as yearmonth,
       f.account_year,
       n.id as cost_id,
       n.shortname,
       sum(nvl(t.monthdebittotal, 0)) monthdebittotal
  from fn_erp_balance        t,
       v_fn_accountinfo_new  v,
       fn_itemdetailv        i,
       com_fnorg             n,
       fn_account_period     f,
       fn_account_period_dtl d,
       fn_accountbook_org fao,
       fn_account_book fab
 where t.accountid = v.account_id
   and t.organ_id = v.organ_id
   and t.yearmonth = d.period_code(+)
   and f.id = d.main_id
   and t.organ_id = fao.organ_id
   and fao.accountbook_id = fab.id
   and f.period_type_id = fab.account_period_type_id 
   and t.itemdtlid = i.itemdtlid
   and i.itemid = n.id
   and v.child_num = 0
   and d.is_settle_account = '1'
   and (t.account_code like '6601%' or t.account_code like '6602%' or
       t.account_code like '5101%' or t.account_code like '5301%')
   and t.organ_id = '${organId}'
   and f.account_year = '${accountYear}'
   and t.currencyid = '${currencyid}'
   ${if(len(costId)==0,"","and n.id in (select * from table(split('"+costId+"')))")}
   ${if(len(accountName)==0,"","and t.account_name = '"+accountName+"'")}
 group by t.account_code,
          t.account_name,
          t.organ_id,
          t.organ_name,
          t.currencyid,
          t.yearmonth,
          f.account_year,
          n.id,
          n.shortname
 order by t.account_code


