select A.AreaCode,A.AreaName,a.NodeCode DeptCode,A.WhetherNew,left(case when (CategoryCode like '1%' or CategoryCode like '3%') then '30' 
when CategoryCode like '4%' and CategoryCode not like '46%' and CategoryCode not like '47%' then '40'
when CategoryCode like '46%' or CategoryCode like '47%' then '46'
when CategoryCode like '5%' then '50' end,1) Category1Code,case when (CategoryCode like '1%' or CategoryCode like '3%') then '30' 
when CategoryCode like '4%' and CategoryCode not like '46%' and CategoryCode not like '47%' then '40'
when CategoryCode like '46%' or CategoryCode like '47%' then '46'
when CategoryCode like '5%' then '50' end CategoryCode,isnull(SUM(Salesindex),0)Salesindex,isnull(SUM(Grossprofitindex),0)Grossprofitindex  from 
TB部门信息表 A
LEFT JOIN 
含税分课预算表 B ON A.NodeCode=b.DeptCode and BudgetYM = convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)and CategoryItemCode in ('0001') and CategoryCode not like '2%'
WHERE  (a.NodeCode LIKE '1%' or a.NodeCode LIKE '2%') and a.NodeCode not in ('1047')    
and A.OpenDate<='20181227'
GROUP BY A.AreaCode,A.AreaName,a.NodeCode ,A.WhetherNew,
left(case when (CategoryCode like '1%' or CategoryCode like '3%') then '30' 
when CategoryCode like '4%' and CategoryCode not like '46%' and CategoryCode not like '47%' then '40'
when CategoryCode like '46%' or CategoryCode like '47%' then '46'
when CategoryCode like '5%' then '50' end,1),case when (CategoryCode like '1%' or CategoryCode like '3%') then '30' 
when CategoryCode like '4%' and CategoryCode not like '46%' and CategoryCode not like '47%' then '40'
when CategoryCode like '46%' or CategoryCode like '47%' then '46'
when CategoryCode like '5%' then '50' end
ORDER BY 3,4,5,6,1,2

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  occurdate ='+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select c.DeptCategoryCode,a.DeptCode,case when b.DeptCategoryCode in (02,06) then ''1'' else ''0'' END WhetherNew ,a.Category1Code,a.GoodsCatCode,
a.SaleMoney,a.SaleGrossProfit
from 
(select nodecode DeptCode ,left(case when (CategoryCode like ''1%'' or CategoryCode like ''3%'') then ''30'' 
when CategoryCode like ''4%'' and CategoryCode not like ''46%'' and CategoryCode not like ''47%'' then ''40''
when CategoryCode like ''46%'' or CategoryCode like ''47%'' then ''46''
when CategoryCode like ''5%'' then ''50'' end,1)Category1Code,case when (CategoryCode like ''1%'' or CategoryCode like ''3%'') then ''30'' 
when CategoryCode like ''4%'' and CategoryCode not like ''46%'' and CategoryCode not like ''47%'' then ''40''
when CategoryCode like ''46%'' or CategoryCode like ''47%'' then ''46''
when CategoryCode like ''5%'' then ''50'' end GoodsCatCode,
sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
[000]A.TBGOODS A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND
GoodsBrand LIKE ''010001''
GROUP BY nodecode,left(case when (CategoryCode like ''1%'' or CategoryCode like ''3%'') then ''30'' 
when CategoryCode like ''4%'' and CategoryCode not like ''46%'' and CategoryCode not like ''47%'' then ''40''
when CategoryCode like ''46%'' or CategoryCode like ''47%'' then ''46''
when CategoryCode like ''5%'' then ''50'' end,1),case when (CategoryCode like ''1%'' or CategoryCode like ''3%'') then ''30'' 
when CategoryCode like ''4%'' and CategoryCode not like ''46%'' and CategoryCode not like ''47%'' then ''40''
when CategoryCode like ''46%'' or CategoryCode like ''47%'' then ''46''
when CategoryCode like ''5%'' then ''50'' end)a
left join 
[000]A.TBCATTODEPARTMENT b on a.deptcode =b.nodecode  and b.DeptCatItemCode =''0000''
left join 
[000]A.TBCATTODEPARTMENT c on a.deptcode =c.nodecode  and c.DeptCatItemCode =''0013''

ORDER BY 1,2,3,4


'exec(@sql1)




 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  occurdate ='+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select c.DeptCategoryCode,a.DeptCode,case when b.DeptCategoryCode in (02,06) then ''1'' else ''0'' END WhetherNew ,a.Category1Code,a.GoodsCatCode,a.SaleMoney,a.SaleGrossProfit
