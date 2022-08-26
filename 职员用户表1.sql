SELECT * FROM dbo.[tbEmployee]A
where 
1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(gh) == 0,   "",   "and EmployeeCode in ('" + replace(gh,",","','")+"')") }
and 1=1 ${if(len(js) == 0,   "",   "and userrole in ('" + replace(js,",","','")+"')") }
and 1=1 ${if(len(dh) == 0,   "",   "and movphone in ('" + replace(dh,",","','")+"')") }
and 1=1 ${if(len(CONCATENATE(GETUSERDEPARTMENTS())) == 0,""," and nodecode in (" + CONCATENATE(GETUSERDEPARTMENTS()) + ")")}
order by 1,10

