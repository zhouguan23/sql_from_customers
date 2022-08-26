SELECT a.nodecode NODE,b.* FROM 
TB部门信息表 A
left join 
TB门店数据库信息表 b on a.nodecode=b.deptcode

