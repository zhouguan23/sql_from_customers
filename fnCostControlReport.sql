select t.itemid, t.shortname, t.id, t.full_id
  from (select a.itemid, h.shortname, k.cost_id as id, g.full_id
          from fn_erp_balance t,
               fn_itemdetailv    a,
               com_fnorg         h,
               fn_org_cost       k,
               sa_oporg          g
         where (to_date(t.yearmonth, 'yyyy-mm') between
               to_date('${yearmonthBegin}', 'yyyy-mm') and
               to_date('${yearmonthEnd}', 'yyyy-mm'))
           and t.organ_id = '${organId}'
           and t.itemdtlid = a.itemdtlid
           and a.itemid = h.id
           and h.id = k.cost_id
           and k.org_id = g.id
           and g.org_id = '${organId}'
           and g.status = 1
           and g.id not in (select f2.dept_id
                              from fn_cost_subject_config     f1,
                                   fn_cost_subject_config_dtl f2
                             where f1.id = f2.main_id
                               and f1.config_type = 1 -- 费用管控
                               and f1.type in (2, 3) -- 2:融合部门 3: 排除部门
                               and f1.status = 1
            union all
                            select f1.dept_id
                              from fn_cost_subject_config f1
                             where f1.config_type = 1 -- 费用管控
                              and f1.type = 2 -- 2:融合部门 3: 排除部门
                               and f1.status = 1)
        
         group by a.itemid, h.shortname, k.cost_id, g.full_id) t
 where 1 = 1 ${fullcode}
union all
select t.itemid, t.shortname, t.id, t.full_id
  FROM (select h.cost_id as itemid,
               k.name    as shortname,
               k.cost_id as id,
               g.full_id
          from fn_erp_balance t,
               fn_itemdetailv a,
               (SELECT f.cost_id, f.dept_id, f.organ_id, f.name
                  FROM (select f3.cost_id, f1.dept_id, f1.organ_id, f1.name
                          from fn_cost_subject_config         f1,
                               fn_cost_subject_config_dtl     f2,
                               fn_cost_subject_config_dtl_dtl f3
                         where f1.id = f2.main_id
                           and f2.id = f3.main_id
                           and f1.config_type = 1 -- 费用管控
                           and f1.type = 2 --2:融合部门,排除部门
                           and f1.status = 1
                        union all
                        select f3.cost_id, f1.dept_id, f1.organ_id, f1.name
                          from fn_cost_subject_config     f1,
                               fn_cost_subject_config_dtl f2,
                               fn_org_cost                f3
                         where f1.id = f2.main_id
                           and f2.dept_id = f3.org_id
                           and f1.config_type = 1 -- 费用管控
                           and f1.type = 2 --2:融合部门,排除部门
                           and f1.status = 1) f
                 group by f.cost_id, f.dept_id, f.organ_id, f.name) k,
               sa_oporg g,
               fn_org_cost h
         where (to_date(t.yearmonth, 'yyyy-mm') between
               to_date('${yearmonthBegin}', 'yyyy-mm') and
               to_date('${yearmonthEnd}', 'yyyy-mm'))
           and t.itemdtlid = a.itemdtlid
           and a.itemid = k.cost_id
           and h.org_id = k.dept_id
           and k.dept_id = g.id
           and k.organ_id = '${organId}'
         group by h.cost_id, k.name, k.cost_id, g.id, g.full_id) t
         where 1 = 1 ${fullcode}

