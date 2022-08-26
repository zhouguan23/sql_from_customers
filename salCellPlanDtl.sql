select tt.remark, tt.customer_name
  from (select d.customer_name,
               t.bill_code || ';' || t.remark || ';' || d.description as remark,
               nvl(h.id, d.customer_id) || '_' || d.business_person_id ||
               t.product_kind || '_' || d.model_id || '_' || d.efficiency as key
          from sal_cell_plan t,
               sal_cell_plan_dtl d,
               (select h1.mainid, h2.id, h2.companyname
                  from view_customer h1, com_grp_party h2
                 where h1.parent_customer = h2.id
                 group by h1.mainid, h2.id, h2.companyname) h
         where t.id = d.main_id
           and d.customer_id = h.mainid(+)
           and t.status >= 1000
           and t.month = to_date('${month}', 'yyyy-mm')
           and t.month_day = '${monthDay}') tt
 where tt.key = '${key}'

