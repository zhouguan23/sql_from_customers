SELECT A.ID         LEVEL1_ID,
       A.TITLE_NAME LEVEL1_NAME,
       B.ID         LEVEL2_ID,
       B.TITLE_NAME LEVEL2_NAME,
       B.DEPT_SET_IDS_STR
  FROM (SELECT T.*
          FROM FN_COST_REPORT_CONFIG T
         WHERE T.TYPE = '4' --环境
           AND T.TITLE_LEVEL = 1
           AND T.ORGAN_ID = '${theOrg}') A
  LEFT JOIN (SELECT T.*
               FROM FN_COST_REPORT_CONFIG T
              WHERE T.TYPE = '4' -- 环境
                AND T.TITLE_LEVEL = 2
                AND T.ORGAN_ID = '${theOrg}') B
    ON A.ID = B.PARENT_ID
 ORDER BY A.SEQUENCE, B.SEQUENCE


SELECT TO_CHAR(T.BIZ_DATE, 'yyyy-mm-dd') BIZ_DATE, A.*
  FROM FN_COST_UTILITY T
  LEFT JOIN FN_COST_UTILITY_DTL A
    ON T.ID = A.MAIN_ID
 WHERE T.STATUS = 2000
   AND T.TYPE = '4' -- 环境
   AND T.biz_organ_id = '${theOrg}'
   AND T.BIZ_DATE between to_date('${beginDate}', 'yyyy-mm-dd') and
       to_date('${endDate}', 'yyyy-mm-dd')

select *
  from sa_oporg t
 where t.org_kind_id = 'ogn'
   and t.parent_id = (select a.id from sa_oporg a where a.code = '1005')

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
           and t.organ_id = '${theOrg}'
         group by t.prod_dept_id, t.prod_date)

SELECT TO_CHAR(T.BIZ_DATE, 'yyyy-mm-dd') BIZ_DATE, A.*
  FROM FN_COST_UTILITY T
  LEFT JOIN FN_COST_UTILITY_DTL A
    ON T.ID = A.MAIN_ID
 WHERE T.STATUS = 2000
   AND T.TYPE = '4' -- 环境
   AND T.biz_organ_id = '${theOrg}'
   AND T.BIZ_DATE BETWEEN TO_DATE('${beginDate}', 'yyyy-mm-dd') AND TO_DATE('${endDate}', 'yyyy-mm-dd')
   order by biz_date desc

