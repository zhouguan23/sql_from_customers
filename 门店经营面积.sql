select  b.NodeCode ,a.CategoryCode ,a.CategoryName 
	from 
	dbo.TB部门分类对照表 a 
	,TB部门信息表 b 
	where a.CategoryItemCode='0000'  and a.deptcpde=b.FormatCode 
	and a.CategoryLevel=1 and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") } 

select * from 
TB门店面积表

