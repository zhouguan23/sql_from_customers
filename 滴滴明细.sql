select 
      t.didi_order_id as 企业订单号, 
      t.booker_nm as 下单人姓名,
      t.book_emp_cd as 下单人员工工号,
      t.booker_mobile as 下单人电话,
      case when t1.dept05_cd='00000002' then s3.dept01_cd else t1.dept01_cd end as 一级部门编码,
      case when t1.dept05_cd='00000002' then s3.dept01_nm else t1.dept01_nm end as 一级部门,
      case when t1.dept05_cd='00000002' then s3.dept02_cd else t1.dept02_cd end as 二级部门编码,
      case when t1.dept05_cd='00000002' then s3.dept02_nm else t1.dept02_nm end as 二级部门,
      case when t1.dept05_cd='00000002' then s3.dept03_cd else t1.dept03_cd end as 三级部门编码,
      case when t1.dept05_cd='00000002' then s3.dept03_nm else t1.dept03_nm end as 三级部门,
      case when t1.dept05_cd='00000002' then s3.dept04_cd else t1.dept04_cd end as 四级部门编码,
      case when t1.dept05_cd='00000002' then s3.dept04_nm else t1.dept04_nm end as 四级部门,
      case when t1.dept05_cd='00000002' then s3.dept05_cd else t1.dept05_cd end as 五级部门编码,
      case when t1.dept05_cd='00000002' then s3.dept05_nm else t1.dept05_nm end as 五级部门,
      t.passenger_name as 实际用车人姓名,
      t.passenger_mobile as 实际用车人手机号,
      case
           when t.order_st='0' then '未知'
           when t.order_st='300' then '等待应答'
           when t.order_st='311' then '订单超时'
           when t.order_st='400' then '等待接驾'
           when t.order_st='410' then '司机已到达'
           when t.order_st='500' then '行程中'
           when t.order_st='600' then '订单结束'
           when t.order_st='610' then '订单异常结束'
           when t.order_st='700' then '已支付'
      end as 订单状态,--       STRING COMMENT '0未知,300等待应答,311订单超时,400等待接驾,410司机已到达,500行程中,600订单结束,610订单异常结束,700已支付',
      t.order_time as 下单时间,
      t.departure_time as 上车时间,
      t.finish_time as 下车时间,
      sum(t.total_price) as 总费用,
      nvl(t5.cost_ctr_nm,t4.cost_ctr_nm) as 四大成本中心,
       t6.cost_center_code 成本中心编码,
       t6.cost_center_desc 成本中心名称,
       t6.personnel_subarea 人事范围编码,
       t6.personnel_subarea_nm 人事范围名称,
      case when t1.dept05_cd='00000002' then s3.cmpy_cd else t1.cmpy_cd end as 预订人公司名称编码,
      case when t1.dept05_cd='00000002' then s3.cmpy_nm else t1.cmpy_nm end as 预订人公司名称,
      t.trv_apply_num as 出差申请单号
from edw_cttq_prd.dwd_emp_trvl_car_total t
left join edw_cttq_prd.dim_cttq_employee_dept t1
      on t.book_emp_cd=t1.personnel_num 
      and replace(to_date(t.order_time) ,'-','') between t1.start_date and t1.end_date
--有些领导取不到一级部门的取SAP里面的管理部门（五级部门为00000002的取SAP里面的管理部门）
left join ods_cttq_prd.hrp1001 s1
      on s1.OTYPE ='S'
      and s1.SUBTY ='A008'
      and s1.SCLAS ='P'
      and s1.begda <= replace(to_date(t.order_time) ,'-','')
      and s1.endda >= replace(to_date(t.order_time) ,'-','')
      and lpad(s1.sobid,8,'0')=lpad(t.book_emp_cd,8,'0')
      and t1.dept05_cd='00000002'
left join ods_cttq_prd.hrp1001 s2
      on s2.OTYPE ='S'
      and s2.SUBTY ='A012'
      and s2.SCLAS ='O'
      and s2.begda <= replace(to_date(t.order_time) ,'-','')
      and s2.endda >= replace(to_date(t.order_time) ,'-','')
      and s2.objid = s1.objid
left join edw_cttq_prd.dim_cttq_department_month s3
      on s2.sobid=s3.dept05_cd
      and s3.month=cast(left(replace(to_date(t.order_time) ,'-',''),6) as int)

--成本中心-部门 
left join ods_manual_prd.trvl_cost_center t4
      on case when t1.dept05_cd='00000002' then s3.dept05_cd else t1.dept05_cd end=t4.dept05_cd
--成本中心-领导层 
left join ods_manual_prd.trvl_cost_center_emp t5
      on t.book_emp_cd=t5.emp_cd
left join ods_cttq_prd.cps_org_person_a t6
      on lpad(t.book_emp_cd,8,'0')=t6.person_code
where nvl(t.total_price,0)<>0
and case when trim(ifnull(t.finish_time,''))='' then t.order_time else t.finish_time end between '${BEGDA}' and '${ENDDA}'
group by 
      t.didi_order_id, 
      t.booker_nm,
      t.book_emp_cd,
      t.booker_mobile,
      一级部门编码,
      一级部门,
      二级部门编码,
      二级部门,
      三级部门编码,
      三级部门,
      四级部门编码,
      四级部门,
      五级部门编码,
      五级部门,
      t.passenger_name,
      t.passenger_mobile,
      订单状态,
      t.order_time,
      t.departure_time,
      t.finish_time,
      四大成本中心,
      成本中心编码,
      成本中心名称,
      人事范围编码,
      人事范围名称,
      预订人公司名称编码,
      预订人公司名称,
      t.trv_apply_num
order by case when trim(ifnull(t.finish_time,''))='' then t.order_time else t.finish_time end

