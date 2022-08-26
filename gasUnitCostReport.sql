select prod_dept_id,
       prod_date,
       decode(total, 0, 0, grade_a / total) a_grade_num
  from (select t.prod_dept_id,
               to_char(t.prod_date, 'yyyy-mm-dd') prod_date,
               nvl(sum(t.screen_printing_output), 0) *
               nvl(sum(t.grade_a), 0) grade_a,
               sum(nvl(rework_debris, 0) + nvl(texturing_debris, 0) +
                   nvl(diffusion_debris, 0) + nvl(laser_debris, 0) +
                   nvl(former_annealing_debris, 0) + nvl(etching_debris, 0) +
                   nvl(annealing_debris, 0) +
                   nvl(back_passivation_debris, 0) +
                   nvl(back_coating_debris, 0) + nvl(pecvd_debris, 0) +
                   nvl(screen_printing_debris, 0) + nvl(test_debris, 0) +
                   nvl(fqc_debris, 0) + nvl(grade_a, 0) + nvl(grade_s, 0) +
                   nvl(grade_c, 0) + nvl(grade_sy, 0) + nvl(grade_ng, 0)) total
          from rpt_production t
         where t.prod_date between to_date('${beginDate}', 'yyyy-mm-dd') and
               to_date('${endDate}', 'yyyy-mm-dd')
           and t.organ_id = '${organId}'
         group by t.prod_dept_id, t.prod_date)

select prod_dept_id, trunc(tt.prod_date, 'mm') prod_month, sum(a_grade_num) a_grade_num
  from (select prod_dept_id,
               prod_date,
               decode(total, 0, 0, grade_a / total) a_grade_num
          from (select t.prod_dept_id,
                       t.prod_date,
                       nvl(sum(t.screen_printing_output), 0) *
                       nvl(sum(t.grade_a), 0) grade_a,
                       sum(nvl(rework_debris, 0) + nvl(texturing_debris, 0) +
                           nvl(diffusion_debris, 0) + nvl(laser_debris, 0) +
                           nvl(former_annealing_debris, 0) +
                           nvl(etching_debris, 0) + nvl(annealing_debris, 0) +
                           nvl(back_passivation_debris, 0) +
                           nvl(back_coating_debris, 0) + nvl(pecvd_debris, 0) +
                           nvl(screen_printing_debris, 0) +
                           nvl(test_debris, 0) + nvl(fqc_debris, 0) +
                           nvl(grade_a, 0) + nvl(grade_s, 0) +
                           nvl(grade_c, 0) + nvl(grade_sy, 0) +
                           nvl(grade_ng, 0)) total
                  from rpt_production t
                 where t.prod_date >=
                       trunc(to_date('${beginDate}', 'yyyy-mm-dd'), 'mm')
                   and t.prod_date <
                       add_months(trunc(to_date('${endDate}', 'yyyy-mm-dd'),
                                        'mm'),
                                  1)
                   and t.organ_id = '${organId}'
                 group by t.prod_dept_id, t.prod_date)) tt
 group by tt.prod_dept_id, trunc(tt.prod_date, 'mm')

select tt.prod_dept_id,
       to_char(trunc(tt.prod_date + 2, 'd') - 2, 'yyyy/mm/dd') || '-' ||
       to_char(trunc(tt.prod_date + 2, 'd') + 4, 'yyyy/mm/dd') prod_week,
       sum(tt.a_grade_num) a_grade_num
  from (select prod_dept_id,
               prod_date,
               decode(total, 0, 0, grade_a / total) a_grade_num
          from (select t.prod_dept_id,
                       t.prod_date,
                       nvl(sum(t.screen_printing_output), 0) *
                       nvl(sum(t.grade_a), 0) grade_a,
                       sum(nvl(rework_debris, 0) + nvl(texturing_debris, 0) +
                           nvl(diffusion_debris, 0) + nvl(laser_debris, 0) +
                           nvl(former_annealing_debris, 0) +
                           nvl(etching_debris, 0) + nvl(annealing_debris, 0) +
                           nvl(back_passivation_debris, 0) +
                           nvl(back_coating_debris, 0) + nvl(pecvd_debris, 0) +
                           nvl(screen_printing_debris, 0) +
                           nvl(test_debris, 0) + nvl(fqc_debris, 0) +
                           nvl(grade_a, 0) + nvl(grade_s, 0) +
                           nvl(grade_c, 0) + nvl(grade_sy, 0) +
                           nvl(grade_ng, 0)) total
                  from rpt_production t
                 where t.prod_date >=
                       trunc(to_date('${beginDate}', 'yyyy-mm-dd') + 2, 'd') - 2
                   and t.prod_date <=
                       trunc(to_date('${endDate}', 'yyyy-mm-dd') + 2, 'd') + 4
                   and t.organ_id = '${organId}'
                 group by t.prod_dept_id, t.prod_date)) tt
 group by tt.prod_dept_id,
          to_char(trunc(tt.prod_date + 2, 'd') - 2, 'yyyy/mm/dd') || '-' ||
          to_char(trunc(tt.prod_date + 2, 'd') + 4, 'yyyy/mm/dd')