from 
(select nodecode DeptCode ,left(case when (CategoryCode like ''1%'' or CategoryCode like ''3%'') then ''30'' 
when CategoryCode like ''4%'' and CategoryCode not like ''46%'' and CategoryCode not like ''47%'' then ''40''
when CategoryCode like ''46%'' or CategoryCode like ''47%'' then ''46''
when CategoryCode like ''5%'' then ''50'' end,1)Category1Code,case when (CategoryCode like ''1%'' or CategoryCode like ''3%'') then ''30'' 
when CategoryCode like ''4%'' and CategoryCode not like ''46%'' and CategoryCode not like ''47%'' then ''40''
when CategoryCode like ''46%'' or CategoryCode like ''47%'' then ''46''
when CategoryCode like ''5%'' then ''50'' end GoodsCatCode,
sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
[000]A.TBGOODS A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND
GoodsBrand LIKE ''010001''
GROUP BY nodecode,left(case when (CategoryCode like ''1%'' or CategoryCode like ''3%'') then ''30'' 
when CategoryCode like ''4%'' and CategoryCode not like ''46%'' and CategoryCode not like ''47%'' then ''40''
when CategoryCode like ''46%'' or CategoryCode like ''47%'' then ''46''
when CategoryCode like ''5%'' then ''50'' end,1),case when (CategoryCode like ''1%'' or CategoryCode like ''3%'') then ''30'' 
when CategoryCode like ''4%'' and CategoryCode not like ''46%'' and CategoryCode not like ''47%'' then ''40''
when CategoryCode like ''46%'' or CategoryCode like ''47%'' then ''46''
when CategoryCode like ''5%'' then ''50'' end)a
left join 
[000]A.TBCATTODEPARTMENT b on a.deptcode =b.nodecode  and b.DeptCatItemCode =''0000''
left join 
[000]A.TBCATTODEPARTMENT c on a.deptcode =c.nodecode  and c.DeptCatItemCode =''0013''

ORDER BY 1,2,3,4


'exec(@sql1)




 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  occurdate ='+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select c.DeptCategoryCode AreaCode,DeptCode,case when b.DeptCategoryCode in (02,06) then ''1'' else ''0'' END WhetherNew ,a.GoodsCatCode,SaleMoney,SaleGrossProfit
from 
(select nodecode DeptCode,'''' GoodsCatCode,
sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
[000]A.TBGOODS A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND
GoodsBrand LIKE ''010001''
GROUP BY nodecode)a
left join 
[000]A.TBCATTODEPARTMENT b on a.deptcode =b.nodecode  and b.DeptCatItemCode =''0000''
left join 
[000]A.TBCATTODEPARTMENT c on a.deptcode =c.nodecode  and c.DeptCatItemCode =''0013''
ORDER BY 1,2,3,4


'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  occurdate ='+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select c.DeptCategoryCode,a.DeptCode,case when b.DeptCategoryCode in (02,06) then ''1'' else ''0'' END WhetherNew ,a.Category1Code,a.GoodsCatCode,
a.SaleMoney,a.SaleGrossProfit
from 
(select nodecode DeptCode ,left(CategoryCode,1)Category1Code,left(CategoryCode,2) GoodsCatCode,
sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
[000]A.TBGOODS A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  
GROUP BY nodecode,left(CategoryCode,1),left(CategoryCode,2))a
left join 
[000]A.TBCATTODEPARTMENT b on a.deptcode =b.nodecode  and b.DeptCatItemCode =''0000''
left join 
[000]A.TBCATTODEPARTMENT c on a.deptcode =c.nodecode  and c.DeptCatItemCode =''0013''

ORDER BY 1,2,3,4


'exec(@sql1)




select * from 
	dbo.日期对照表
	where OccurDate =convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  EnterAccountDate ='+@dqrq+' and GoodsPropertyCode=''2005'' and CategoryLevel=2 ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_特殊分类销售' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select A.AreaCode,A.AreaName,b.DeptCode ,WhetherNew,GoodsCatCode GoodsCatCode
,sum(SaleCount)SaleCount,sum(SaleIncome+SaleTax)SaleMoney,sum(TAXSaleGrossProfit)SaleGrossProfit  from 
TB部门信息表 A,
 ('+@SQL+')  B
WHERE A.NodeCode=b.DeptCode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND
GoodsCatCode LIKE ''1%'' 
GROUP BY A.AreaCode,A.AreaName,b.DeptCode,WhetherNew,GoodsCatCode
ORDER BY 1,3,4,5


'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  EnterAccountDate ='+@dqrq+' and GoodsPropertyCode=''2005'' and CategoryLevel=1 ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_特殊分类销售' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select A.AreaCode,A.AreaName,b.DeptCode ,WhetherNew,GoodsCatCode GoodsCatCode
,sum(SaleCount)SaleCount,sum(SaleIncome+SaleTax)SaleMoney,sum(TAXSaleGrossProfit)SaleGrossProfit  from 
TB部门信息表 A,
 ('+@SQL+')  B
WHERE A.NodeCode=b.DeptCode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND
GoodsCatCode LIKE ''1%'' 
GROUP BY A.AreaCode,A.AreaName,b.DeptCode,WhetherNew,GoodsCatCode
ORDER BY 1,3,4,5


'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  occurdate ='+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select c.DeptCategoryCode AreaCode,DeptCode,case when b.DeptCategoryCode in (02,06) then ''1'' else ''0'' END WhetherNew ,a.GoodsCatCode,SaleMoney,SaleGrossProfit
from 
(select nodecode DeptCode,'''' GoodsCatCode,
sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
[000]A.TBGOODS A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND
GoodsBrand LIKE ''010001''
GROUP BY nodecode)a
left join 
[000]A.TBCATTODEPARTMENT b on a.deptcode =b.nodecode  and b.DeptCatItemCode =''0000''
left join 
[000]A.TBCATTODEPARTMENT c on a.deptcode =c.nodecode  and c.DeptCatItemCode =''0013''
ORDER BY 1,2,3,4


'exec(@sql1)


