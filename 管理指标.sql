select CategoryCode,CategoryName from 
[000]A.TBDEPTCATEGORY 
where  CategoryItemCode ='0013'

select CategoryCode,CategoryName from 
[000]A.TBDEPTCATEGORY 
where  CategoryItemCode ='0011'

select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')NodeName   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 8 and a.nodecode not in (6601)
and a.State=0 and b.NodeType in (0,2) and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112) and 
1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}


select ParentCategoryCode,CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 1 and 5 and LEN(CategoryCode)<3

declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6),@jsrq varchar(8), @qsrq varchar(8)
, @byts varchar(8)
set @dqrq= convert(varchar(8),dateadd(dd,0,'${rq}'),112)
set @byts= DAY(dateadd(day,-1,convert(char(07),dateadd(month,1,@dqrq),120)+'-01'))
set @jsny= @dqrq
set @qsrq=CONVERT(varchar(8),dateadd(dd,-DAY(dateadd(day,-1,convert(char(07),dateadd(month,1,@dqrq),120)+'-01'))+1,@dqrq)    , 112) 
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='
	select d.DeptCategoryCode yt_Code,d.CategoryName yt_name,a.NodeCode ,'+@byts+'tjts,
	left(a.GoodsCatCode,1)GoodsCatCode1,
	case when 
 ( a.GoodsCatCode like ''281%'' or  a.GoodsCatCode like ''21%'' or  a.GoodsCatCode like ''288%'')  then ''21'' 
 when  
 (a.GoodsCatCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 a.GoodsCatCode like ''280%'' or  a.GoodsCatCode like ''20%'' or  a.GoodsCatCode like ''287%'')  then ''20'' 
  when  
 (a.GoodsCatCode in (29003,29006) or 
 a.GoodsCatCode like ''282%'' or  a.GoodsCatCode like ''22%'' or  a.GoodsCatCode like ''289%'')  then ''22'' 
  else LEFT(a.GoodsCatCode,2) end	GoodsCatCode ,
	isnull(sum(b.SaleCost),0)SaleCost ,isnull(sum(a.StockCost),0)Cost from 
	(select DepartmentCode nodecode,left(CategoryCode,2)GoodsCatCode, SUM(StockCost)StockCost from 
[000]A .tb'+@jsny+'_Reportinfo a 
where ReportDate='+@dqrq+' and DepartmentCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 8 and a.nodecode not in (6601)
and a.State=0 and b.NodeType in (0,2) and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
and not exists (select * from 
[000]A .TBGOODSPROPINCLUSIONS b
where b.GoodsPropertyCode=''2002'' and a.goodscode=b.goodscode and a.DepartmentCode in (''1042''))

and 1=1 ${if(len(bm) == 0,   "",   "and a.DepartmentCode  in (''" + replace(bm,",","'',''")+"'')") }
and 1=1 ${if(len(fl2) == 0,   "",   "and left(a.CategoryCode,2) in (''" + replace(fl2,",","'',''")+"'')") }
and left(CategoryCode,1) between 1 and 5 and GoodsType not in (1,6,7) 
and left(CategoryCode,2) not in (''23'')
and  1=1 ${if(sx == 0,   "",   "and exists  ( select * from (select GoodsPropertyCode,GoodsCode,GoodsPropId from 
[000]A .TBGOODSPROPINCLUSIONS
where GoodsPropertyCode =''2001''
union all
select GoodsBrand ,GoodsCode ,''0''GoodsPropid from 
[000]A .tbGoods 
where GoodsBrand =''010001'') c where a.goodscode=c.goodscode and c.GoodsPropertyCode=''" +sx+"'')") }


group by DepartmentCode,left(CategoryCode,2)
) a 
	left join 
	
	(select nodecode,GoodsCatCode,sum(SaleCost)SaleCost from 
	
	(select DepartmentCode nodecode,left(CategoryCode,2)GoodsCatCode,SUM(CommonSaleCost+PromotionSaleCost) SaleCost from [000]A .tb'+@qsny+'_REPORTINFO a where ReportDate between '+@qsrq+' and  '+@dqrq+' 
	
and GoodsType not in (1,6,7)  


and  1=1 ${if(sx == 0,   "",   "and exists  ( select * from (select GoodsPropertyCode,GoodsCode,GoodsPropId from 
[000]A .TBGOODSPROPINCLUSIONS
where GoodsPropertyCode =''2001''
union all
select GoodsBrand ,GoodsCode ,''0''GoodsPropid from 
[000]A .tbGoods 
where GoodsBrand =''010001'') c where a.goodscode=c.goodscode and c.GoodsPropertyCode=''" +sx+"'')") }


group by DepartmentCode,left(CategoryCode,2)
	union all 
	select DepartmentCode nodecode,left(CategoryCode,2)GoodsCatCode,SUM(CommonSaleCost+PromotionSaleCost) SaleCost 
	from [000]A .tb'+@Jsny+'_REPORTINFO a where ReportDate between '+@qsrq+' and  '+@dqrq+' and left(CategoryCode,2) not in (''23'')
	
and GoodsType not in (1,6,7)  


and  1=1 ${if(sx == 0,   "",   "and exists  ( select * from (select GoodsPropertyCode,GoodsCode,GoodsPropId from 
[000]A .TBGOODSPROPINCLUSIONS
where GoodsPropertyCode =''2001''
union all
select GoodsBrand ,GoodsCode ,''0''GoodsPropid from 
[000]A .tbGoods 
where GoodsBrand =''010001'') c where a.goodscode=c.goodscode and c.GoodsPropertyCode=''" +sx+"'')") }

group by DepartmentCode,left(CategoryCode,2))b
	where  
	 GoodsCatCode not like ''6%'' and GoodsCatCode not like ''0%'' and 
	nodecode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))




	group by nodecode,GoodsCatCode )b  on a.NodeCode =b.NodeCode and a.GoodsCatCode =b.GoodsCatCode
	
	left join