select a.id               level1_id,
       a.title_name       level1_name,
       b.id               level2_id,
       b.title_name       level2_name,
       c.id               level3_id,
       c.title_name       level3_name,
       c.dept_set_ids_str
  from (select t.*
          from fn_cost_report_config t
         where t.type = '3' -- 气
           and t.title_level = 1
           and t.organ_id = '${organId}') a
  left join (select t.*
               from fn_cost_report_config t
              where t.type = '3' -- 气
                and t.title_level = 2
                and t.organ_id = '${organId}') b
    on a.id = b.parent_id
  left join (select t.*
               from fn_cost_report_config t
              where t.type = '3' -- 气
                and t.title_level = 3
                and t.organ_id = '${organId}') c
    on b.id = c.parent_id
 order by a.sequence, b.sequence

select to_char(m.biz_date, 'yyyy-mm-dd') biz_date,
       d.full_data_id,
       d.full_data_name,
       d.value
  from fn_cost_utility m, fn_cost_utility_dtl d
 where m.id = d.main_id
   and m.status = 2000
   and m.type = '3' -- 气
   and m.biz_organ_id = '${organId}'
   and m.biz_date between to_date('${beginDate}', 'yyyy-mm-dd') and
       to_date('${endDate}', 'yyyy-mm-dd')
 order by biz_date desc

select trunc(m.biz_date, 'mm') biz_month,
       d.full_data_id,
       d.full_data_name,
       sum(d.value) value
  from fn_cost_utility m, fn_cost_utility_dtl d
 where m.id = d.main_id
   and m.status = 2000
   and m.type = '3' -- 气
   and m.biz_organ_id = '${organId}'
   and m.biz_date >= trunc(to_date('${beginDate}', 'yyyy-mm-dd'), 'mm')
   and m.biz_date <
       add_months(trunc(to_date('${endDate}', 'yyyy-mm-dd'), 'mm'), 1)
 group by d.full_data_id, d.full_data_name, trunc(m.biz_date, 'mm')
 order by trunc(m.biz_date, 'mm') desc

select to_char(trunc(m.biz_date + 2, 'd') - 2, 'yyyy/mm/dd') || '-' ||
       to_char(trunc(m.biz_date + 2, 'd') + 4, 'yyyy/mm/dd') biz_week,
       d.full_data_id,
       d.full_data_name,
       sum(d.value) value
  from fn_cost_utility m, fn_cost_utility_dtl d
 where m.id = d.main_id
   and m.status = 2000
   and m.type = '3' -- 气
   and m.biz_organ_id = '${organId}'
   and m.biz_date >=
       trunc(to_date('${beginDate}', 'yyyy-mm-dd') + 2, 'd') - 2
   and m.biz_date <=
       trunc(to_date('${endDate}', 'yyyy-mm-dd') + 2, 'd') + 4
 group by d.full_data_id,
          d.full_data_name,
          to_char(trunc(m.biz_date + 2, 'd') - 2, 'yyyy/mm/dd') || '-' ||
          to_char(trunc(m.biz_date + 2, 'd') + 4, 'yyyy/mm/dd')
 order by to_char(trunc(m.biz_date + 2, 'd') - 2, 'yyyy/mm/dd') || '-' ||
          to_char(trunc(m.biz_date + 2, 'd') + 4, 'yyyy/mm/dd') desc

