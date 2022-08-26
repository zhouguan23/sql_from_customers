select t.organ_name,
       t.dept_name,
       d.org_name   organization_organ_name,
       d.name       organization_dept_name,
       t.employeeno,
       t.name,
       t.station,
       sd.name      station_name,
       t.duty,
       t.enterdate,
       b.full_name
  from hr_humanarchive_bak_all  t,
       hr_sm_hcm_dept_ownership sh,
       view_hr_base_org         b,
       sa_oporg                 d,
       v_sa_oporgproperty       dp,
       v_sa_dictionary          sd
 where 1 = 1
--在岗
${if(queryKind == 'dept_id', " and t.dept_id = sh.source_dept_id(+) and (sh.target_dept_id = b.org_id or t.dept_id = b.org_id )", "") }
--在编
${if(queryKind == 'organization_org_id', " and t.organization_org_id = sh.source_dept_id(+) and (sh.target_dept_id = b.org_id or t.organization_org_id = b.org_id )", "") }
${if(queryKind != 'dept_id' && queryKind != 'organization_org_id', "1=2", "") } 
   and t.organization_org_id = d.id
   and dp.id = t.dept_id
   and dp.property_name = 'deptBusinessFormat'
   and t.station = sd.value
   and sd.code = 'station'
   and (t.belonging_company is null or t.belonging_company = '5')
   and dp.property_value = '${deptBusiness}'
   and b.id = '${ognDeptId}'
   and t.station = '${station}'
   and t.duty = '${duty}'
   and t.bak_date >= to_date('${queryDate}', 'yyyy-mm-dd')
   and t.bak_date < to_date('${queryDate}', 'yyyy-mm-dd') + 1
 order by t.employeeno asc


