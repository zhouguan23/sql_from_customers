select organ_name,
       dept_name,
       organization_organ_name,
       organization_dept_name,
       employeeno,
       name,
       station,
       station_name,
       duty,
       enterdate,
       leave_date
  from (select hh.organ_name,
               hh.dept_name,
               d.org_name organization_organ_name,
               d.name organization_dept_name,
               hh.employeeno,
               hh.name,
               hh.station,
               sd.name station_name,
               hh.duty,
               hh.enterdate,
               nvl(dh.attendance_check_date, td.leave_date_exp) leave_date,
               row_number() over(partition by td.archive_id, td.dept_id order by td.leave_date_exp desc) rn
          from hr_dm_dimission          td,
               hr_humanarchive          hh,
               hr_dm_dimission_handover dh,
               hr_sm_hcm_dept_ownership sh,
               view_hr_base_org         b,
               sa_oporg                 d,
               v_sa_oporgproperty       dp,
               v_sa_dictionary          sd
         where td.archive_id = hh.id
           and td.id = dh.source_id(+)
           and hh.dept_id = sh.source_dept_id(+)
           and (sh.target_dept_id = b.org_id or hh.dept_id = b.org_id)
           and hh.organization_org_id = d.id
           and dp.id = hh.dept_id
           and dp.property_name = 'deptBusinessFormat'
           and hh.station = sd.value
           and sd.code = 'station'
           and td.status >= 0
           and (hh.belonging_company is null or hh.belonging_company = '5')
           and dp.property_value = '${deptBusiness}'
           and b.id = '${ognDeptId}'
           and td.station_name = '${station}'
           and td.duty = '${duty}')
 where leave_date >= to_date('${queryDate}', 'yyyy-mm-dd')
   and rn = 1


