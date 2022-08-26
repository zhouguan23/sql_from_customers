select sum(cdwatt)  cdwatt,
       sum(hfwatt)  hfwatt,
       sum(ahwatt)  ahwatt,
       sum(cddxwatt)  cddxwatt,
       sum(hfdxwatt)  hfdxwatt,
       sum(ahdxwatt)  ahdxwatt,
       sum(cdtaxamount)cdtaxamount,
       sum(hftaxamount)hftaxamount,
       sum(ahtaxamount) ahtaxamount,
       sum(cddxtaxamount)cddxtaxamount,
       sum(hfdxtaxamount)hfdxtaxamount,
       sum(ahdxtaxamount) ahdxtaxamount,
       sum(cdamount) cdamount,
       sum(hfamount)  hfamount,
       sum(ahamount)  ahamount
  from (select sum(decode(g.code, '1007', t.watt, null)) cdwatt,
               sum(decode(g.code, '1015', t.watt, null)) hfwatt,
               sum(decode(g.code, '1016', t.watt, null)) ahwatt,
               sum(decode(g.code, '1007', decode(s.code,'52',t.watt, null))) cddxwatt,
               sum(decode(g.code, '1015', decode(s.code,'52',t.watt, null))) hfdxwatt,
               sum(decode(g.code, '1016', decode(s.code,'52',t.watt, null))) ahdxwatt,
                sum(decode(g.code, '1007', t.tax_amount)) cdtaxamount,
               sum(decode(g.code, '1015', t.tax_amount)) hftaxamount,
               sum(decode(g.code, '1016', t.tax_amount)) ahtaxamount,
               sum(decode(g.code, '1007', decode(s.code,'52',t.tax_amount,''))) cddxtaxamount,
               sum(decode(g.code, '1015', decode(s.code,'52',t.tax_amount,''))) hfdxtaxamount,
               sum(decode(g.code, '1016', decode(s.code,'52',t.tax_amount,''))) ahdxtaxamount,
               sum(decode(g.code, '1007',decode(t.trade_type,1, t.tax_amount/1.13,t.tax_amount))) cdamount,
               sum(decode(g.code, '1015', decode(t.trade_type,1, t.tax_amount/1.13,t.tax_amount))) hfamount,
               sum(decode(g.code, '1016', decode(t.trade_type,1, t.tax_amount/1.13,t.tax_amount))) ahamount
          from view_cell_sale_fn_statistics t, sa_oporg g,st_storage s
         where 1=1
             ${if(len(starttime)=0,""," and trunc(t.account_day)>=to_date('"+starttime+"','yyyy-mm-dd')")}
   ${if(len(endtime)=0,"","  and trunc(t.account_day)<=to_date('"+endtime+"','yyyy-mm-dd')")}
           and t.grade_id=1
           and s.code!='52'
           and t.organ_id = g.id
           and t.storage_id=s.id
         group by g.code)

select sum(cdwatt)  cdwatt,
       sum(hfwatt)  hfwatt,
       sum(ahwatt)  ahwatt,
       sum(cddxwatt)  cddxwatt,
       sum(hfdxwatt)  hfdxwatt,
       sum(ahdxwatt)  ahdxwatt,
       sum(cdtaxamount)cdtaxamount,
       sum(hftaxamount)hftaxamount,
       sum(ahtaxamount) ahtaxamount,
       sum(cddxtaxamount)cddxtaxamount,
       sum(hfdxtaxamount)hfdxtaxamount,
       sum(ahdxtaxamount) ahdxtaxamount,
       sum(cdamount) cdamount,
       sum(hfamount)  hfamount,
       sum(ahamount)  ahamount
  from (select sum(decode(g.code, '1007', t.watt, null)) cdwatt,
               sum(decode(g.code, '1015', t.watt, null)) hfwatt,
               sum(decode(g.code, '1016', t.watt, null)) ahwatt,
               sum(decode(g.code, '1007', decode(s.code,'52',t.watt, null))) cddxwatt,
               sum(decode(g.code, '1015', decode(s.code,'52',t.watt, null))) hfdxwatt,
               sum(decode(g.code, '1016', decode(s.code,'52',t.watt, null))) ahdxwatt,
                sum(decode(g.code, '1007', t.tax_amount)) cdtaxamount,
               sum(decode(g.code, '1015', t.tax_amount)) hftaxamount,
               sum(decode(g.code, '1016', t.tax_amount)) ahtaxamount,
               sum(decode(g.code, '1007', decode(s.code,'52',t.tax_amount,''))) cddxtaxamount,
               sum(decode(g.code, '1015', decode(s.code,'52',t.tax_amount,''))) hfdxtaxamount,
               sum(decode(g.code, '1016', decode(s.code,'52',t.tax_amount,''))) ahdxtaxamount,
                sum(decode(g.code, '1007',decode(t.trade_type,1, t.tax_amount/1.13,t.tax_amount))) cdamount,
               sum(decode(g.code, '1015', decode(t.trade_type,1, t.tax_amount/1.13,t.tax_amount))) hfamount,
               sum(decode(g.code, '1016', decode(t.trade_type,1, t.tax_amount/1.13,t.tax_amount))) ahamount
          from view_cell_sale_fn_statistics t, sa_oporg g,st_storage s
         where 1=1
             ${if(len(endtime)=0,""," and trunc(t.account_day)>=trunc(to_date('"+endtime+"','yyyy-mm-dd'),'mm')")}
   ${if(len(endtime)=0,"","  and trunc(t.account_day)<=to_date('"+endtime+"','yyyy-mm-dd')")}
           and t.grade_id=1
           and s.code!='52'
           and t.organ_id = g.id
           and t.storage_id=s.id
         group by g.code)

