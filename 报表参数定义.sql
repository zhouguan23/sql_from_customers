select a.ParentCategoryCode,a.CategoryCode,a.CategoryName,a.CategoryLevel,isnull(zdycdate,0)UnSalaNotSellDayMAX from 
[000]A.TBGOODSCATEGORY a  
left join 
goodsunsalabledate b on a.CategoryCode=b.CategoryCode
where CategoryItemCode='0000' 
and a.CategoryCode  not like '0%' 
and a.CategoryCode  not like '6%' 
and 1=1 ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(dj) == 0,   "",   "and a.CategoryLevel in ('" + replace(dj,",","','")+"')") }
order by 2,1,4

select ParentCategoryCode,CategoryCode,CategoryName,CategoryLevel,
isnull(OOSCanSellDay,0)OOSCanSellDay,isnull(SalaDayAvgSell,0)SalaDayAvgSell,
isnull(HighStockCanSellDay,0)HighStockCanSellDay,isnull(HighStockMoney,0)HighStockMoney,
isnull(UnSalaNotSellDay,0)UnSalaNotSellDay,isnull(UnSalaNotSellDayMAX,0)UnSalaNotSellDayMAX from 
TB商品分类表 a  
left join 
TBREPORTPARADEFINE b on a.CategoryCode=b.GoodsCode and b.DeptType='0'
where CategoryItemCode='0000' 
and CategoryCode  not like '0%' 
and CategoryCode  not like '6%' 
and CategoryLevel like '2'
order by 2,1,4

select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}


select ParentCategoryCode,CategoryCode,CategoryName,CategoryLevel,
isnull(OOSCanSellDay,0)OOSCanSellDay,isnull(SalaDayAvgSell,0)SalaDayAvgSell,
isnull(HighStockCanSellDay,0)HighStockCanSellDay,isnull(HighStockMoney,0)HighStockMoney,
isnull(UnSalaNotSellDay,0)UnSalaNotSellDay,isnull(UnSalaNotSellDayMAX,0)UnSalaNotSellDayMAX from 
TB商品分类表 a  
left join 
TBREPORTPARADEFINE b on a.CategoryCode=b.GoodsCode and b.DeptType='0'
where CategoryItemCode='0000' 
and CategoryCode  not like '0%' 
and CategoryCode  not like '6%' 
and CategoryLevel like '3'
order by 2,1,4

select ParentCategoryCode,CategoryCode,CategoryName,CategoryLevel,
isnull(OOSCanSellDay,0)OOSCanSellDay,isnull(SalaDayAvgSell,0)SalaDayAvgSell,
isnull(HighStockCanSellDay,0)HighStockCanSellDay,isnull(HighStockMoney,0)HighStockMoney,
isnull(UnSalaNotSellDay,0)UnSalaNotSellDay,isnull(UnSalaNotSellDayMAX,0)UnSalaNotSellDayMAX from 
TB商品分类表 a  
left join 
TBREPORTPARADEFINE b on a.CategoryCode=b.GoodsCode and b.DeptType='0'
where CategoryItemCode='0000' 
and CategoryCode  not like '0%' 
and CategoryCode  not like '6%' 
and CategoryLevel like '4'
order by 2,1,4

select ParentCategoryCode,CategoryCode,CategoryName,CategoryLevel,
isnull(OOSCanSellDay,0)OOSCanSellDay,isnull(SalaDayAvgSell,0)SalaDayAvgSell,
isnull(HighStockCanSellDay,0)HighStockCanSellDay,isnull(HighStockMoney,0)HighStockMoney,
isnull(UnSalaNotSellDay,0)UnSalaNotSellDay,isnull(UnSalaNotSellDayMAX,0)UnSalaNotSellDayMAX from 
TB商品分类表 a  
left join 
TBREPORTPARADEFINE b on a.CategoryCode=b.GoodsCode and b.DeptType='0'
where CategoryItemCode='0000' 
and CategoryCode  not like '0%' 
and CategoryCode  not like '6%' 
and CategoryLevel like '5'
order by 2,1,4

