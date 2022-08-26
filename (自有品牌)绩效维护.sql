 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  Occurdate between  '+@qsrq+' and '+@dqrq+' 	and 1=1 ${if(len(bm) == 0,   "",   "and NodeCode in (''" + replace(bm,",","'',''")+"'')") } '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPSSM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select ParentCategoryCode,a.CategoryCode ,a.CategoryName,a.NodeCode DeptCode ,isnull(b.Salesindex,0)Salesindex,isnull(b.Grossprofitindex,0)Grossprofitindex,isnull(SaleMoney,0)SaleMoney,isnull(SaleGrossProfit,0)SaleGrossProfit from 
(select a.CategoryItemCode,ParentCategoryCode,CategoryCode ,CategoryName,c.NodeCode  from 
(select a.CategoryItemCode,A.CategoryCode ParentCategoryCode,B.CategoryCode,B.CategoryName from 
HLCWDW.DBO.TB分类对照表 a 
left join 
HLCWDW.DBO.TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and b.ParentCategoryCode=a.CategoryCode

where a.CategoryItemCode=''0007'' and a.CategoryLevel=''0'' 


)a,hldw.dbo.TB部门信息表 c
    where left(c.nodecode,1) between 1 and 2
	and 1=1 ${if(len(bm) == 0,   "",   "and c.NodeCode in (''" + replace(bm,",","'',''")+"'')") }
    )a
    left join 
(
select DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
HLCWDW.DBO.[含税分课预算表]A b
where BudgetYM between '+@qsny+' and '+@jsny+' and CategoryItemCode=''0001''
group by DeptCode ,CategoryCode)b on a.CategoryCode=b.CategoryCode  and a.NodeCode=b.DeptCode 
left join 
(


select NodeCode ,case
when (CategoryCode like ''1%'' or CategoryCode like ''2%'')  then ''10''
when (CategoryCode like ''30%'' or CategoryCode like ''32%'' or CategoryCode like ''33%'')  then ''30''
when (CategoryCode like ''31%'')  then ''31''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'')  then ''46''
when (CategoryCode like ''5%'')  then ''50''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'')  then ''40''
else CategoryCode end CategoryCode
,SUM(SaleIncome+SaleTax)SaleMoney,SUM(TAXSaleGrossProfit)SaleGrossProfit   from 
TB商品档案 a , ('+@SQL+')  b 
where a.GoodsCode =b.GoodsCode  and (NodeCode like ''1%'' or NodeCode like ''2%'') and CategoryCode not like ''0%'' and CategoryCode not like ''6%''  and GoodsBrand=''010001''
group by NodeCode ,case
when (CategoryCode like ''1%'' or CategoryCode like ''2%'')  then ''10''
when (CategoryCode like ''30%'' or CategoryCode like ''32%'' or CategoryCode like ''33%'')  then ''30''
when (CategoryCode like ''31%'')  then ''31''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'')  then ''46''
when (CategoryCode like ''5%'')  then ''50''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'')  then ''40''
else CategoryCode end 
)c on a.NodeCode=c.NodeCode and a.CategoryCode=c.CategoryCode



ORDER BY 4,2



'exec(@sql1)



select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表 a

where   1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}


and  left(a.nodecode,1) between 1 and 2 and a.nodecode not in (6601) 

select a.CategoryCode,a.CategoryCode+' '+a.CategoryName CategoryName from 
HLCWDW.DBO.TB分类对照表 a 


where a.CategoryItemCode='0007' 