select   sum(decode(g.code, '1015', t.watt, null)) hfwatt,
            sum(decode(g.code, '1015', decode(t.trade_type_id,1,t.TAX_AMOUNT,2,t.TAX_AMOUNT*1.13, null))) hfamout,
            sum(decode(g.code, '1015', decode(instr(t.materiel_name, '单晶'),0,null,decode(instr(t.materiel_name,'叠瓦'),0,null,t.watt)),null))hfitwatt,
            sum(decode(g.code, '1015', decode(instr(t.materiel_name, '单晶'),0,null,decode(instr(t.materiel_name,'叠瓦'),0,t.watt,null)),null))hfsiwatt,
            sum(decode(g.code, '1015', decode(instr(t.materiel_name, '多晶'),0,null,t.watt),null))hfpowatt
          from view_module_sale_fn_statistics t, sa_oporg g
         where 1=1
          ${if(len(starttime)=0,""," and trunc(t.account_day)>=to_date('"+starttime+"','yyyy-mm-dd')")}
          ${if(len(endtime)=0,"","  and trunc(t.account_day)<=to_date('"+endtime+"','yyyy-mm-dd')")}
           and t.organ_id = g.id
           and (t.storage_name like '%成品仓' or t.storage_name like '%代工仓%')
           and t.storage_name!='组件研发成品仓'
           and t.grade_id=1
         group by g.code

select sum(decode(g.code, '1015', t.watt, null)) hfwatt,
            sum(decode(g.code, '1015', decode(t.trade_type_id,1,t.TAX_AMOUNT,2,t.TAX_AMOUNT*1.13, null))) hfamout,
            sum(decode(g.code, '1015', decode(instr(t.materiel_name, '单晶'),0,null,decode(instr(t.materiel_name,'叠瓦'),0,null,t.watt)),null))hfitwatt,
            sum(decode(g.code, '1015', decode(instr(t.materiel_name, '单晶'),0,null,decode(instr(t.materiel_name,'叠瓦'),0,t.watt,null)),null))hfsiwatt,
            sum(decode(g.code, '1015', decode(instr(t.materiel_name, '多晶'),0,null,t.watt),null))hfpowatt
          from view_module_sale_fn_statistics t, sa_oporg g
         where 1=1
         ${if(len(endtime)=0,""," and trunc(t.account_day)>=trunc(to_date('"+endtime+"','yyyy-mm-dd'),'mm')")}
   ${if(len(endtime)=0,"","  and trunc(t.account_day)<=to_date('"+endtime+"','yyyy-mm-dd')")}
           and t.grade_id=1
           and (t.storage_name like '%成品仓' or t.storage_name like '%代工仓%')
           and t.storage_name!='组件研发成品仓'
           and t.organ_id = g.id
         group by g.code

