/*
取工资计算关闭状态的数据，
1、用工性质只含合同工；-》employtype=2
2、如果班次为行政班，出勤率等于100%，且履职系数为1；如果班次为两班倒，出勤率在范围之内（90%--100%），且履职系数为1；
3、只取1-9职等。-》t.duty BETWEEN '1' AND '9'

20200720需求更改：
取消岗位列；不管行政班还是倒班，出勤率都要求100%，履职系数1
*/
select t.*
  from (
        
        select tc.dpt_type,
                t.ad_dept_name dept_name,
                t.duty,
                --2020-07-20取消岗位列 t.station,
                --人数
                count(1) as num,
                --职位薪酬 = （1）非班长、组长、资深组长，职位薪酬=正式职位薪酬；（2）班长、组长、资深组长，职位薪酬=正式职位薪酬+职务津贴
                sum(CASE
                      WHEN t.station in ('1101', '912', '231') THEN
                       nvl(t.station_salary, 0) + nvl(t.job_allowance, 0)
                      ELSE
                       t.station_salary
                    END) as sum_station_salary,
                --津贴 = 职务津贴（班长、组长、资深组长不取）；岗位技能津贴station_base_pay  +高温津贴high_temperature_allowance +内训师津贴internal_trainer_allowance +安全员津贴safety_officer_subsidy +工会委员津贴trade_union_member 
                sum(CASE
                      WHEN t.station in ('1101', '912', '231') THEN
                       0
                      ELSE
                       nvl(station_base_pay, 0) +
                       nvl(t.high_temperature_allowance, 0) +
                       nvl(t.internal_trainer_allowance, 0) +
                       nvl(t.safety_officer_subsidy, 0) +
                       nvl(t.trade_union_member, 0)
                    END) as sum_allowance,
                --奖金 = 安全奖励safety_reward +TQM奖金tqm_bonus +内部推荐奖励internal_recommendation_award +专项奖金new_project_bonus +招标奖金bidding_bonus +营销奖金marketing_bonus +降本激励奖金reduction_incentive_bonus +日常奖励award +绩效奖金performance_bonus 
                sum(nvl(t.safety_reward, 0) + nvl(t.tqm_bonus, 0) +
                    nvl(t.internal_recommendation_award, 0) +
                    nvl(t.new_project_bonus, 0) + nvl(t.bidding_bonus, 0) +
                    nvl(t.marketing_bonus, 0) +
                    nvl(t.reduction_incentive_bonus, 0) + nvl(t.award, 0) +
                    nvl(t.performance_bonus, 0)) as sum_bonus,
                --餐补
                sum(t.meal_allowance) as sum_meal_allowance,
                --加班工资
                sum(t.overtime) as sum_overtime,
                --应付工资
                sum(t.taxable_pay) as sum_taxable_pay,
                --职位薪酬: 最大值 最小值 中位值 平均值 (如果是（1）非班长、组长、资深组长，职位薪酬=正式职位薪酬；（2）班长、组长、资深组长，职位薪酬=正式职位薪酬+职务津贴)
                max(CASE
                      WHEN t.station in ('1101', '912', '231') THEN
                       nvl(t.station_salary, 0) + nvl(t.job_allowance, 0)
                      ELSE
                       t.station_salary
                    END) as max_station_salary,
                
                min(CASE
                      WHEN t.station in ('1101', '912', '231') THEN
                       nvl(t.station_salary, 0) + nvl(t.job_allowance, 0)
                      ELSE
                       t.station_salary
                    END) as min_station_salary,
                
                median(CASE
                         WHEN t.station in ('1101', '912', '231') THEN
                          nvl(t.station_salary, 0) + nvl(t.job_allowance, 0)
                         ELSE
                          t.station_salary
                       END) as med_station_salary,
                
                round(avg(CASE
                            WHEN t.station in ('1101', '912', '231') THEN
                             nvl(t.station_salary, 0) + nvl(t.job_allowance, 0)
                            ELSE
                             t.station_salary
                          END),
                      2) as avg_station_salary,
                --应付工资: 最大值 最小值 中位值 平均值   
                max(t.taxable_pay) as max_taxable_pay,
                min(t.taxable_pay) as min_taxable_pay,
                median(t.taxable_pay) as med_taxable_pay,
                round(avg(t.taxable_pay), 2) as avg_taxable_pay
          from (select pc.*,
                        nvl(pa.ad_dept_id, pc.dept_id) ad_dept_id,
                        nvl(pa.ad_organ_id, pc.organ_id) ad_organ_id,
                        nvl(pa.ad_dept_name, pc.dept_name) ad_dept_name
                   from view_hr_pay_master_close_own pc,
                        (select a.period_id,
                                ad.archive_id,
                                oo.id         ad_dept_id,
                                oo.name       ad_dept_name,
                                oo.org_id         ad_organ_id
                           from hr_pay_sal_stats_adjust     a,
                                hr_pay_sal_stats_adjust_dtl ad,
                                sa_oporg                    oo
                          where a.id = ad.main_id
                            and ad.adjusted_dept_id = oo.id
                            and a.status = 2000) pa
                  where pc.period_id = pa.period_id(+)
                    and pc.archive_id = pa.archive_id(+)) t,
                view_hr_operation_period p,
                hr_pay_report_dept_cfg tc,
                view_hr_month_att_summary m, --排班信息
                view_attendance_work_rate attrate, --出勤率履职系数
                VIEW_COM_ORG_BELONG_BASE bb --基地归属配置  
         WHERE 1 = 1
           and t.period_id = p.id
           and t.ad_dept_id = tc.dept_id
              --关联排班
           and t.archive_id = m.archive_id(+)
           and t.period_id = m.period_id(+)
           and t.pay_kind = m.period_kind(+)
              --关联排出勤率履职系数
           and t.archive_id = attrate.archive_id
           and attrate.report_type = 1 --月度
           and to_date(attrate.yearmonth || '-01', 'yyyy-mm-dd') between
               p.BEGIN_DATE and p.end_DATE
              --基地归属配置
           and t.ad_organ_id = bb.org_id
              --其他
           and t.pay_kind = 'salary'
           and p.pay_kind = 'salary'
           AND t.employ_type = '2' --1、用工性质只含合同工employtype=2
           AND t.duty BETWEEN '1' AND '9' --3、只取1-9职等
              --20200720 改不管行政班还是倒班  出勤率100% 履职系数1
           and attrate.attendance_rate = 100
           and attrate.work_coefficient = 1
        --行政班，出勤率等于100%履职系数为1  or 两班倒，出勤率在范围之内（90%--100%）履职系数为1
        --     and
        --     ( 
        --     (m.IS_CHANGE_SHIFTS = 0 and attrate.attendance_rate=100 and attrate.work_coefficient=1) or
        --     (m.IS_CHANGE_SHIFTS = 1 and attrate.attendance_rate between 90 and 100 and attrate.work_coefficient=1)    
        --     )
        
        ${if(len(organId)==0,"","and bb.id ='"+organId+"'")}
        
        ${if(len(periodDate)==0,"","and to_date('"+periodDate+"'||'-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE")}
        
        ${if(len(duty)==0,"","and t.duty in (select * from table(split('"+duty+"')))")}
        
        ${if(len(dptType)==0,"","and tc.dpt_type in (select * from table(split('"+dptType+"')))")}
         
        ${if(len(deptId)==0,"","and t.ad_dept_id in (select * from table(split('"+deptId+"')))")}
        
        --2020-07-20取消岗位列${if(len(station)==0,"","and t.station in (select * from table(split('"+station+"')))")}         
         GROUP BY tc.dpt_type, t.ad_dept_name, t.duty --2020-07-20取消岗位列,
        --2020-07-20取消岗位列t.station
        
        ) t
 where 1 = 1

 order by t.dpt_type, t.dept_name, t.duty


select value,name from v_sa_dictionary where code = 'dptType'

select value,name from v_sa_dictionary where code = 'station'

