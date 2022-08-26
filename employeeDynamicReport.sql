select cd.dpt_type,
       sd2.sequence dpt_type_sequence,
       sd2.name dpt_type_name,
       cd.dpt_short_type,
       sd3.sequence dpt_short_type_sequence,
       sd3.name dpt_short_type_name,
       cc.duty_range,
       sd1.sequence duty_range_sequence,
       sd1.name duty_range_name,
       sum(tq.personnel_quota_num) personnel_quota_num,
       sum(tq.person_qty) person_qty,
       to_char(wm_concat(distinct cr.duty)) duties
  from (select dept_id,
               duty,
               sum(personnel_quota_num) personnel_quota_num,
               sum(person_qty) person_qty
          from (select q.dept_id,
                       ds.duty,
                       sum(nvl(q.adjust_personnel_quota_num,
                               q.personnel_quota_num)) personnel_quota_num,
                       0 person_qty
                  from v_sa_oporgproperty           dp,
                       hr_personnel_quota           q,
                       hr_depart_post_information   di,
                       hr_depart_information_depdtl dd,
                       hr_depart_information_stadtl ds
                 where dp.id = q.dept_id
                   and di.id = dd.main_id
                   and di.id = ds.main_id
                   and q.dept_id = dd.dept_id
                   and q.station = ds.station
                   and dp.property_name = 'deptBusinessFormat'
                   and q.year_month = to_date('${yearMonth}', 'yyyy-mm')
                --部门业态
                 ${if(len(deptBusiness) == 0,
                            "",
                            "and dp.property_value = '" + deptBusiness + "'") }
                 group by q.dept_id, ds.duty
                union all
                select hb.dept_id,
                       hb.duty,
                       0 personnel_quota_num,
                       count(*) person_qty
                  from v_sa_oporgproperty dp, hr_humanarchive_bak_all hb
                 where dp.id = hb.dept_id
                   and hb.bak_date >= to_date('${queryDate}', 'yyyy-mm-dd')
                   and hb.bak_date <
                       to_date('${queryDate}', 'yyyy-mm-dd') + 1
                   and (hb.belonging_company is null or
                       hb.belonging_company = '5')
                   and dp.property_name = 'deptBusinessFormat'
                --部门业态
                 ${if(len(deptBusiness) == 0,
                            "",
                            "and dp.property_value = '" + deptBusiness + "'") }
                 group by hb.dept_id, hb.duty)
         group by dept_id, duty) tq,
       hr_pay_report_dept_cfg cd,
       hr_pay_report_duty_slevel_cfg cc,
       hr_pay_report_duty_range_dtl cr,
       v_sa_dictionary sd1,
       v_sa_dictionary sd2,
       v_sa_dictionary sd3,
       view_hr_base_org b
 where tq.dept_id = cd.dept_id
   and tq.duty = cr.duty
   and cd.dpt_short_type = cc.dpt_short_type
   and cc.duty_range = cr.dic_value
   and cr.dic_value = sd1.value
   and sd1.code = 'dutyRange'
   and cd.dpt_type = sd2.value
   and sd2.code = 'dptType'
   and cd.dpt_short_type = sd3.value
   and sd3.code = 'dptShortType'
   and tq.dept_id = b.org_id
   and cd.status = 1
   and cc.status = 1
   and cc.cfg_kind = '2'-- 招聘类配置
--基地
 ${if(len(ognName) == 0,
            "",
            "and b.ogn_name like '%" + ognName + "%'") }
 group by cd.dpt_type,
          sd2.sequence,
          sd2.name,
          cd.dpt_short_type,
          sd3.sequence,
          sd3.name,
          cc.duty_range,
          sd1.sequence,
          sd1.name
 order by dpt_type_sequence       asc,
          dpt_short_type_sequence asc,
          duty_range_sequence     desc