select  sum(decode(g.code, '1007', d.tax_amount, null))/sum(decode(g.code, '1007', d.qty, null)) cdprice,
       sum(decode(g.code, '1015', d.tax_amount, null))/sum(decode(g.code, '1015', d.qty, null)) hfprice,
       sum(decode(g.code, '1016', d.tax_amount, null))/sum(decode(g.code, '1016', d.qty, null)) ahprice
  from st_mate_in                 t,
       st_mate_in_dtl             d,
       view_com_materiel_all_info m,
       com_materieltype           k,
       st_storage                 s,
       sa_oporg                   g
 where t.id = d.main_id
   and d.materiel_id = m.id
   and m.materieltype_id = k.id
   and k.parentid in ('8A06C196412841359439ED1E22566B69',
                      '4F49C11C069140D4B06669F6C4714A42',
                       '213F80661E714EF7AFF34BC4BF734AC4')
   and t.storage_id = s.id
   and s.storage_attr = 1
   and d.qty is not null
   and t.organ_id = g.id
    ${if(len(starttime)=0,""," and trunc(d.fn_date)>=to_date('"+starttime+"','yyyy-mm-dd')")}
   ${if(len(endtime)=0,"","  and trunc(d.fn_date)<=to_date('"+endtime+"','yyyy-mm-dd')")}


select  sum(decode(g.code, '1007', d.tax_amount, null))/sum(decode(g.code, '1007', d.qty, null)) cdprice,
       sum(decode(g.code, '1015', d.tax_amount, null))/sum(decode(g.code, '1015', d.qty, null)) hfprice,
       sum(decode(g.code, '1016', d.tax_amount, null))/sum(decode(g.code, '1016', d.qty, null)) ahprice
  from st_mate_in                 t,
       st_mate_in_dtl             d,
       view_com_materiel_all_info m,
       com_materieltype           k,
       st_storage                 s,
       sa_oporg                   g
 where t.id = d.main_id
   and d.materiel_id = m.id
   and m.materieltype_id = k.id
   and k.parentid in ('8A06C196412841359439ED1E22566B69',
                      '4F49C11C069140D4B06669F6C4714A42',
                       '213F80661E714EF7AFF34BC4BF734AC4')
   and t.storage_id = s.id
   and s.storage_attr = 1
   and t.organ_id = g.id
   and d.qty is not null
    ${if(len(endtime)=0,""," and trunc(d.fn_date)>=trunc(to_date('"+endtime+"','yyyy-mm-dd'),'mm')")}
   ${if(len(endtime)=0,"","  and trunc(d.fn_date)<=to_date('"+endtime+"','yyyy-mm-dd')")}


select sum(decode(g.code, '1007', t.priortotal, null)) cdamount,
       sum(decode(g.code, '1015', t.priortotal, null)) hfamount,
       sum(decode(g.code, '1016', t.priortotal, null)) ahamount
  from fn_erp_balance t, sa_oporg g
 where t.account_code = '1406.01.01'
   and t.yearmonth = substr('${endtime}',0,7)
   and t.currencyid = 0
   and t.organ_id = g.id

select sum(decode(g.code, '1007', d.qty, null)) cdqty,
       sum(decode(g.code, '1015', d.qty, null)) hfqty,
       sum(decode(g.code, '1016', d.qty, null)) ahqty,
       sum(decode(g.code, '1007', d.fn_amount, null)) cdamount,
       sum(decode(g.code, '1015', d.fn_amount, null)) hfamount,
       sum(decode(g.code, '1016', d.fn_amount, null)) ahamount
  from st_mate_out                t,
       st_mate_out_dtl            d,
       view_com_materiel_all_info m,
       com_materieltype           k,
       st_operation_type          s,
       sa_oporg                   g
 where t.id = d.main_id
   and d.materiel_id = m.id
   and m.materieltype_id = k.id(+)
   and k.parentid in ('8A06C196412841359439ED1E22566B69',
                      '4F49C11C069140D4B06669F6C4714A42',
                       '213F80661E714EF7AFF34BC4BF734AC4')
    ${if(len(starttime)=0,""," and trunc(t.fillin_date)>=to_date('"+starttime+"','yyyy-mm-dd')")}
   ${if(len(endtime)=0,"","  and trunc(t.fillin_date)<=to_date('"+endtime+"','yyyy-mm-dd')")}
   and t.operation_type_id = s.id
   and s.business_code = 11
   and t.organ_id = g.id
   and t.status >= 1000


