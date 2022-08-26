select value,name from v_sa_dictionary where code = 'dptType'

select value,name from v_sa_dictionary where code = 'dptShortType'

select value,name from v_sa_dictionary where code = 'dutyRange'

select value,name from v_sa_dictionary where code = 'stationLevel'

select value,name from v_sa_dictionary where code = 'salaryExternalOrg'

/*
取工资计算关闭状态的数据：
1、用工性质只含合同工；-》employtype=2
2、取工资项“应付工资”的数；-》taxable_pay
3、如果班次为行政班，出勤率等于100%，且履职系数为1；如果班次为两班倒，出勤率在范围之内（90%--100%），且履职系数为1；
4、只取1-9职等。-》t.duty BETWEEN '1' AND '9'

20200720需求更改：
不管行政班还是倒班，出勤率都要求100%，履职系数1
*/
--整体：内部+外部
select ttt.* from (
--union内容

----================内部：公司/属性（人数）/部门类型/部门/职等范围/岗位等级/值
  SELECT 
    nvl(bb.name, t.organ_name) as group_name,--基地
		nvl(bb.sequence,100) group_sequence,
		1 property_sequence,				
    '人数' as property_name,
    tc.dpt_type,--部门类型
    tc.dpt_short_type,--部门
    zdfw.dic_dtl_value duty_range,--职等范围
    gwdj.station_level,--岗位等级
    count(1)||'' as property_val 
  FROM
    (select pc.*,
            nvl(pa.ad_dept_id, pc.dept_id) ad_dept_id,
            nvl(pa.ad_organ_id, pc.organ_id) ad_organ_id,
            nvl(pa.ad_dept_name, pc.dept_name) ad_dept_name
       from view_hr_pay_master_close_own pc,
            (select a.period_id,
                    ad.archive_id,
                    oo.id         ad_dept_id,
                    oo.name       ad_dept_name,
                    oo.org_id     ad_organ_id
               from hr_pay_sal_stats_adjust     a,
                    hr_pay_sal_stats_adjust_dtl ad,
                    sa_oporg                    oo
              where a.id = ad.main_id
                and ad.adjusted_dept_id = oo.id
                and a.status = 2000) pa
      where pc.period_id = pa.period_id(+)
        and pc.archive_id = pa.archive_id(+)) t ,
    view_hr_operation_period p,
    hr_pay_report_dept_cfg tc,--部门映射部门类型
    hr_pay_report_duty_slevel_cfg gwdj,--根据部门、职等范围可得到岗位等级
    HR_PAY_REPORT_LEVEL_DESCRIBE zdfw,--职等范围配置（属于哪个范围）
    view_hr_month_att_summary m, --排班信息
    view_attendance_work_rate attrate, --出勤率履职系数
		VIEW_COM_ORG_BELONG_BASE bb --基地归属配置
  WHERE
    1 = 1 
    and t.period_id = p.id    
    --部门映射部门类型
    and t.ad_dept_id = tc.dept_id 
    --岗位等级
    and tc.dpt_short_type = gwdj.dpt_short_type
    --职等范围
    and zdfw.dic_dtl_value = gwdj.duty_range
    and gwdj.cfg_kind = '1' --薪酬类型配置
    and to_number(t.duty) between to_number(zdfw.begin_duty) and to_number(zdfw.end_duty)
    --关联排班
    and t.archive_id = m.archive_id(+) 
    and t.period_id = m.period_id(+) 
    and t.pay_kind = m.period_kind(+)
    --关联排出勤率履职系数
    and t.archive_id = attrate.archive_id
    and attrate.report_type = 1 --月度
    and to_date(attrate.yearmonth || '-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE
		--基地归属配置
		and t.ad_organ_id = bb.org_id(+)
    --其他
    and t.pay_kind = 'salary' 
    and p.pay_kind = 'salary' 
    AND t.employ_type = '2' --1、用工性质只含合同工employtype=2
    AND t.duty BETWEEN '1' AND '9' --3、只取1-9职等
		--20200720 改不管行政班还是倒班  出勤率100% 履职系数1
		and attrate.attendance_rate=100 and attrate.work_coefficient=1
    --行政班，出勤率等于100%履职系数为1  or 两班倒，出勤率在范围之内（90%--100%）履职系数为1
		--     and
		--     ( 
		--     (m.IS_CHANGE_SHIFTS = 0 and attrate.attendance_rate=100 and attrate.work_coefficient=1) or
		--     (m.IS_CHANGE_SHIFTS = 1 and attrate.attendance_rate between 90 and 100 and attrate.work_coefficient=1)    
		--     )

    ${if(len(periodDate)==0,"","and to_date('"+periodDate+"'||'-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE")}

    ${if(len(dutyRange)==0,"","and zdfw.dic_dtl_value in (select * from table(split('"+dutyRange+"')))")}

    ${if(len(dptType)==0,"","and tc.dpt_type in (select * from table(split('"+dptType+"')))")}
     
    ${if(len(dptShortType)==0,"","and tc.dpt_short_type in (select * from table(split('"+dptShortType+"')))")}

    ${if(len(stationLevel)==0,"","and gwdj.station_level in (select * from table(split('"+stationLevel+"')))")}         
  GROUP BY
    tc.dpt_type,--部门类型
    tc.dpt_short_type,--部门
    zdfw.dic_dtl_value,--职等范围
    gwdj.station_level,--岗位等级
    nvl(bb.name, t.organ_name),--基地
		bb.sequence--基地序号
union all
----================内部：公司/属性（最大值）/部门类型/部门/职等范围/岗位等级/值

  SELECT 
    nvl(bb.name, t.organ_name) as group_name,--基地
		nvl(bb.sequence,100) group_sequence,
		2 property_sequence,				
    '最大值' as property_name,
    tc.dpt_type,--部门类型
    tc.dpt_short_type,--部门
    zdfw.dic_dtl_value duty_range,--职等范围
    gwdj.station_level,--岗位等级
    max(t.taxable_pay)||'' as property_val 
  FROM
    (select pc.*,
            nvl(pa.ad_dept_id, pc.dept_id) ad_dept_id,
            nvl(pa.ad_organ_id, pc.organ_id) ad_organ_id,
            nvl(pa.ad_dept_name, pc.dept_name) ad_dept_name
       from view_hr_pay_master_close_own pc,
            (select a.period_id,
                    ad.archive_id,
                    oo.id         ad_dept_id,
                    oo.name       ad_dept_name,
                    oo.org_id     ad_organ_id
               from hr_pay_sal_stats_adjust     a,
                    hr_pay_sal_stats_adjust_dtl ad,
                    sa_oporg                    oo
              where a.id = ad.main_id
                and ad.adjusted_dept_id = oo.id
                and a.status = 2000) pa
      where pc.period_id = pa.period_id(+)
        and pc.archive_id = pa.archive_id(+)) t ,
    view_hr_operation_period p,
    hr_pay_report_dept_cfg tc,--部门映射部门类型
    hr_pay_report_duty_slevel_cfg gwdj,--根据部门、职等范围可得到岗位等级
    HR_PAY_REPORT_LEVEL_DESCRIBE zdfw,--职等范围配置（属于哪个范围）
    view_hr_month_att_summary m, --排班信息
    view_attendance_work_rate attrate, --出勤率履职系数
		VIEW_COM_ORG_BELONG_BASE bb --基地归属配置
  WHERE
    1 = 1 
    and t.period_id = p.id    
    --部门映射部门类型
    and t.ad_dept_id = tc.dept_id 
    --岗位等级
    and tc.dpt_short_type = gwdj.dpt_short_type
    --职等范围
    and zdfw.dic_dtl_value = gwdj.duty_range
    and gwdj.cfg_kind = '1' --薪酬类型配置
    and to_number(t.duty) between to_number(zdfw.begin_duty) and to_number(zdfw.end_duty)
    --关联排班
    and t.archive_id = m.archive_id(+) 
    and t.period_id = m.period_id(+) 
    and t.pay_kind = m.period_kind(+)
    --关联排出勤率履职系数
    and t.archive_id = attrate.archive_id
    and attrate.report_type = 1 --月度
    and to_date(attrate.yearmonth || '-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE
    --基地归属配置
    and t.ad_organ_id = bb.org_id(+)
    --其他
    and t.pay_kind = 'salary' 
    and p.pay_kind = 'salary' 
    AND t.employ_type = '2' --1、用工性质只含合同工employtype=2
    AND t.duty BETWEEN '1' AND '9' --3、只取1-9职等
    --20200720 改不管行政班还是倒班  出勤率100% 履职系数1
    and attrate.attendance_rate=100 and attrate.work_coefficient=1
    --行政班，出勤率等于100%履职系数为1  or 两班倒，出勤率在范围之内（90%--100%）履职系数为1
    --     and
    --     ( 
    --     (m.IS_CHANGE_SHIFTS = 0 and attrate.attendance_rate=100 and attrate.work_coefficient=1) or
    --     (m.IS_CHANGE_SHIFTS = 1 and attrate.attendance_rate between 90 and 100 and attrate.work_coefficient=1)    
    --     )

    ${if(len(periodDate)==0,"","and to_date('"+periodDate+"'||'-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE")}

    ${if(len(dutyRange)==0,"","and zdfw.dic_dtl_value in (select * from table(split('"+dutyRange+"')))")}

    ${if(len(dptType)==0,"","and tc.dpt_type in (select * from table(split('"+dptType+"')))")}
     
    ${if(len(dptShortType)==0,"","and tc.dpt_short_type in (select * from table(split('"+dptShortType+"')))")}

    ${if(len(stationLevel)==0,"","and gwdj.station_level in (select * from table(split('"+stationLevel+"')))")}         
  GROUP BY
    tc.dpt_type,--部门类型
    tc.dpt_short_type,--部门
    zdfw.dic_dtl_value,--职等范围
    gwdj.station_level,--岗位等级
    nvl(bb.name, t.organ_name),--基地
    bb.sequence--基地序号
union all
----================内部：公司/属性（最小值）/部门类型/部门/职等范围/岗位等级/值

  SELECT 
    nvl(bb.name, t.organ_name) as group_name,--基地
    nvl(bb.sequence,100) group_sequence,
    3 property_sequence,        
    '最小值' as property_name,
    tc.dpt_type,--部门类型
    tc.dpt_short_type,--部门
    zdfw.dic_dtl_value duty_range,--职等范围
    gwdj.station_level,--岗位等级
    min(t.taxable_pay)||'' as property_val 
  FROM
    (select pc.*,
            nvl(pa.ad_dept_id, pc.dept_id) ad_dept_id,
            nvl(pa.ad_organ_id, pc.organ_id) ad_organ_id,
            nvl(pa.ad_dept_name, pc.dept_name) ad_dept_name
       from view_hr_pay_master_close_own pc,
            (select a.period_id,
                    ad.archive_id,
                    oo.id         ad_dept_id,
                    oo.name       ad_dept_name,
                    oo.org_id     ad_organ_id
               from hr_pay_sal_stats_adjust     a,
                    hr_pay_sal_stats_adjust_dtl ad,
                    sa_oporg                    oo
              where a.id = ad.main_id
                and ad.adjusted_dept_id = oo.id
                and a.status = 2000) pa
      where pc.period_id = pa.period_id(+)
        and pc.archive_id = pa.archive_id(+)) t ,
    view_hr_operation_period p,
    hr_pay_report_dept_cfg tc,--部门映射部门类型
    hr_pay_report_duty_slevel_cfg gwdj,--根据部门、职等范围可得到岗位等级
    HR_PAY_REPORT_LEVEL_DESCRIBE zdfw,--职等范围配置（属于哪个范围）
    view_hr_month_att_summary m, --排班信息
    view_attendance_work_rate attrate, --出勤率履职系数
    VIEW_COM_ORG_BELONG_BASE bb --基地归属配置
  WHERE
    1 = 1 
    and t.period_id = p.id    
    --部门映射部门类型
    and t.ad_dept_id = tc.dept_id 
    --岗位等级
    and tc.dpt_short_type = gwdj.dpt_short_type
    --职等范围
    and zdfw.dic_dtl_value = gwdj.duty_range
    and gwdj.cfg_kind = '1' --薪酬类型配置
    and to_number(t.duty) between to_number(zdfw.begin_duty) and to_number(zdfw.end_duty)
    --关联排班
    and t.archive_id = m.archive_id(+) 
    and t.period_id = m.period_id(+) 
    and t.pay_kind = m.period_kind(+)
    --关联排出勤率履职系数
    and t.archive_id = attrate.archive_id
    and attrate.report_type = 1 --月度
    and to_date(attrate.yearmonth || '-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE
    --基地归属配置
    and t.ad_organ_id = bb.org_id(+)
    --其他
    and t.pay_kind = 'salary' 
    and p.pay_kind = 'salary' 
    AND t.employ_type = '2' --1、用工性质只含合同工employtype=2
    AND t.duty BETWEEN '1' AND '9' --3、只取1-9职等
    --20200720 改不管行政班还是倒班  出勤率100% 履职系数1
    and attrate.attendance_rate=100 and attrate.work_coefficient=1
    --行政班，出勤率等于100%履职系数为1  or 两班倒，出勤率在范围之内（90%--100%）履职系数为1
    --     and
    --     ( 
    --     (m.IS_CHANGE_SHIFTS = 0 and attrate.attendance_rate=100 and attrate.work_coefficient=1) or
    --     (m.IS_CHANGE_SHIFTS = 1 and attrate.attendance_rate between 90 and 100 and attrate.work_coefficient=1)    
    --     )

    ${if(len(periodDate)==0,"","and to_date('"+periodDate+"'||'-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE")}

    ${if(len(dutyRange)==0,"","and zdfw.dic_dtl_value in (select * from table(split('"+dutyRange+"')))")}

    ${if(len(dptType)==0,"","and tc.dpt_type in (select * from table(split('"+dptType+"')))")}
     
    ${if(len(dptShortType)==0,"","and tc.dpt_short_type in (select * from table(split('"+dptShortType+"')))")}

    ${if(len(stationLevel)==0,"","and gwdj.station_level in (select * from table(split('"+stationLevel+"')))")}         
  GROUP BY
    tc.dpt_type,--部门类型
    tc.dpt_short_type,--部门
    zdfw.dic_dtl_value,--职等范围
    gwdj.station_level,--岗位等级
    nvl(bb.name, t.organ_name),--基地
    bb.sequence--基地序号
union all
----================内部：公司/属性（中位值）/部门类型/部门/职等范围/岗位等级/值

  SELECT 
    nvl(bb.name, t.organ_name) as group_name,--基地
    nvl(bb.sequence,100) group_sequence,
    4 property_sequence,        
    '中位值' as property_name,
    tc.dpt_type,--部门类型
    tc.dpt_short_type,--部门
    zdfw.dic_dtl_value duty_range,--职等范围
    gwdj.station_level,--岗位等级
    median(t.taxable_pay)||'' as property_val 
  FROM
    (select pc.*,
            nvl(pa.ad_dept_id, pc.dept_id) ad_dept_id,
            nvl(pa.ad_organ_id, pc.organ_id) ad_organ_id,
            nvl(pa.ad_dept_name, pc.dept_name) ad_dept_name
       from view_hr_pay_master_close_own pc,
            (select a.period_id,
                    ad.archive_id,
                    oo.id         ad_dept_id,
                    oo.name       ad_dept_name,
                    oo.org_id     ad_organ_id
               from hr_pay_sal_stats_adjust     a,
                    hr_pay_sal_stats_adjust_dtl ad,
                    sa_oporg                    oo
              where a.id = ad.main_id
                and ad.adjusted_dept_id = oo.id
                and a.status = 2000) pa
      where pc.period_id = pa.period_id(+)
        and pc.archive_id = pa.archive_id(+)) t ,
    view_hr_operation_period p,
    hr_pay_report_dept_cfg tc,--部门映射部门类型
    hr_pay_report_duty_slevel_cfg gwdj,--根据部门、职等范围可得到岗位等级
    HR_PAY_REPORT_LEVEL_DESCRIBE zdfw,--职等范围配置（属于哪个范围）
    view_hr_month_att_summary m, --排班信息
    view_attendance_work_rate attrate, --出勤率履职系数
    VIEW_COM_ORG_BELONG_BASE bb --基地归属配置
  WHERE
    1 = 1 
    and t.period_id = p.id    
    --部门映射部门类型
    and t.ad_dept_id = tc.dept_id 
    --岗位等级
    and tc.dpt_short_type = gwdj.dpt_short_type
    --职等范围
    and zdfw.dic_dtl_value = gwdj.duty_range
    and gwdj.cfg_kind = '1' --薪酬类型配置
    and to_number(t.duty) between to_number(zdfw.begin_duty) and to_number(zdfw.end_duty)
    --关联排班
    and t.archive_id = m.archive_id(+) 
    and t.period_id = m.period_id(+) 
    and t.pay_kind = m.period_kind(+)
    --关联排出勤率履职系数
    and t.archive_id = attrate.archive_id
    and attrate.report_type = 1 --月度
    and to_date(attrate.yearmonth || '-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE
    --基地归属配置
    and t.ad_organ_id = bb.org_id(+)
    --其他
    and t.pay_kind = 'salary' 
    and p.pay_kind = 'salary' 
    AND t.employ_type = '2' --1、用工性质只含合同工employtype=2
    AND t.duty BETWEEN '1' AND '9' --3、只取1-9职等
    --20200720 改不管行政班还是倒班  出勤率100% 履职系数1
    and attrate.attendance_rate=100 and attrate.work_coefficient=1
    --行政班，出勤率等于100%履职系数为1  or 两班倒，出勤率在范围之内（90%--100%）履职系数为1
    --     and
    --     ( 
    --     (m.IS_CHANGE_SHIFTS = 0 and attrate.attendance_rate=100 and attrate.work_coefficient=1) or
    --     (m.IS_CHANGE_SHIFTS = 1 and attrate.attendance_rate between 90 and 100 and attrate.work_coefficient=1)    
    --     )

    ${if(len(periodDate)==0,"","and to_date('"+periodDate+"'||'-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE")}

    ${if(len(dutyRange)==0,"","and zdfw.dic_dtl_value in (select * from table(split('"+dutyRange+"')))")}

    ${if(len(dptType)==0,"","and tc.dpt_type in (select * from table(split('"+dptType+"')))")}
     
    ${if(len(dptShortType)==0,"","and tc.dpt_short_type in (select * from table(split('"+dptShortType+"')))")}

    ${if(len(stationLevel)==0,"","and gwdj.station_level in (select * from table(split('"+stationLevel+"')))")}        
  GROUP BY
    tc.dpt_type,--部门类型
    tc.dpt_short_type,--部门
    zdfw.dic_dtl_value,--职等范围
    gwdj.station_level,--岗位等级
    nvl(bb.name, t.organ_name),--基地
    bb.sequence--基地序号
union all
----================内部：公司/属性（平均值）/部门类型/部门/职等范围/岗位等级/值

  SELECT 
    nvl(bb.name, t.organ_name) as group_name,--基地
    nvl(bb.sequence,100) group_sequence,
    5 property_sequence,    
    '平均值' as property_name,
    tc.dpt_type,--部门类型
    tc.dpt_short_type,--部门
    zdfw.dic_dtl_value duty_range,--职等范围
    gwdj.station_level,--岗位等级
    round(avg(t.taxable_pay),2)||'' as property_val 
  FROM
    (select pc.*,
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
        and pc.archive_id = pa.archive_id(+)) t ,
    view_hr_operation_period p,
    hr_pay_report_dept_cfg tc,--部门映射部门类型
    hr_pay_report_duty_slevel_cfg gwdj,--根据部门、职等范围可得到岗位等级
    HR_PAY_REPORT_LEVEL_DESCRIBE zdfw,--职等范围配置（属于哪个范围）
    view_hr_month_att_summary m, --排班信息
    view_attendance_work_rate attrate, --出勤率履职系数
    VIEW_COM_ORG_BELONG_BASE bb --基地归属配置
  WHERE
    1 = 1 
    and t.period_id = p.id    
    --部门映射部门类型
    and t.ad_dept_id = tc.dept_id 
    --岗位等级
    and tc.dpt_short_type = gwdj.dpt_short_type
    --职等范围
    and zdfw.dic_dtl_value = gwdj.duty_range
    and gwdj.cfg_kind = '1' --薪酬类型配置
    and to_number(t.duty) between to_number(zdfw.begin_duty) and to_number(zdfw.end_duty)
    --关联排班
    and t.archive_id = m.archive_id(+) 
    and t.period_id = m.period_id(+) 
    and t.pay_kind = m.period_kind(+)
    --关联排出勤率履职系数
    and t.archive_id = attrate.archive_id
    and attrate.report_type = 1 --月度
    and to_date(attrate.yearmonth || '-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE
    --基地归属配置
    and t.ad_organ_id = bb.org_id(+)
    --其他
    and t.pay_kind = 'salary' 
    and p.pay_kind = 'salary' 
    AND t.employ_type = '2' --1、用工性质只含合同工employtype=2
    AND t.duty BETWEEN '1' AND '9' --3、只取1-9职等
    --20200720 改不管行政班还是倒班  出勤率100% 履职系数1
    and attrate.attendance_rate=100 and attrate.work_coefficient=1
    --行政班，出勤率等于100%履职系数为1  or 两班倒，出勤率在范围之内（90%--100%）履职系数为1
    --     and
    --     ( 
    --     (m.IS_CHANGE_SHIFTS = 0 and attrate.attendance_rate=100 and attrate.work_coefficient=1) or
    --     (m.IS_CHANGE_SHIFTS = 1 and attrate.attendance_rate between 90 and 100 and attrate.work_coefficient=1)    
    --     )

    ${if(len(periodDate)==0,"","and to_date('"+periodDate+"'||'-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE")}

    ${if(len(dutyRange)==0,"","and zdfw.dic_dtl_value in (select * from table(split('"+dutyRange+"')))")}

    ${if(len(dptType)==0,"","and tc.dpt_type in (select * from table(split('"+dptType+"')))")}
     
    ${if(len(dptShortType)==0,"","and tc.dpt_short_type in (select * from table(split('"+dptShortType+"')))")}

    ${if(len(stationLevel)==0,"","and gwdj.station_level in (select * from table(split('"+stationLevel+"')))")}         
  GROUP BY
    tc.dpt_type,--部门类型
    tc.dpt_short_type,--部门
    zdfw.dic_dtl_value,--职等范围
    gwdj.station_level,--岗位等级
    nvl(bb.name, t.organ_name),--基地
    bb.sequence--基地序号
union all
----================外部：公司/属性（外部单位名称）/部门类型/部门/职等范围/岗位等级/值
select 
       '外部单位' as group_name, 
       9999 group_sequence,
       1 property_sequence,
       dc.name as property_name,
       exdtl.dpt_type,
       exdtl.dpt_short_type,
       exdtl.duty_range,
       exdtl.station_level,
       exdtl.range_salary_txt as property_val
  from hr_pay_master_external     ex,
       hr_pay_master_external_dtl exdtl,
       view_hr_operation_period   p,
       v_sa_dictionary dc
 where ex.id = exdtl.main_id
   and ex.period_id = p.id
   and dc.code = 'salaryExternalOrg'
   and dc.value = exdtl.external_org
   and ex.status = 2000
   and exdtl.is_newest = 1
   
   
    ${if(len(periodDate)==0,"","and to_date('"+periodDate+"'||'-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE")}

    ${if(len(dutyRange)==0,"","and exdtl.duty_range in (select * from table(split('"+dutyRange+"')))")}

    ${if(len(dptType)==0,"","and exdtl.dpt_type in (select * from table(split('"+dptType+"')))")}
     
    ${if(len(dptShortType)==0,"","and exdtl.dpt_short_type in (select * from table(split('"+dptShortType+"')))")}

    ${if(len(stationLevel)==0,"","and exdtl.station_level in (select * from table(split('"+stationLevel+"')))")}         

--union内容结束
)ttt

order by ttt.dpt_type,ttt.dpt_short_type,ttt.duty_range,ttt.station_level,ttt.group_sequence,ttt.group_name,ttt.property_sequence


