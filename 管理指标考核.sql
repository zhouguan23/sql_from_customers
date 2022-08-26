select A.AreaCode,a.NodeCode,a.nodename,OpenDate,a.ParentCategoryCode,a.CategoryCode  from 
(select  B.AreaCode,b.NodeCode,b.nodename,OpenDate,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName 
from dbo.TB商品分类表 a ,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=2 and left(CategoryCode,1) between 1 and 5
and left(b.NodeCode,1) between 1 and 2
)a
where dATEDIFF(MM,OpenDate,'${YM}'+'01')>=3
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }
order by A.AreaCode,a.NodeCode,a.CategoryCode 

	select b.AreaCode,a.nodecode as 部门编码,
		left(a.CategoryCode,1)大分类,LEFT(a.CategoryCode,2)	课分类 ,
	isnull(sum(可订货次数),0)可订货次数 ,isnull(sum(缺货次数),0)缺货次数   from 
	TB${YM}_月度缺货数据 a
	LEFT JOIN 
	tb部门信息表 b on a.nodecode=b.nodecode
	where CategoryItemCode='0000' 
	and 1=1 ${if(len(bm) == 0,   "",   "and a.NODECODE  in ('" + replace(bm,",","','")+"')") }
	
	group by b.AreaCode,a.nodecode,
		left(a.CategoryCode,1),CategoryCode


	select b.AreaCode,a.nodecode as 部门编码,
		left(a.CategoryCode,1)大分类,LEFT(a.CategoryCode,2)	课分类 ,
	isnull(sum(有库存金额),0)有库存金额 ,isnull(sum(滞销金额),0)滞销金额   from 
	TB${YM}_月度滞销数据 a
	LEFT JOIN 
	tb部门信息表 b on a.nodecode=b.nodecode
	where CategoryItemCode='0000' 
	and 1=1 ${if(len(bm) == 0,   "",   "and a.NODECODE  in ('" + replace(bm,",","','")+"')") }
	
	group by b.AreaCode,a.nodecode,
		left(a.CategoryCode,1),CategoryCode


	select b.AreaCode,a.nodecode as 部门编码,
		left(a.CategoryCode,1)大分类,LEFT(a.CategoryCode,2)	课分类 ,
	isnull(sum(可订货次数),0)可订货次数 ,isnull(sum(缺货次数),0)缺货次数   from 
	TB${YM}_月度缺货数据 a
	LEFT JOIN 
	tb部门信息表 b on a.nodecode=b.nodecode
	where CategoryItemCode='0001' 
	and 1=1 ${if(len(bm) == 0,   "",   "and a.NODECODE  in ('" + replace(bm,",","','")+"')") }
	
	group by b.AreaCode,a.nodecode,
		left(a.CategoryCode,1),CategoryCode


	select b.AreaCode,a.nodecode as 部门编码,
		left(a.CategoryCode,1)大分类,LEFT(a.CategoryCode,2)	课分类 ,
	isnull(sum(有库存金额),0)有库存金额 ,isnull(sum(滞销金额),0)滞销金额   from 
	TB${YM}_月度滞销数据 a
	LEFT JOIN 
	tb部门信息表 b on a.nodecode=b.nodecode
	where CategoryItemCode='0001' 
	and 1=1 ${if(len(bm) == 0,   "",   "and a.NODECODE  in ('" + replace(bm,",","','")+"')") }
	
	group by b.AreaCode,a.nodecode,
		left(a.CategoryCode,1),CategoryCode


	select b.AreaCode,a.nodecode 部门编码,
		left(a.CategoryCode,1)大分类,LEFT(a.CategoryCode,2)	课分类 ,
	isnull(sum(AvgSaleCost),0)SaleCost ,isnull(sum(StockCost),0)Cost   from 
	TB${YM}_月度库存周转天数 a
	LEFT JOIN 
	tb部门信息表 b on a.nodecode=b.nodecode
	where CategoryItemCode='0000' and 1=1 ${if(len(bm) == 0,   "",   "and a.NODECODE  in ('" + replace(bm,",","','")+"')") }
	
	group by b.AreaCode,a.nodecode,
		left(a.CategoryCode,1),CategoryCode

	select b.AreaCode,a.nodecode as 部门编码, 
		left(a.CategoryCode,1)大分类,LEFT(a.CategoryCode,2)	课分类 ,
	isnull(sum(AvgSaleCost),0)SaleCost ,isnull(sum(StockCost),0)Cost   from 
	TB${YM}_月度库存周转天数 a
	LEFT JOIN 
	tb部门信息表 b on a.nodecode=b.nodecode
	where CategoryItemCode='0001' and 1=1 ${if(len(bm) == 0,   "",   "and a.NODECODE  in ('" + replace(bm,",","','")+"')") }
	
	group by b.AreaCode,a.nodecode,
		left(a.CategoryCode,1),CategoryCode