select a.itemid as itemid,
       k.code,
       nvl(sum(t.monthdebittotal), 0) as monthdebittotal
  from fn_erp_balance          t,
       fn_itemdetailv             a,
       fn_cost_subject_config     k,
       fn_cost_subject_config_dtl k1
 where t.itemdtlid = a.itemdtlid
   and t.currencyid = '0' -- 综合本位币
   and (to_date(t.yearmonth, 'yyyy-mm') between
       to_date('${yearmonthBegin}', 'yyyy-mm') and
       to_date('${yearmonthEnd}', 'yyyy-mm'))
   and t.organ_id = '${organId}'
   and k.id = k1.main_id
   and k.config_type = '1'
   and k.status = '1'
   and k.type = '1' -- 借
   and t.accountid = k1.account_id
   and t.organ_id = '${organId}'
   and not exists (SELECT *
          FROM (select f3.cost_id, f2.organ_id
                  from fn_cost_subject_config         f1,
                       fn_cost_subject_config_dtl     f2,
                       fn_cost_subject_config_dtl_dtl f3
                 where f1.id = f2.main_id
                   and f2.id = f3.main_id
                   and f1.config_type = 1 -- 费用管控
                   and f1.type in (2, 3) --2:融合部门,排除部门
                   and f1.status = 1
                union all
                select f3.cost_id, f2.organ_id
                  from fn_cost_subject_config     f1,
                       fn_cost_subject_config_dtl f2,
                       fn_org_cost                f3
                 where f1.id = f2.main_id
                   and f2.dept_id = f3.org_id
                   and f1.config_type = 1 -- 费用管控
                   and f1.type in (2, 3) --2:融合部门,排除部门
                   and f1.status = 1) g
         where g.cost_id = a.itemid
           and g.organ_id = '${organId}')
 group by a.itemid, k.code

union all
SELECT t1.cost_id as itemid,
       t2.code,
       nvl(sum(t2.monthdebittotal), 0) as monthdebittotal
  FROM (SELECT t.dept_cost_id, t.organ_id, t.cost_id
          FROM (select f3.cost_id as dept_cost_id, f3.organ_id, f4.cost_id
                  from fn_cost_subject_config         f1,
                       fn_cost_subject_config_dtl     f2,
                       fn_cost_subject_config_dtl_dtl f3,
                       fn_org_cost                    f4
                 where f1.id = f2.main_id
                   and f1.organ_id = '${organId}'
                   and f1.dept_id = f4.org_id
                   and f2.id = f3.main_id
                   and f1.config_type = 1 -- 费用管控
                   and f1.type in (2) --2:融合部门
                   and f1.status = 1
                union all
                select f3.cost_id as dept_cost_id, f2.organ_id, f4.cost_id
                  from fn_cost_subject_config     f1,
                       fn_cost_subject_config_dtl f2,
                       fn_org_cost                f3,
                       fn_org_cost                f4
                 where f1.id = f2.main_id
                   and f1.organ_id = '${organId}'
                   and f1.dept_id = f4.org_id
                   and f2.dept_id = f3.org_id
                   and f1.config_type = 1 -- 费用管控
                   and f1.type in (2) --2:融合部门
                   and f1.status = 1) t
         group by t.dept_cost_id, t.organ_id, t.cost_id) t1,
       (select a.itemid as itemid,
               k.code,
               t.organ_id,
               nvl(sum(t.monthdebittotal), 0) as monthdebittotal
          from fn_erp_balance          t,
               fn_itemdetailv             a,
               fn_cost_subject_config     k,
               fn_cost_subject_config_dtl k1
         where t.itemdtlid = a.itemdtlid
           and t.currencyid = '0' -- 综合本位币
           and (to_date(t.yearmonth, 'yyyy-mm') between
               to_date('${yearmonthBegin}', 'yyyy-mm') and
               to_date('${yearmonthEnd}', 'yyyy-mm'))
           and k.id = k1.main_id
           and k.config_type = '1'
           and k.status = '1'
           and k.type = '1' -- 借
           and t.accountid = k1.account_id
         group by a.itemid, k.code, t.organ_id) t2
 where t1.dept_cost_id = t2.itemid
   and t1.organ_id = t2.organ_id
 group by t1.cost_id, t2.code

select h.cost_id, nvl(sum(t.per_month_budget), 0) as target_value
  from fn_budget_temp t, fn_org_cost h
 where t.merge_belong_dept_id = h.org_id
   and (to_date(t.budget_month, 'yyyy-mm') between
       to_date('${yearmonthBegin}', 'yyyy-mm') and
       to_date('${yearmonthEnd}', 'yyyy-mm'))
   and t.organ_id = '${organId}'
 group by h.cost_id

select t.code, t.name
  from fn_cost_subject_config t
 where t.status = 1
 and t.config_type = 1 -- 费用管控
 and t.type = 1
 order by t.code

