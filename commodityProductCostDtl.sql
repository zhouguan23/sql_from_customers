select t.organ_id,
       t.organ_name,
       t.product_category_name,
       t.finance_category_name || '_' || t.pdt_type_name as pdt_name,
       sum(t.normal_w) as normal_w,
       sum(t.normal_yl) as normal_yl,
       sum(t.normal_fl) as normal_fl,
       sum(t.normal_bz) as normal_bz,
       sum(t.normal_rl) as normal_rl,
       sum(t.normal_rg) as normal_rg,
       sum(t.normal_zj) as normal_zj,
       sum(t.normal_zz) as normal_zz,
       sum(t.normal_amount) as normal_amount
  from fn_cost_pdt_in t
 where 1 = 1
   and (t.normal_bz != 0 or t.normal_rg != 0)
   and t.organ_id = '${organId}'
   and (t.year_month_v between '${yearmonthB}' and '${yearmonthE}')
 group by t.organ_id,
          t.organ_name,
          t.product_category_name,
          t.finance_category_name,
          t.pdt_type_name
 order by t.product_category_name

