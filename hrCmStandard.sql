select t.*, to_number(to_char(t.period_date, 'mm')) || '月' month_name
  from hr_cm_standard t, hr_base_org b
 where t.ogn_dept_id = b.id
  ${if(len(year)==0,"","and t.year = '"+year+"'")}
   --基地部门
 ${if(len(ognId)==0,"","and (t.ogn_id in (select * from table(split('"+ognId+"'))) or t.ogn_dept_id in (select * from table(split('"+ognId+"'))))")}
 --期间(起)
  ${if(len(startMonth)==0,"","and t.period_date>= to_date('"+startMonth+"', 'yyyy-mm' )")}
 --期间(止)
  ${if(len(endMonth)==0,"","and t.period_date<= to_date('"+endMonth+"', 'yyyy-mm' )")}
 order by b.full_sequence asc, t.period_date asc