(select a.DeptCategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0011''
where  a.DeptCatItemCode =''0011'')c on a.nodecode=c.nodecode
left join
(select a.DeptCategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0013''
where  a.DeptCatItemCode =''0013'')d on a.nodecode=d.nodecode
	
where      1=1 ${if(or(sx == 0,sx == 2001),   "and a.NodeCode not in (6666,7777,8888,6601)", "") }
	group by d.DeptCategoryCode,d.CategoryName,a.nodecode,left(a.GoodsCatCode,1),
	case when 
 ( a.GoodsCatCode like ''281%'' or  a.GoodsCatCode like ''21%'' or  a.GoodsCatCode like ''288%'')  then ''21'' 
 when  
 (a.GoodsCatCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 a.GoodsCatCode like ''280%'' or  a.GoodsCatCode like ''20%'' or  a.GoodsCatCode like ''287%'')  then ''20'' 
  when  
 (a.GoodsCatCode in (29003,29006) or 
 a.GoodsCatCode like ''282%'' or  a.GoodsCatCode like ''22%'' or  a.GoodsCatCode like ''289%'')  then ''22'' 
  else LEFT(a.GoodsCatCode,2) end
    order by 1,3,5,6
	'exec (@sQL1)


select AreaCode,NodeCode ,NodeName,ParentCategoryCode,CategoryCode,CategoryName from 
(select AreaCode,NodeCode ,NodeName from 
TB部门信息表 
where AreaCode in (0,1,4,5,6,7,8,9) and len(AreaCode)<>0)a,
(select ParentCategoryCode,CategoryCode,CategoryName from 
TB商品分类表
where CategoryLevel='2' and CategoryItemCode='0000' and CategoryCode not like '0%' and CategoryCode not in (19,23,28,29))b
where 1=1 ${if(len(bm) == 0,   "",   "and NodeCode  in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl2) == 0,   "",   "and CategoryCode in ('" + replace(fl2,",","','")+"')") }
order by 1,2,5



select g.AreaCode yt_Code,a.部门编码 NodeCode,a.fl1 GoodsCatCode1,a.fl2 GoodsCatCode,
ISNULL(a.SKU,0) 可订货SKU,ISNULL(d.SKU,0) 非中央控制缺货SKU,ISNULL(f.SKU,0) 门店职责缺货SKU
 from 
(select 部门编码,LEFT(a.五级分类编码,1)fl1,LEFT(a.五级分类编码,2)fl2 ,COUNT(商品编码)SKU from 
dbo.TB${YM}_报表数据源 a 
WHERE 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in ('" + replace(bm,",","','")+"')") } 
and  1=1 ${if(len(fl2) == 0,   "",   "and left(a.五级分类编码,2) in ('" + replace(fl2,",","','")+"')") } 
and  报表日期<='${rq}' and 五级分类编码 not like '1%' and 五级分类编码 not like '2%' and 五级分类编码 not like '6%' and 五级分类编码 not like '300%'
and  a.经营状态 in (1,2,5) and a.商品类型=0
GROUP BY 部门编码,LEFT(a.五级分类编码,1),LEFT(a.五级分类编码,2))A
left join 
dbo.TB商品分类表 c on a.fl2=c.CategoryCode  and c.CategoryItemCode='0000'
LEFT JOIN
(select 部门编码,LEFT(a.五级分类编码,1)fl1,LEFT(a.五级分类编码,2)fl2 ,COUNT(商品编码)SKU from 
dbo.TB${YM}_报表数据源 a 
WHERE 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in ('" + replace(bm,",","','")+"')") } 
and  1=1 ${if(len(fl2) == 0,   "",   "and left(a.五级分类编码,2) in ('" + replace(fl2,",","','")+"')") } 
and  报表日期<='${rq}' and 五级分类编码 not like '1%' and 五级分类编码 not like '2%' and 五级分类编码 not like '6%' and 五级分类编码 not like '300%'
and  a.经营状态 in (1,2,5) and a.商品类型=0

and 库存数量<=0 and ((a.促销DMS +a.正常DMS =0.00 and 中央控制标识=0) or 中央控制标识=1)
GROUP BY 部门编码,LEFT(a.五级分类编码,1),LEFT(a.五级分类编码,2))d on a.fl2=d.fl2  and A.部门编码=d.部门编码

LEFT JOIN
(select 部门编码,LEFT(a.五级分类编码,1)fl1,LEFT(a.五级分类编码,2)fl2 ,COUNT(商品编码)SKU from 
dbo.TB${YM}_报表数据源 a 
WHERE 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in ('" + replace(bm,",","','")+"')") } 
and  1=1 ${if(len(fl2) == 0,   "",   "and left(a.五级分类编码,2) in ('" + replace(fl2,",","','")+"')") } 
and  报表日期<='${rq}' and 五级分类编码 not like '1%' and 五级分类编码 not like '2%' and 五级分类编码 not like '6%' and 五级分类编码 not like '300%'
and  a.经营状态 in (1,2,5) and a.商品类型=0

and 库存数量<=0 and  a.促销DMS +a.正常DMS >0.00 and 中央控制标识=0
GROUP BY 部门编码,LEFT(a.五级分类编码,1),LEFT(a.五级分类编码,2))f on a.fl2=f.fl2  and A.部门编码=f.部门编码
left join 
TB部门信息表 g on A.部门编码=g.NodeCode 