select sum(decode(g.code, '1007', d.qty, null)) cdqty,
       sum(decode(g.code, '1015', d.qty, null)) hfqty,
       sum(decode(g.code, '1016', d.qty, null)) ahqty,
       sum(decode(g.code, '1007', d.fn_amount, null)) cdamount,
       sum(decode(g.code, '1015', d.fn_amount, null)) hfamount,
       sum(decode(g.code, '1016', d.fn_amount, null)) ahamount
  from st_mate_out                t,
       st_mate_out_dtl            d,
       view_com_materiel_all_info m,
       com_materieltype           k,
       st_operation_type          s,
       sa_oporg                   g
 where t.id = d.main_id
   and d.materiel_id = m.id
   and m.materieltype_id = k.id(+)
   and k.parentid in ('8A06C196412841359439ED1E22566B69',
                      '4F49C11C069140D4B06669F6C4714A42',
                       '213F80661E714EF7AFF34BC4BF734AC4')
   ${if(len(endtime)=0,""," and trunc(t.fillin_date)>=trunc(to_date('"+endtime+"','yyyy-mm-dd'),'mm')")}
   ${if(len(endtime)=0,"","  and trunc(t.fillin_date)<=to_date('"+endtime+"','yyyy-mm-dd')")}
   and t.operation_type_id = s.id
   and s.business_code = 11
   and t.organ_id = g.id
   and t.status >= 1000


select sum(decode(g.code, '1007', d.qty, null)) cdqty,
       sum(decode(g.code, '1015', d.qty, null)) hfqty,
       sum(decode(g.code, '1016', d.qty, null)) ahqty,
       sum(decode(g.code, '1007', d.watt, null)) cdwatt,
       sum(decode(g.code, '1015', d.watt, null)) hfwatt,
       sum(decode(g.code, '1016', d.watt, null)) ahwatt
  from st_cell_in t, st_cell_in_dtl d, sa_oporg g, st_operation_type s
 where t.id = d.main_id
   ${if(len(starttime)=0,""," and trunc(t.fillin_date)>=to_date('"+starttime+"','yyyy-mm-dd')")}
   ${if(len(endtime)=0,"","  and trunc(t.fillin_date)<=to_date('"+endtime+"','yyyy-mm-dd')")}
   and t.organ_id = g.id
   and t.operation_type_id = s.id
   and s.business_code in (3, 30)
   and d.grade_id = 1

select sum(decode(g.code, '1007', d.qty, null)) cdqty,
       sum(decode(g.code, '1015', d.qty, null)) hfqty,
       sum(decode(g.code, '1016', d.qty, null)) ahqty,
       sum(decode(g.code, '1007', d.watt, null)) cdwatt,
       sum(decode(g.code, '1015', d.watt, null)) hfwatt,
       sum(decode(g.code, '1016', d.watt, null)) ahwatt
  from st_cell_in t, st_cell_in_dtl d, sa_oporg g, st_operation_type s
 where t.id = d.main_id
   ${if(len(endtime)=0,""," and trunc(t.fillin_date)>=trunc(to_date('"+endtime+"','yyyy-mm-dd'),'mm')")}
   ${if(len(endtime)=0,"","  and trunc(t.fillin_date)<=to_date('"+endtime+"','yyyy-mm-dd')")}
   and t.organ_id = g.id
   and t.operation_type_id = s.id
   and s.business_code in (3, 30)
   and d.grade_id = 1

