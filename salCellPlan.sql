/*一个集体子公司的客户，同一按照一个集团分组汇总*/
select t.customer_name,
       t.business_person_name,
       t.product_name,
       t.model_name,
       t.efficiency,
       t.key
  from (select t.month,
               nvl(h.id, d.customer_id) as customer_id,
               nvl(h.companyname, d.customer_name) as customer_name,
               d.business_person_name,
               t.product_kind,
               v.name as product_name,
               d.model_id,
               d.model_name,
               d.efficiency,
               nvl(h.id, d.customer_id) || '_' || d.business_person_id ||
               t.product_kind || '_' || d.model_id || '_' || d.efficiency as key
          from sal_cell_plan t,
               sal_cell_plan_dtl d,
               v_sa_dictionary v,
               (select h1.mainid, h2.id, h2.companyname
                  from view_customer h1, com_grp_party h2
                 where h1.parent_customer = h2.id
                 group by h1.mainid, h2.id, h2.companyname) h
         where t.id = d.main_id
           and v.code = 'productKind'
           and v.value = t.product_kind
           and d.customer_id = h.mainid(+)
           and t.status >= 1000
           and t.month = to_date('${month}', 'yyyy-mm')
         ${fullCode}) t
         where 1=1
         ${customerCode} -- 客户
         ${modelCode} -- 产品型号
         ${efficiencyCode} -- 转换效率
         ${productKindCode} --产品分类
 group by t.customer_name,
          t.business_person_name,
          t.product_name,
          t.model_name,
          t.efficiency,
          t.key


SELECT TO_CHAR(FDATE, 'DD')||'日' day
  FROM (SELECT TRUNC(to_date('${month}','yyyy-mm'), 'MONTH') + LEVEL - 1 AS FDATE
          FROM DUAL
        CONNECT BY LEVEL <= 31) T
 WHERE TO_CHAR(FDATE, 'MM') = TO_CHAR(to_date('${month}','yyyy-mm'), 'MM')

select tt.key, tt.month_day, nvl(sum(tt.allot_qty), 0) as allot_qty
  from (select nvl(h.id, d.customer_id) || '_' || d.business_person_id ||
               t.product_kind || '_' || d.model_id || '_' || d.efficiency as key,
               t.month_day,
               d.allot_qty
          from sal_cell_plan t,
               sal_cell_plan_dtl d,
               (select h1.mainid, h2.id, h2.companyname
                  from view_customer h1, com_grp_party h2
                 where h1.parent_customer = h2.id
                 group by h1.mainid, h2.id, h2.companyname) h
         where t.id = d.main_id
           and t.status >= 1000
           and d.customer_id = h.mainid(+)
           and t.kind = 2
           and t.month = to_date('${month}', 'yyyy-mm')) tt
 group by tt.key, tt.month_day


select tt.key, nvl(sum(tt.qty), 0) as qty
  from (select nvl(f.id, h.mainid) || '_' || salesman_id || '2' || '_' ||
               d.model_id || '_' || d.efficiency_name as key,
               d.qty
          from st_cell_out t,
               st_cell_out_dtl d,
               view_customer h,
               sal_cell_delivery_notice n,
               sal_cell_order o,
               (select h1.mainid, h2.id, h2.companyname
                  from view_customer h1, com_grp_party h2
                 where h1.parent_customer = h2.id
                 group by h1.mainid, h2.id, h2.companyname) f
         where t.id = d.main_id
           and t.customer_id = h.id
           and h.mainid = f.mainid(+)
           and t.source_id = n.id
           and n.CELL_ORDER_ID = o.id
           and t.status = 2000
           and d.materiel_code like '11.10.%' -- 多晶
           and t.fillin_date >= to_date('2020-04', 'yyyy-mm')
           and t.fillin_date < ADD_MONTHS(to_date('2020-04', 'yyyy-mm'), 1)
        union all
        select nvl(f.id, h.mainid) || '_' || salesman_id || '1' || '_' ||
               d.model_id || '_' || d.efficiency_name as key,
               d.qty
          from st_cell_out t,
               st_cell_out_dtl d,
               view_customer h,
               sal_cell_delivery_notice n,
               sal_cell_order o,
               (select h1.mainid, h2.id, h2.companyname
                  from view_customer h1, com_grp_party h2
                 where h1.parent_customer = h2.id
                 group by h1.mainid, h2.id, h2.companyname) f
         where t.id = d.main_id
           and t.customer_id = h.id
           and h.mainid = f.mainid(+)
           and t.source_id = n.id
           and n.CELL_ORDER_ID = o.id
           and t.status = 2000
           and d.materiel_code like '11.11.%' -- 单晶
           and t.fillin_date >= to_date('2020-04', 'yyyy-mm')
           and t.fillin_date < ADD_MONTHS(to_date('2020-04', 'yyyy-mm'), 1)) tt
 group by  tt.key
 
 


select nvl(sum(allot_qty), 0) as allot_qty, tt.key
  from (select d.allot_qty,
               nvl(h.id, d.customer_id) || '_' || d.business_person_id ||
               t.product_kind || '_' || d.model_id || '_' || d.efficiency as key
          from sal_cell_plan t,
               sal_cell_plan_dtl d,
               v_sa_dictionary v,
               (select h1.mainid, h2.id, h2.companyname
                  from view_customer h1, com_grp_party h2
                 where h1.parent_customer = h2.id
                 group by h1.mainid, h2.id, h2.companyname) h
         where t.id = d.main_id
           and v.code = 'productKind'
           and v.value = t.product_kind
           and d.customer_id = h.mainid(+)
           and t.status >= 1000
           and t.kind = 1
           and t.month = to_date('${month}', 'yyyy-mm')) tt
 group by tt.key

