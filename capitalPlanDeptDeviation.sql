select *
  from (select o.org_name,
               o.dept_name,
               idx.rn,
               t.*,
               to_char(t.amount_count, 'FM999,999,999,999,990.00') as amount_count_text,
               to_char(t.plan_amount_count, 'FM999,999,999,999,990.00') as plan_amount_count_text,
               case t.item_name
                 when '净额' then
                  '<div style="background:rgb(255,255,0)">' ||
                  t.deviation_rate || '%</div>'
                 else
                  t.deviation_rate || '%'
               end as deviation_rate_text
          from view_cpl_dept_deviation t,
               sa_oporg o,
               (select t.full_id,
                       t.plan_month,
                       row_number() over(order by sum(decode(t.item_name, '净额', abs(t.deviation_rate), 0)) desc) rn
                  from view_cpl_dept_deviation t
                 group by t.full_id, t.plan_month) idx
         where t.full_id = o.full_id
           and t.full_id = idx.full_id
           and t.plan_month = idx.plan_month
           and exists (select 1
                  from view_cpl_dept_deviation tt
                 where tt.full_id = t.full_id
                   and tt.plan_month = t.plan_month
                   and tt.plan_amount_count != 0
                   and tt.item_name in ('支出', '收入'))
         order by decode(item_name, '收入', 1, '支出', 2, 3) asc) t
 where org_name = '${organName}'
   and plan_month = to_date('${planMonth}', 'YYYY-MM')

