select CategoryCode,CategoryName from 
[000]A.TBDEPTCATEGORY 
where  CategoryItemCode ='0013'

select CategoryCode,CategoryName from 
[000]A.TBDEPTCATEGORY 
where  CategoryItemCode ='0011'

select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表

where 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")} and left(nodecode,1) in ('9') and nodecode not in ('9999') and len(AreaCode)>0 

select ParentCategoryCode,CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 6 and 6 and LEN(CategoryCode)<3

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
	left(a.GoodsCatCode,1)GoodsCatCode1,case when left(a.GoodsCatCode,1)=2 then 2 else  a.GoodsCatCode end GoodsCatCode ,
	isnull(sum(b.SaleCost),0)SaleCost ,isnull(sum(a.StockCost),0)Cost from 
	(select DepartmentCode nodecode,left(CategoryCode,2)GoodsCatCode, SUM(StockCost)StockCost from 
[000]A .tb'+@jsny+'_Reportinfo a 
where ReportDate='+@dqrq+' 
and DepartmentCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 9 and 9 and a.nodecode not in (9999,9019)
and a.State=0 and b.NodeType in (0,2) and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
and not exists (select * from 
[000]A .TBGOODSPROPINCLUSIONS b
where  a.goodscode=b.goodscode and a.DepartmentCode in (''9999''''9019''))

and 1=1 ${if(len(bm) == 0,   "",   "and a.DepartmentCode  in (''" + replace(bm,",","'',''")+"'')") }
and 1=1 ${if(len(fl1) == 0,   "",   "and left(a.CategoryCode,1) in (''" + replace(fl1,",","'',''")+"'')") }
and 1=1 ${if(len(fl2) == 0,   "",   "and left(a.CategoryCode,2) in (''" + replace(fl2,",","'',''")+"'')") }
and left(CategoryCode,1) between 6 and 6 
and GoodsType not in (1,6,7) 

group by DepartmentCode,left(CategoryCode,2)
) a 
	left join 
	
	(select nodecode,GoodsCatCode,sum(SaleCost)SaleCost from 
	
	(select DepartmentCode nodecode,left(CategoryCode,2)GoodsCatCode,SUM(CommonSaleCost+PromotionSaleCost) SaleCost 
	from [000]A .tb'+@qsny+'_REPORTINFO a where ReportDate between '+@qsrq+' and  '+@dqrq+' 
	
and GoodsType not in (1,6,7)  
and not exists (select * from 
[000]A .TBGOODSPROPINCLUSIONS b
where  a.goodscode=b.goodscode and a.DepartmentCode in (''9999''''9019''))

group by DepartmentCode,left(CategoryCode,2)
	union all 
	select DepartmentCode nodecode,left(CategoryCode,2)GoodsCatCode,SUM(CommonSaleCost+PromotionSaleCost) SaleCost 
	from [000]A .tb'+@Jsny+'_REPORTINFO a where ReportDate between '+@qsrq+' and  '+@dqrq+' 
and GoodsType not in (1,6,7)  
and not exists (select * from 
[000]A .TBGOODSPROPINCLUSIONS b
where  a.goodscode=b.goodscode and a.DepartmentCode in (''9999''''9019''))



group by DepartmentCode,left(CategoryCode,2))b
	where  GoodsCatCode not like ''0%'' and 
	nodecode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 9 and 9 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))




	group by nodecode,GoodsCatCode )b  on a.NodeCode =b.NodeCode and a.GoodsCatCode =b.GoodsCatCode
	
	left join
(select a.DeptCategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0008''
where  a.DeptCatItemCode =''0008'')c on a.nodecode=c.nodecode
left join
(select a.DeptCategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0013''
where  a.DeptCatItemCode =''0013'')d on a.nodecode=d.nodecode
	
where   1=1 ${if(len(yt) == 0,   "",   "and c.DeptCategoryCode in (''" + replace(yt,",","'',''")+"'')") }
and   1=1 ${if(len(dq) == 0,   "",   "and d.DeptCategoryCode in (''" + replace(dq,",","'',''")+"'')") }
	group by d.DeptCategoryCode,d.CategoryName,a.nodecode,left(a.GoodsCatCode,1),case when left(a.GoodsCatCode,1)=2 then 2 else  a.GoodsCatCode end
    order by 1,3,5,6
	'exec (@sQL1)


