SELECT A.ID         LEVEL1_ID,
       A.TITLE_NAME LEVEL1_NAME,
       B.ID         LEVEL2_ID,
       B.TITLE_NAME LEVEL2_NAME,
       B.DEPT_SET_IDS_STR
  FROM (SELECT T.*
          FROM FN_COST_REPORT_CONFIG T
         WHERE T.TYPE = '2' --电
           AND T.TITLE_LEVEL = 1
           AND T.ORGAN_ID = '${theOrg}') A
  LEFT JOIN (SELECT T.*
               FROM FN_COST_REPORT_CONFIG T
              WHERE T.TYPE = '2' -- 电
                AND T.TITLE_LEVEL = 2
                AND T.ORGAN_ID = '${theOrg}') B
    ON A.ID = B.PARENT_ID
 ORDER BY A.SEQUENCE, B.SEQUENCE


SELECT TO_CHAR(T.BIZ_DATE, 'yyyy-mm-dd') BIZ_DATE, A.*
  FROM FN_COST_UTILITY T
  LEFT JOIN FN_COST_UTILITY_DTL A
    ON T.ID = A.MAIN_ID
 WHERE T.STATUS = 2000
   AND T.TYPE = '2' -- 电
   AND T.ORGAN_ID = '${theOrg}'
   AND T.BIZ_DATE BETWEEN TRUNC(TO_DATE('${beginDate}', 'yyyy-mm-dd'), 'month') AND ADD_MONTHS(TRUNC(TO_DATE('${endDate}', 'yyyy-mm-dd'), 'month'), 1)

select *
  from sa_oporg t
 where t.org_kind_id = 'ogn'
   and t.parent_id = (select a.id from sa_oporg a where a.code = '1005')

select 
t.prod_dept_id,
to_char(t.prod_date, 'yyyy-mm-dd') prod_date,
sum(t.screen_printing_output) * 
sum(t.grade_a) / sum(
t.texturing_debris --制绒碎片
+ t.diffusion_debris --扩散碎片
+ t.laser_debris -- 激光se碎片
+ t.former_annealing_debris -- 前退火碎片
+ t.etching_debris -- 刻蚀/碱抛碎片
+ t.annealing_debris -- 退火碎片
+ t.back_passivation_debris --背钝化碎片
+ t.back_coating_debris -- 背镀膜碎片
+ t.pecvd_debris -- pecvd碎片
+ t.screen_printing_debris --丝网印刷碎片
+ t.test_debris -- 测试分选碎片
+ t.fqc_debris --fqc检验碎片
+ t.rework_debris -- 返工间碎片
+ t.grade_a -- 成品分级a
+ t.grade_s -- 成品分级s
+ t.grade_c -- 成品分级c
--+ t.grade_d -- 成品分级d
+ t.grade_ng -- 成品分级ng
+ t.grade_sy)  a_grade_num -- 成品分级sy
   from rpt_production t
   WHERE T.prod_date BETWEEN TRUNC(TO_DATE('${beginDate}', 'yyyy-mm-dd'), 'month') AND ADD_MONTHS(TRUNC(TO_DATE('${endDate}', 'yyyy-mm-dd'), 'month'), 1)
   AND T.ORGAN_ID = '${theOrg}'
   group by t.prod_dept_id,t.prod_date
  

