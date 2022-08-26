select t.organ_name,
       t.dept_name,
       d.org_name   organization_organ_name,
       d.name       organization_dept_name,
       t.employeeno,
       t.name,
       t.station,
       sd.name      station_name,
       t.duty,
       t.enterdate
  from hr_humanarchive_bak_all t,
       hr_pay_report_dept_cfg  cd,
       sa_oporg                d,
       v_sa_dictionary         sd
 where t.dept_id = cd.dept_id
   and t.organization_org_id = d.id
   and t.station = sd.value
   and sd.code = 'station'
   and (t.belonging_company is null or t.belonging_company = '5')
   and cd.dpt_short_type = '${dptShortType}'
   and t.duty in (select column_value from table(split('${duties}')))
   and t.bak_date >= to_date('${queryDate}', 'yyyy-mm-dd')
   and t.bak_date < to_date('${queryDate}', 'yyyy-mm-dd') + 1
 order by t.employeeno asc