select sum(decode(t.organ_code, '1007', t.non_silicon_cost, null)) cdnon_silicon_cost,     
       sum(decode(t.organ_code, '1015', t.non_silicon_cost, null))  hfnon_silicon_cost,
       sum(decode(t.organ_code, '1016', t.non_silicon_cost, null))  ahnon_silicon_cost,
       sum(decode(t.organ_code, '1007', t.a_rate, null))  cda_rate,
       sum(decode(t.organ_code, '1015', t.a_rate, null))  hfa_rate,
       sum(decode(t.organ_code, '1016', t.a_rate, null))  aha_rate,
       sum(decode(t.organ_code, '1015', t.sc_cost, null))  hfsc_cost,
       sum(decode(t.organ_code, '1015', t.po_cost, null))  hfpo_cost,
       sum(decode(t.organ_code, '1015', t.it_cost, null))  hfit_cost,
       sum(decode(t.organ_code, '1007', solar_fn.f_get_weekly_month_amount(to_date('${endtime}','yyyy-mm-dd'),'1007',1), null)) cdperiod_cost_month, 
       sum(decode(t.organ_code, '1007', solar_fn.f_get_weekly_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',1), null))  cdperiod_cost,
       sum(decode(t.organ_code, '1007', solar_fn.f_get_weekly_month_amount(to_date('${endtime}','yyyy-mm-dd'),'1015',1), null)) hfperiod_cost_month, 
       sum(decode(t.organ_code, '1015', solar_fn.f_get_weekly_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',1), null))  hfperiod_cost,
       sum(decode(t.organ_code, '1007', solar_fn.f_get_weekly_month_amount(to_date('${endtime}','yyyy-mm-dd'),'1016',1), null)) ahperiod_cost_month, 
       sum(decode(t.organ_code, '1016', solar_fn.f_get_weekly_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',1), null)) ahperiod_cost,
       sum(decode(t.organ_code, '1007', solar_fn.f_get_weekly_month_amount(to_date('${endtime}','yyyy-mm-dd'),'1007',2), null)) cdother_income_month, 
       sum(decode(t.organ_code, '1007', solar_fn.f_get_weekly_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',2), null)) cdother_income,
        sum(decode(t.organ_code, '1007', solar_fn.f_get_weekly_month_amount(to_date('${endtime}','yyyy-mm-dd'),'1015',2), null)) hfother_income_month, 
       sum(decode(t.organ_code, '1015', solar_fn.f_get_weekly_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',2), null))  hfother_income,
        sum(decode(t.organ_code, '1007', solar_fn.f_get_weekly_month_amount(to_date('${endtime}','yyyy-mm-dd'),'1016',2), null)) ahother_income_month, 
       sum(decode(t.organ_code, '1016', solar_fn.f_get_weekly_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',2), null))   ahother_income
  from fn_weekly_profit t
 where  1=1
   ${if(len(endtime)=0,""," and t.yearmonth=trunc(to_date('"+endtime+"','yyyy-mm-dd'),'mm')")}

select sum(decode(t.organ_code, '1007', t.non_silicon_cost, null)) cdnon_silicon_cost,
       sum(decode(t.organ_code, '1015', t.non_silicon_cost, null)) hfnon_silicon_cost,
       sum(decode(t.organ_code, '1016', t.non_silicon_cost, null)) ahnon_silicon_cost,
       avg(decode(t.organ_code, '1007', t.a_rate, null)) cda_rate,
       avg(decode(t.organ_code, '1015', t.a_rate, null)) hfa_rate,
       avg(decode(t.organ_code, '1016', t.a_rate, null)) aha_rate,
       sum(decode(t.organ_code, '1007', t.period_cost, null)) cdperiod_cost,
       sum(decode(t.organ_code, '1015', t.period_cost, null)) hfperiod_cost,
       sum(decode(t.organ_code, '1016', t.period_cost, null)) ahperiod_cost,
       sum(decode(t.organ_code, '1007', t.other_income, null)) cdother_income,
       sum(decode(t.organ_code, '1015', t.period_cost, null)) hfother_income,
       sum(decode(t.organ_code, '1016', t.period_cost, null)) ahother_income,
       sum(decode(t.organ_code, '1007', t.start_cell_amount, null)) cdstart_cell_amount,
       sum(decode(t.organ_code, '1015', t.start_cell_amount, null)) hfstart_cell_amount,
       sum(decode(t.organ_code, '1016', t.start_cell_amount, null)) ahstart_cell_amount,
       sum(decode(t.organ_code, '1007', t.start_cell_qty, null)) cdstart_cell_qty,
       sum(decode(t.organ_code, '1015', t.start_cell_qty, null)) hfstart_cell_qty,
       sum(decode(t.organ_code, '1016', t.start_cell_qty, null)) ahstart_cell_qty,
       sum(decode(t.organ_code, '1007', t.start_module_amount, null)) cdstart_module_amount,
       sum(decode(t.organ_code, '1015', t.start_module_amount, null)) hfstart_module_amount,
       sum(decode(t.organ_code, '1016', t.start_module_amount, null)) ahstart_module_amount,
       sum(decode(t.organ_code, '1007', t.start_module_qty, null)) cdstart_module_qty,
       sum(decode(t.organ_code, '1015', t.start_module_qty, null)) hfstart_module_qty,
       sum(decode(t.organ_code, '1016', t.start_module_qty, null)) ahstart_module_qty
  from fn_weekly_profit t
 where  1=1
 ${if(len(endtime)=0,""," and t.yearmonth=trunc(to_date('"+endtime+"','yyyy-mm-dd'),'mm')")}



select sum(cdtaxamount) cdtaxamount,
       sum(hftaxamount) hftaxamount,
       sum(ahtaxamount) ahtaxamount,
       sum(cdamount) cdamount,
       sum(hfamount) hfamount,
       sum(ahamount) ahamount
  from (select sum(decode(g.code, '1007', t.tax_amount)) cdtaxamount,
               sum(decode(g.code, '1015', t.tax_amount)) hftaxamount,
               sum(decode(g.code, '1016', t.tax_amount)) ahtaxamount,
               sum(decode(g.code, '1007', t.tax_amount)) cdamount,
               sum(decode(g.code, '1015', t.tax_amount)) hfamount,
               sum(decode(g.code, '1016', t.tax_amount)) ahamount
          from view_cell_sale_fn_statistics t, sa_oporg g
         where 1=1
             ${if(len(starttime)=0,""," and trunc(t.account_day)>=to_date('"+starttime+"','yyyy-mm-dd')")}
   ${if(len(endtime)=0,"","  and trunc(t.account_day)<=to_date('"+endtime+"','yyyy-mm-dd')")}
           and t.grade_id!=1
           and t.organ_id = g.id
         group by g.code)

select sum(cdtaxamount) cdtaxamount,
       sum(hftaxamount) hftaxamount,
       sum(ahtaxamount) ahtaxamount,
       sum(cdamount) cdamount,
       sum(hfamount) hfamount,
       sum(ahamount) ahamount
  from (select sum(decode(g.code, '1007', t.tax_amount)) cdtaxamount,
               sum(decode(g.code, '1015', t.tax_amount)) hftaxamount,
               sum(decode(g.code, '1016', t.tax_amount)) ahtaxamount,
               sum(decode(g.code, '1007', t.tax_amount)) cdamount,
               sum(decode(g.code, '1015', t.tax_amount)) hfamount,
               sum(decode(g.code, '1016', t.tax_amount)) ahamount
          from view_cell_sale_fn_statistics t, sa_oporg g
         where 1=1
             ${if(len(endtime)=0,""," and trunc(t.account_day)>=trunc(to_date('"+endtime+"','yyyy-mm-dd'),'mm')")}
   ${if(len(endtime)=0,"","  and trunc(t.account_day)<=to_date('"+endtime+"','yyyy-mm-dd')")}
           and t.grade_id!=1
           and t.organ_id = g.id
         group by g.code)

select round(sum(decode(g.code, '1007', decode(d.project_id,1,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdsal,
       round(sum(decode(g.code, '1015', decode(d.project_id,1,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfsal,
       round(sum(decode(g.code, '1016', decode(d.project_id,1,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahsal,
       round(sum(decode(g.code, '1007', decode(d.project_id,2,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdcellsal,
       round(sum(decode(g.code, '1015', decode(d.project_id,2,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfcellsal,
       round(sum(decode(g.code, '1016', decode(d.project_id,2,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahcellsal,
       round(sum(decode(g.code, '1015', decode(d.project_id,3,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2)hfmodsal,
       round(sum(decode(g.code, '1007', decode(d.project_id,'4',d.plan_value, null))),2) cdsalprice,
       round(sum(decode(g.code, '1015', decode(d.project_id,'4',d.plan_value, null))),2) hfsalprice,
       round(sum(decode(g.code, '1016', decode(d.project_id,'4',d.plan_value, null))),2) ahsalprice,
       round(sum(decode(g.code, '1007', decode(d.project_id,'5',d.plan_value, null))),2) cdcellprice,
       round(sum(decode(g.code, '1015', decode(d.project_id,'5',d.plan_value, null))),2) hfcellprice,
       round(sum(decode(g.code, '1016', decode(d.project_id,'5',d.plan_value, null))),2) ahcellprice,
       round(sum(decode(g.code, '1015', decode(d.project_id,'6',d.plan_value, null))),2) hfmodprice,
       round(sum(decode(g.code, '1007', decode(d.project_id,'7',d.plan_value, null))),2) cdsibuyprice,
       round(sum(decode(g.code, '1015', decode(d.project_id,'7',d.plan_value, null))),2) hfsibuyprice,
       round(sum(decode(g.code, '1016', decode(d.project_id,'7',d.plan_value, null))),2) ahsibuyprice,
       round(sum(decode(g.code, '1007', decode(d.project_id,8,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdincome,
       round(sum(decode(g.code, '1015', decode(d.project_id,8,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfincome,
       round(sum(decode(g.code, '1016', decode(d.project_id,8,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahincome,
       round(sum(decode(g.code, '1007', decode(d.project_id,9,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdotherincome,
       round(sum(decode(g.code, '1015', decode(d.project_id,9,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfotherincome,
       round(sum(decode(g.code, '1016', decode(d.project_id,9,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahotherincome,
       round(sum(decode(g.code, '1007', decode(d.project_id,'10',d.plan_value, null))),2) cdnosicost,
       round(sum(decode(g.code, '1015', decode(d.project_id,'10',d.plan_value, null))),2) hfnosicost,
       round(sum(decode(g.code, '1016', decode(d.project_id,'10',d.plan_value, null))),2) ahnosicost,
       round(sum(decode(g.code, '1007', decode(d.project_id,11,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdcost,
       round(sum(decode(g.code, '1015', decode(d.project_id,11,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfcost,
       round(sum(decode(g.code, '1016', decode(d.project_id,11,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahcost,
       round(sum(decode(g.code, '1007', decode(d.project_id,12,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdprofit,
       round(sum(decode(g.code, '1015', decode(d.project_id,12,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfprofit,
       round(sum(decode(g.code, '1016', decode(d.project_id,12,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahprofit,
       round(sum(decode(g.code, '1007', decode(d.project_id,'13',d.plan_value, null))),2) cdmargin,
       round(sum(decode(g.code, '1015', decode(d.project_id,'13',d.plan_value, null))),2) hfmargin,
       round(sum(decode(g.code, '1016', decode(d.project_id,'13',d.plan_value, null))),2) ahmargin,
       round(sum(decode(g.code, '1007', decode(d.project_id,14,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdperiod,
       round(sum(decode(g.code, '1015', decode(d.project_id,14,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfperiod,
       round(sum(decode(g.code, '1016', decode(d.project_id,14,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahperiod,
       round(sum(decode(g.code, '1007', decode(d.project_id,15,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdother,
       round(sum(decode(g.code, '1015', decode(d.project_id,15,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfother,
       round(sum(decode(g.code, '1016', decode(d.project_id,15,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahother,
       round(sum(decode(g.code, '1007', decode(d.project_id,16,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdnetprofi,
       round(sum(decode(g.code, '1015', decode(d.project_id,16,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfnetprofi,
       round(sum(decode(g.code, '1016', decode(d.project_id,16,solar_fn.f_get_business_plan_amount(trunc(to_date('${endtime}','yyyy-mm-dd'),'mm'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahnetprofi
  from fn_business_plan t, fn_business_plan_dtl_pivot d ,sa_oporg g
where t.id=d.main_id
and t.yearmonth=substr('${endtime}',0,4)
and t.organ_id=g.id
and d.yearmonths=substr('${endtime}',0,7)

select round(sum(decode(g.code, '1007', decode(d.project_id,1,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdsal,
       round(sum(decode(g.code, '1015', decode(d.project_id,1,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfsal,
       round(sum(decode(g.code, '1016', decode(d.project_id,1,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahsal,
       round(sum(decode(g.code, '1007', decode(d.project_id,2,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdcellsal,
       round(sum(decode(g.code, '1015', decode(d.project_id,2,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfcellsal,
       round(sum(decode(g.code, '1016', decode(d.project_id,2,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahcellsal,
       round(sum(decode(g.code, '1015', decode(d.project_id,3,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2)hfmodsal,
       round(sum(decode(g.code, '1007', decode(d.project_id,'4',d.plan_value, null))),2) cdsalprice,
       round(sum(decode(g.code, '1015', decode(d.project_id,'4',d.plan_value, null))),2) hfsalprice,
       round(sum(decode(g.code, '1016', decode(d.project_id,'4',d.plan_value, null))),2) ahsalprice,
       round(sum(decode(g.code, '1007', decode(d.project_id,'5',d.plan_value, null))),2) cdcellprice,
       round(sum(decode(g.code, '1015', decode(d.project_id,'5',d.plan_value, null))),2) hfcellprice,
       round(sum(decode(g.code, '1016', decode(d.project_id,'5',d.plan_value, null))),2) ahcellprice,
       round(sum(decode(g.code, '1015', decode(d.project_id,'6',d.plan_value, null))),2) hfmodprice,
       round(sum(decode(g.code, '1007', decode(d.project_id,'7',d.plan_value, null))),2) cdsibuyprice,
       round(sum(decode(g.code, '1015', decode(d.project_id,'7',d.plan_value, null))),2) hfsibuyprice,
       round(sum(decode(g.code, '1016', decode(d.project_id,'7',d.plan_value, null))),2) ahsibuyprice,
       round(sum(decode(g.code, '1007', decode(d.project_id,8,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdincome,
       round(sum(decode(g.code, '1015', decode(d.project_id,8,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfincome,
       round(sum(decode(g.code, '1016', decode(d.project_id,8,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahincome,
       round(sum(decode(g.code, '1007', decode(d.project_id,9,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdotherincome,
       round(sum(decode(g.code, '1015', decode(d.project_id,9,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfotherincome,
       round(sum(decode(g.code, '1016', decode(d.project_id,9,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahotherincome,
       round(sum(decode(g.code, '1007', decode(d.project_id,'10',d.plan_value, null))),2) cdnosicost,
       round(sum(decode(g.code, '1015', decode(d.project_id,'10',d.plan_value, null))),2) hfnosicost,
       round(sum(decode(g.code, '1016', decode(d.project_id,'10',d.plan_value, null))),2) ahnosicost,
       round(sum(decode(g.code, '1007', decode(d.project_id,11,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdcost,
       round(sum(decode(g.code, '1015', decode(d.project_id,11,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfcost,
       round(sum(decode(g.code, '1016', decode(d.project_id,11,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahcost,
       round(sum(decode(g.code, '1007', decode(d.project_id,12,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdprofit,
       round(sum(decode(g.code, '1015', decode(d.project_id,12,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfprofit,
       round(sum(decode(g.code, '1016', decode(d.project_id,12,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahprofit,
       round(sum(decode(g.code, '1007', decode(d.project_id,'13',d.plan_value, null))),2) cdmargin,
       round(sum(decode(g.code, '1015', decode(d.project_id,'13',d.plan_value, null))),2) hfmargin,
       round(sum(decode(g.code, '1016', decode(d.project_id,'13',d.plan_value, null))),2) ahmargin,
       round(sum(decode(g.code, '1007', decode(d.project_id,14,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdperiod,
       round(sum(decode(g.code, '1015', decode(d.project_id,14,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfperiod,
       round(sum(decode(g.code, '1016', decode(d.project_id,14,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahperiod,
       round(sum(decode(g.code, '1007', decode(d.project_id,15,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdother,
       round(sum(decode(g.code, '1015', decode(d.project_id,15,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfother,
       round(sum(decode(g.code, '1016', decode(d.project_id,15,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahother,
       round(sum(decode(g.code, '1007', decode(d.project_id,16,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1007',d.project_id), null),null)),2) cdnetprofi,
       round(sum(decode(g.code, '1015', decode(d.project_id,16,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1015',d.project_id), null),null)),2) hfnetprofi,
       round(sum(decode(g.code, '1016', decode(d.project_id,16,solar_fn.f_get_business_plan_amount(to_date('${starttime}','yyyy-mm-dd'),to_date('${endtime}','yyyy-mm-dd'),'1016',d.project_id), null),null)),2) ahnetprofi
  from fn_business_plan t, fn_business_plan_dtl_pivot d ,sa_oporg g
where t.id=d.main_id
and t.yearmonth=substr('${endtime}',0,4)
and t.organ_id=g.id
and d.yearmonths=substr('${endtime}',0,7)

select   sum(decode(g.code, '1015', decode(t.trade_type_id,1,t.TAX_AMOUNT,2,t.TAX_AMOUNT*1.13, null))) hfamout
          from view_module_sale_statistics t, sa_oporg g
         where 1=1
          ${if(len(starttime)=0,""," and trunc(t.fillin_date)>=to_date('"+starttime+"','yyyy-mm-dd')")}
          ${if(len(endtime)=0,"","  and trunc(t.fillin_date)<=to_date('"+endtime+"','yyyy-mm-dd')")}
           and t.organ_id = g.id
           and t.grade_id!=1
         group by g.code

select sum(decode(g.code, '1015', decode(t.trade_type_id,1,t.TAX_AMOUNT,2,t.TAX_AMOUNT*1.13, null))) hfamout
          from view_module_sale_statistics t, sa_oporg g
         where 1=1
         ${if(len(endtime)=0,""," and trunc(t.fillin_date)>=trunc(to_date('"+endtime+"','yyyy-mm-dd'),'mm')")}
   ${if(len(endtime)=0,"","  and trunc(t.fillin_date)<=to_date('"+endtime+"','yyyy-mm-dd')")}
           and t.grade_id!=1
           and t.organ_id = g.id
         group by g.code

