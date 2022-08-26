select t.*,
       to_char(t.year_month, 'yyyy-mm') year_month_str,
       trim(to_char(decode(t.act_product,
                           null,
                           null,
                           0,
                           null,
                           round(t.labor_cost / t.act_product, 4)),
                    '999999990.9999')) unit_labor_cost
  from hr_report_act_labor_cost t
 where t.org_kind in ('PRODUCT', 'SINGLE-CELL', 'MULTI-CELL', 'MODULE')
--基地
${if(len(orgName)==0,"","and t.org_name like '%"+orgName+"%'")}
--年月
 ${if(len(year)==0,"","and t.year_month between trunc(to_date('"+year+"', 'yyyy'), 'yyyy') and add_months(trunc(to_date('"+year+"', 'yyyy'), 'yyyy'), 12) - 1")}
--年份
 ${if(len(yearMonth)==0,"","and t.year_month= to_date('"+yearMonth+"', 'yyyy-mm' )")}
 order by t.year_month asc, t.full_sequence asc

select bo.ogn_id,
       bo.ogn_name,
       bo.id dept_id,
       bo.name dept_name,
       bo.full_sequence,
       t.year_month,
       to_char(t.year_month, 'yyyy-mm') year_month_str,
       sum(labourcost) as labour_cost,
       count(0) as emp_qty
  from (select nvl(p.target_dept_id, b.ad_dept_id) as dept_id,
               o.begin_date year_month,
               nvl(b.taxable_pay, 0) + nvl(b.taxable_pay, 0) * 0.02 +
               nvl(b.unit_total, 0) + nvl(b.pension_unit_benefit, 0) +
               nvl(b.medical_unit_insurance, 0) +
               nvl(b.unemployment_unit_insurance, 0) +
               nvl(b.injury_unit_insurance, 0) +
               nvl(b.birth_unit_insurance, 0) + nvl(b.medical_assistance, 0) as labourcost
          from (select pm.*,
                       nvl(pa.ad_dept_id, pm.dept_id) ad_dept_id,
                       nvl(pa.ad_dept_name, pm.dept_name) ad_dept_name
                  from hr_pay_master pm,
                       (select a.period_id,
                               ad.archive_id,
                               oo.id         ad_dept_id,
                               oo.name       ad_dept_name
                          from hr_pay_sal_stats_adjust     a,
                               hr_pay_sal_stats_adjust_dtl ad,
                               sa_oporg                    oo
                         where a.id = ad.main_id
                           and ad.adjusted_dept_id = oo.id
                           and a.status = 2000) pa
                 where pm.archive_id = pa.archive_id(+)
                   and pm.period_id = pa.period_id(+)) b,               
               hr_pay_main              a,
               hr_sm_hcm_dept_ownership p,
               view_hr_operation_period o
         where a.compute_state = 2
           and a.id = b.main_id
           and a.pay_kind = 'salary'
           and b.period_id = o.id
           and o.pay_kind = 'salary'
           and b.ad_dept_id = p.source_dept_id(+)
           and a.year = ${year}) t,
       view_hr_base_org bo
 where t.dept_id = bo.org_id
--基地
${if(len(orgName)==0,"","and bo.ogn_name like '%"+orgName+"%'")}
--年月
${if(len(yearMonth)==0,"","and t.year_month= to_date('"+yearMonth+"', 'yyyy-mm' )")}
 group by bo.ogn_id,
          bo.ogn_name,
          bo.id,
          bo.name,
          bo.full_sequence,
          t.year_month
 order by year_month asc, full_sequence asc


select t.*,
       round(t.act_product * 0.000001, 2) act_product_mw,
       to_char(t.year_month, 'yyyy-mm') year_month_str,
       decode(t.act_product,
              null,
              null,
              0,
              null,
              round(t.labor_cost / t.act_product, 4)) unit_labor_cost
  from hr_report_act_labor_cost t
 where t.org_kind = 'PRODUCT'
--基地
 ${if(len(orgName)==0,"","and t.org_name like '%"+orgName+"%'")}
--年月
 ${if(len(yearMonth)==0,"","and t.year_month= to_date('"+yearMonth+"', 'yyyy-mm' )")}
--年份
 ${if(len(year)==0,"","and t.year_month between trunc(to_date('"+year+"', 'yyyy'), 'yyyy') and add_months(trunc(to_date('"+year+"', 'yyyy'), 'yyyy'), 12) - 1")}
 order by t.year_month asc, t.full_sequence asc

select t.*,
       round(t.act_product * 0.000001, 2) act_product_mw,
       to_char(t.year_month, 'yyyy-mm') year_month_str,
       decode(emp_qty, null, null, 0, null, round(act_product / emp_qty * 0.000001, 2)) person_product,
       decode(act_product,
              null,
              null,
              0,
              null,
              round(labor_cost / act_product, 3)) unit_labor_cost
  from hr_report_act_labor_cost t
 where t.org_kind = upper('multi-cost')
