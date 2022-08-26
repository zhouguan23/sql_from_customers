select AreaCode,NodeCode DeptCode,LEFT(a.CategoryCode,1)商品分类编码,SUM(isnull(Salesindex,0))Salesindex,SUM(isnull(Grossprofitindex,0))Grossprofitindex from 
(select  AreaCode,NodeCode ,c.CategoryCode
from TB部门信息表 b,TB商品分类表  c
where  (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and c.CategoryItemCode='0000' and c.CategoryLevel=1 
and left(c.CategoryCode,1) between 1 and 5) a
left join 
含税分课预算表 b on a.NodeCode =b.DeptCode and a.CategoryCode=left(b.CategoryCode,1)  and b.CategoryItemCode='0000' and b.BudgetYM between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
where   1=1 ${if(len(bm) == 0,   "",   "and a.AreaCode in ('" + replace(bm,",","','")+"')") }
and NodeCode NOT IN ('1047')
group by AreaCode,NodeCode ,LEFT(a.CategoryCode,1)
order by 2,3,1

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between '+@qsrq+' and  '+@dqrq+' and 商品分类项编码=''0000'' 
and 商品分类等级=1 and 商品分类编码 not like ''0%'' and 商品分类等级 not like ''6%'' ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between @qsny and  @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select ROW_NUMBER() OVER ( partition by  部门编码 ORDER BY 报表日期 ASC) AS XUHAO,A.AreaCode,A.AreaName,报表日期,部门编码 DeptCode ,WhetherNew,商品分类编码 
,sum(来客数)SaleCount,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
sum(促销销售收入)+sum(促销销项税金)CXSaleMoney,sum(促销销售收入)+sum(促销销项税金)-sum(含税促销销售成本)CXSaleGrossProfit,
sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
TB部门信息表 A,
 ('+@SQL+')  B
WHERE A.NodeCode=b.部门编码 and 1=1 ${if(len(bm) == 0,   "",   "and a.AreaCode in (''" + replace(bm,",","'',''")+"'')") } 
GROUP BY A.AreaCode,A.AreaName,报表日期,部门编码,WhetherNew,商品分类编码 
ORDER BY 1,3,4,5

'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tbqsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  occurdate between  '+@qsrq+' and '+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select c.DeptCategoryCode  AreaCode,a.DeptCode,case when b.DeptCategoryCode in (02,06) then ''1'' else ''0'' END WhetherNew ,a.GoodsCatCode 商品分类编码,a.SaleMoney,a.SaleGrossProfit
from 
(select nodecode DeptCode ,left(CategoryCode,1)GoodsCatCode,
sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
[000]A.TBGOODS A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  
GROUP BY nodecode,left(CategoryCode,1))a
left join 
[000]A.TBCATTODEPARTMENT b on a.deptcode =b.nodecode  and b.DeptCatItemCode =''0000''
left join 
[000]A.TBCATTODEPARTMENT c on a.deptcode =c.nodecode  and c.DeptCatItemCode =''0013''
where 1=1 ${if(len(bm) == 0,   "",   "and c.DeptCategoryCode in (''" + replace(bm,",","'',''")+"'')") } 
ORDER BY 1,2,3,4


'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between '+@qsrq+' and  '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=0' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between @qsny and  @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select * from (
select ROW_NUMBER() OVER(order by sum(销售金额) desc) as 全公司排名,ROW_NUMBER() OVER(partition by AreaCode order by sum(销售金额) desc) as 大区排名,
FormatCode,A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,0 GoodsCatCode
,sum(来客数)SaleCount,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
sum(促销销售收入)+sum(促销销项税金)CXSaleMoney,sum(促销销售收入)+sum(促销销项税金)-sum(含税促销销售成本)CXSaleGrossProfit,
sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
TB部门信息表 A,
 ('+@SQL+')  B
WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 

GROUP BY FormatCode,A.AreaCode,A.AreaName,部门编码,WhetherNew)a
where 1=1 ${if(len(bm) == 0,   "",   "and a.AreaCode in (''" + replace(bm,",","'',''")+"'')") } 
ORDER BY 3,4


'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tbqsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  occurdate between  '+@qsrq+' and '+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select c.DeptCategoryCode  AreaCode,a.DeptCode,case when b.DeptCategoryCode in (02,06) then ''1'' else ''0'' END WhetherNew ,0 商品分类编码,a.SaleMoney,a.SaleGrossProfit
from 
(select nodecode DeptCode ,
sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
[000]A.TBGOODS A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  
GROUP BY nodecode)a
left join 
[000]A.TBCATTODEPARTMENT b on a.deptcode =b.nodecode  and b.DeptCatItemCode =''0000''
left join 
[000]A.TBCATTODEPARTMENT c on a.deptcode =c.nodecode  and c.DeptCatItemCode =''0013''
where 1=1 ${if(len(bm) == 0,   "",   "and c.DeptCategoryCode in (''" + replace(bm,",","'',''")+"'')") } 
ORDER BY 1,2,3,4


'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  BuildDate = '+@dqrq+' ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_租赁商品销售明细' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select ROW_NUMBER() OVER ( partition by  DeptCode ORDER BY BuildDate ASC) AS XUHAO,BuildDate,DeptCode ,WhetherNew,left(goodscode,2) GoodsCatCode
,sum(SaleIncome+SaleTax)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
TB部门信息表 A,
 ('+@SQL+')  B
WHERE A.NodeCode=b.DeptCode  and  (nodecode LIKE ''1%'' or nodecode LIKE ''1%'') and goodscode like ''2%''
GROUP BY BuildDate,DeptCode ,WhetherNew,left(goodscode,2)
ORDER BY 1,2,3,4

'exec(@sql1)



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 ='+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=0' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,0 GoodsCatCode
,sum(来客数)SaleCount,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
sum(促销销售收入)+sum(促销销项税金)CXSaleMoney,sum(促销销售收入)+sum(促销销项税金)-sum(含税促销销售成本)CXSaleGrossProfit,
sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
TB部门信息表 A,
 ('+@SQL+')  B
WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' )  
group by A.AreaCode,A.AreaName,部门编码 ,WhetherNew


'exec(@sql1)

select * from 
	dbo.日期对照表
	where OccurDate =convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

select distinct AreaCode,AreaName from dbo.TB部门信息表 where areacode='${bm}'

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,dateadd(dd,-day(@dqrq)+1,@dqrq)),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=0' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between @qsny and  @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select AreaCode,SUM(Salesindex)Salesindex,SUM(Grossprofitindex)Grossprofitindex,
sum(SaleMoney)SaleMoney,sum(SaleGrossProfit )SaleGrossProfit from 
TB部门信息表 a ,
(select  DeptCode ,SUM(Salesindex)Salesindex,SUM(Grossprofitindex)Grossprofitindex
,sum(SaleMoney)SaleMoney,sum(SaleMoney)SaleGrossProfit
  from 
(select  DeptCode ,SUM(Salesindex)Salesindex,SUM(Grossprofitindex)Grossprofitindex 
from 含税分课预算表
where  BudgetYM between '+@qsny+' and '+@jsny+' and CategoryItemCode=''0000''
group by DeptCode) A,
 (
 select 部门编码,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit
  from ( '+@SQL+')a
   group by  部门编码 ) B
WHERE  A.deptcode=b.部门编码 
GROUP BY DeptCode)b
where A.NodeCode=b.deptcode  and 1=1 ${if(len(bm) == 0,   "",   "and a.AreaCode in (''" + replace(bm,",","'',''")+"'')") } 
group by AreaCode
order by 1


'exec(@sql1)

