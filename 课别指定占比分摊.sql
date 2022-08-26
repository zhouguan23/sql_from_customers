select  b.NodeCode ,c.CategoryCode CostSubjectCode,c.CategoryName CostSubjectName,a.CategoryCode ,a.CategoryName 
	from 
	dbo.TB部门分类对照表 a 
	,TB部门信息表 b 
	,TB费用科目表 c 
	where a.CategoryItemCode ='0000'  and a.deptcpde=b.FormatCode 
	and a.CategoryLevel=1  and a.deptcpde=c.CategoryItemCode  and c.ChargeType='0'
	and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }    and 1=1 ${if(len(km) == 0,   "",   "and c.CategoryCode in ('" + replace(km,",","','")+"')") }
	
	order by 1,2,4

select * from 
TB费用指定分摊占比

select * from 
(select CategoryCode,CategoryName,''ParentCategoryCode from 
TB费用分类表 a 
where exists(select * from tb费用科目表 b
where  b.ChargeType='0' and a.CategoryCode=b.ParentCategoryCode and  a.CategoryItemCode=b.CategoryItemCode)
and  a.CategoryItemCode in (select  distinct FormatCode from 
	TB部门信息表 where  1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") })

union all 
select CategoryCode,CategoryName,ParentCategoryCode from 
tb费用科目表
where  ChargeType='0' and  CategoryItemCode in (select  distinct FormatCode from 
	TB部门信息表 where  1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") })
)a

order by convert(int,CategoryCode),convert(int,ParentCategoryCode)