--基地
 ${ if(len(orgName)==0,"","and t.org_name like '%"+orgName+"%'")}
--年月
 ${if(len(yearMonth)==0,"","and t.year_month= to_date('"+yearMonth+"', 'yyyy-mm' )")}
--年份
 ${if(len(year)==0,"","and t.year_month between trunc(to_date('"+year+"', 'yyyy'), 'yyyy') and add_months(trunc(to_date('"+year+"', 'yyyy'), 'yyyy'), 12) - 1")}
 order by t.year_month asc

select t.*,
       round(t.act_product * 0.000001, 2) act_product_mw,
       to_char(t.year_month, 'yyyy-mm') year_month_str,
       decode(emp_qty, null, null, 0, null, round(act_product / emp_qty * 0.000001, 2)) person_product,
       decode(act_product,
              null,
              null,
              0,
              null,
              round(labor_cost / act_product, 3)) unit_labor_cost
  from hr_report_act_labor_cost t
 where t.org_kind = upper('single-cost')
--基地
 ${if(len(orgName)==0,"","and t.org_name like '%"+orgName+"%'")}
--年月
 ${if(len(yearMonth)==0,"","and t.year_month= to_date('"+yearMonth+"', 'yyyy-mm' )")}
--年份
 ${if(len(year)==0,"","and t.year_month between trunc(to_date('"+year+"', 'yyyy'), 'yyyy') and add_months(trunc(to_date('"+year+"', 'yyyy'), 'yyyy'), 12) - 1")}
 order by t.year_month asc

select d.*,
       round(d.act_product * 0.000001, 2) act_product_mw,
       to_char(year_month, 'yyyy-mm') year_month_str,
       decode(emp_qty, null, null, 0, null, round(act_product / emp_qty * 0.000001, 2)) person_product,
       decode(act_product,
              null,
              null,
              0,
              null,
              round(labor_cost / act_product, 3)) unit_labor_cost
  from (select t.id,
               t.version,
               t.org_kind,
               t.year,
               t.year_month,
               t.org_id,
               t.org_name,
               t.dept_id,
               t.dept_name,
               t.full_sequence,
               nvl(t.labor_cost, 0) + nvl(t.ad_labor_cost, 0) labor_cost,
               nvl(t.emp_qty, 0) + nvl(t.ad_emp_qty, 0) emp_qty,
               t.act_product,
               t.workshop_type,
               t.materiel_type_id,
               t.materiel_type_name,
               t.all_code,
               t.ad_labor_cost,
               t.ad_emp_qty
          from hr_report_act_labor_cost t
         where t.org_kind = upper('multi-cost')
        --基地
         ${if(len(orgName)==0,"","and t.org_name like '%"+orgName+"%'")}
        --年月
         ${if(len(yearMonth)==0,"","and t.year_month= to_date('"+yearMonth+"', 'yyyy-mm' )")}
        --年份
         ${if(len(year)==0,"","and t.year_month between trunc(to_date('"+year+"', 'yyyy'), 'yyyy') and add_months(trunc(to_date('"+year+"', 'yyyy'), 'yyyy'), 12) - 1")}) d
 order by year_month asc

select d.*,
       round(d.act_product * 0.000001, 2) act_product_mw,
       to_char(year_month, 'yyyy-mm') year_month_str,
       decode(emp_qty, null, null, 0, null, round(act_product / emp_qty * 0.000001, 2)) person_product,
       decode(act_product,
              null,
              null,
              0,
              null,
              round(labor_cost / act_product, 3)) unit_labor_cost
  from (select t.id,
               t.version,
               t.org_kind,
               t.year,
               t.year_month,
               t.org_id,
               t.org_name,
               t.dept_id,
               t.dept_name,
               t.full_sequence,
               nvl(t.labor_cost, 0) + nvl(t.ad_labor_cost, 0) labor_cost,
               nvl(t.emp_qty, 0) + nvl(t.ad_emp_qty, 0) emp_qty,
               t.act_product,
               t.workshop_type,
               t.materiel_type_id,
               t.materiel_type_name,
               t.all_code,
               t.ad_labor_cost,
               t.ad_emp_qty
          from hr_report_act_labor_cost t
         where t.org_kind = upper('single-cost')
        --基地
         ${if(len(orgName)==0,"","and t.org_name like '%"+orgName+"%'")}
        --年月
         ${if(len(yearMonth)==0,"","and t.year_month= to_date('"+yearMonth+"', 'yyyy-mm' )")}
        --年份
         ${if(len(year)==0,"","and t.year_month between trunc(to_date('"+year+"', 'yyyy'), 'yyyy') and add_months(trunc(to_date('"+year+"', 'yyyy'), 'yyyy'), 12) - 1")}) d
 order by year_month asc

