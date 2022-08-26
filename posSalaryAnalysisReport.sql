/*
工资关闭状态才取数汇总-》view_hr_pay_master_close
1、用工性质只含合同工；-》employtype=2
2、人员状态为正式；-》leavesort=6  
3、只取2-9职等；-》t.duty BETWEEN '2' AND '9'
4、如果是
（1）非班长、组长、资深组长，职位薪酬=正式职位薪酬；
（2）班长、组长、资深组长，职位薪酬=正式职位薪酬station_salary +职务津贴job_allowance
（station ：班长=1101组长=912资深组长=231）
CASE WHEN t.station in ('1101','912','231') THEN nvl(t.station_salary, 0) + nvl(t.job_allowance, 0) ELSE t.station_salary END


20200720需求更改：
取消岗位列；
*/
/*查出公司、部门类型、部门、职等、岗位、人数/最大值/最小值/中位值/平均值*/

--《各基地详情》
select t.* from (

  --人数
  SELECT /*+ RULE */
    tc.dpt_type,
    tc.dpt_short_type,
    --20200720取消station字段 t.station,    
    nvl(bb.name, t.organ_name) as organ_name,--基地
    bb.sequence,--基地序号
    t.leave_sort,
    t.duty, 
 
    count( 1 ) as num,
    
    max( CASE WHEN t.station in ('1101','912','231') THEN nvl(t.station_salary, 0) + nvl(t.job_allowance, 0) ELSE t.station_salary END ) as max_num ,
    
    min( CASE WHEN t.station in ('1101','912','231') THEN nvl(t.station_salary, 0) + nvl(t.job_allowance, 0) ELSE t.station_salary END ) as min_num ,
    
    median( CASE WHEN t.station in ('1101','912','231') THEN nvl(t.station_salary, 0) + nvl(t.job_allowance, 0) ELSE t.station_salary END ) as med_num,
    
    round(avg( CASE WHEN t.station in ('1101','912','231') THEN nvl(t.station_salary, 0) + nvl(t.job_allowance, 0) ELSE t.station_salary END ),2) as avg_num 
  FROM
    view_hr_pay_master_close t ,
    view_hr_operation_period p,
    hr_pay_report_dept_cfg tc,----部门映射部门类型
    VIEW_COM_ORG_BELONG_BASE bb --基地归属配置	
  WHERE
    1 = 1 
    and t.period_id = p.id
    --部门映射部门类型
    and tc.dept_id = t.dept_id 
    --基地归属配置
    and t.organ_id = bb.org_id(+)		
    and t.pay_kind = 'salary' 
    and p.pay_kind = 'salary' 
    AND t.employ_type = '2' --1、用工性质只含合同工employtype=2
    AND t.leave_sort = '6' --2、人员状态为正式leavesort=6  
    AND t.duty BETWEEN '2' AND '9' --3、只取2-9职等
    ${if(len(periodDate)==0,"","and to_date('"+periodDate+"'||'-01','yyyy-mm-dd') between p.BEGIN_DATE and p.end_DATE")}

		${if(len(duty)==0,"","and t.duty in (select * from table(split('"+duty+"')))")}

		${if(len(dptType)==0,"","and tc.dpt_type in (select * from table(split('"+dptType+"')))")}
     
		${if(len(dptShortType)==0,"","and tc.dpt_short_type in (select * from table(split('"+dptShortType+"')))")}

		--20200720取消station字段 ${if(len(station)==0,"","and t.station in (select * from table(split('"+station+"')))")}         
  GROUP BY
    tc.dpt_type,
    tc.dpt_short_type,
    --20200720取消station字段 t.station,
    nvl(bb.name, t.organ_name),--基地
    bb.sequence,--基地序号
    t.leave_sort,
    t.duty 
) t 
where 1=1 


order by t.sequence,t.dpt_type,t.dpt_short_type,t.duty 


select value,name from v_sa_dictionary where code = 'station'

select value,name from v_sa_dictionary where code = 'dptType'

select value,name from v_sa_dictionary where code = 'dptShortType'

