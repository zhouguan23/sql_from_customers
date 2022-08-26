select A.AreaCode,A.AreaName,a.NodeCode DeptCode,A.WhetherNew,B.CategoryCode,isnull(SUM(Salesindex),0)Salesindex,isnull(SUM(Grossprofitindex),0)Grossprofitindex  from 
TB部门信息表 A
LEFT JOIN 
含税分课预算表 B ON A.NodeCode=b.DeptCode and BudgetYM = convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)and CategoryItemCode in ('0000','0002')
WHERE  (a.NodeCode LIKE '1%' or a.NodeCode LIKE '2%')   and CategoryCode like '1%'
GROUP BY A.AreaCode,A.AreaName,a.NodeCode ,A.WhetherNew,B.CategoryCode
ORDER BY 3,4,1,2

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 ='+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=2' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,商品分类编码 GoodsCatCode
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
WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND
商品分类编码 LIKE ''1%''
GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew,商品分类编码
ORDER BY 1,3,4,6


'exec(@sql1)

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT  a.*,b.CategoryCode FROM '+[name]A+' a ,tb商品档案 B  where   OccurDate ='+@dqrq+'  and a.goodscode=b.goodscode and b.CategoryCode  like ''1%'' ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssm' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT  a.*,b.CategoryCode FROM '+[name]A+' a ,tb商品档案 B  where   StockDate ='+@dqrq+'  and a.goodscode=b.goodscode and b.CategoryCode  like ''1%'' ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_DAYStocks' and SUBSTRING(name,3,6) = @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL1='

select A.AreaCode,A.AreaName,a.nodecode DeptCode ,a.WhetherNew,left(b.CategoryCode,2) GoodsCatCode --组
,isnull(SaleMoney,0)SaleMoney,isnull(SaleGrossProfit,0)SaleGrossProfit,isnull(TaxCost,0)TaxCost  --值

from 
TB部门信息表 A,
 (select nodecode,left(CategoryCode,2)CategoryCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit 
 from 
 ('+@SQL+') a 
 group by nodecode,left(CategoryCode,2))  B
 left join 
 (select DeptCode,left(CategoryCode,2) CategoryCode,sum(TaxCost)TaxCost 
 from ('+@SQL2+')a 
 group by DeptCode,left(CategoryCode,2))  c on b.nodecode =c.DeptCode and left(b.CategoryCode,2) =left(c.CategoryCode,2) 
WHERE A.NodeCode=b.nodecode and  (a.nodecode LIKE ''1%'' OR a.nodecode LIKE ''2%'') 

ORDER BY 1,3,5


'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 ='+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=1' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,商品分类编码 GoodsCatCode
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
WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND
商品分类编码 LIKE ''1%''
GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew,商品分类编码
ORDER BY 1,3,4,6


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


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT  a.*,b.CategoryCode FROM '+[name]A+' a ,tb商品档案 B  where   OccurDate ='+@dqrq+'  and a.goodscode=b.goodscode and b.CategoryCode  like ''1%'' ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssm' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')



SET @SQL1='

select A.AreaCode,A.AreaName,a.nodecode DeptCode ,a.WhetherNew,left(b.CategoryCode,2) GoodsCatCode --组
,isnull(SaleMoney,0)SaleMoney,isnull(SaleGrossProfit,0)SaleGrossProfit  --值

from 
TB部门信息表 A,
 (select nodecode,left(CategoryCode,2)CategoryCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit 
 from 
 ('+@SQL+') a 
 group by nodecode,left(CategoryCode,2))  B

WHERE A.NodeCode=b.nodecode and  (a.nodecode LIKE ''1%'' OR a.nodecode LIKE ''2%'') 

ORDER BY 1,3,5


'exec(@sql1)


select * from 
TBDAYCARRYLOG a
where a.CarryDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT  a.*,b.CategoryCode FROM '+[name]A+' a ,tb商品档案 B  where   OccurDate ='+@dqrq+'  and a.goodscode=b.goodscode and b.CategoryCode not like ''6%'' and b.CategoryCode not like ''0%'' ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssm' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select A.AreaCode,A.AreaName,a.nodecode DeptCode ,a.WhetherNew,left(b.CategoryCode,2) GoodsCatCode --组
,isnull(SaleMoney,0)SaleMoney,isnull(SaleGrossProfit,0)SaleGrossProfit  --值

from 
TB部门信息表 A,
 (select nodecode,left(CategoryCode,2)CategoryCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit 
 from 
 ('+@SQL+') a 
 group by nodecode,left(CategoryCode,2))  B

WHERE A.NodeCode=b.nodecode and  (a.nodecode LIKE ''1%'' OR a.nodecode LIKE ''2%'') 

ORDER BY 1,3,5


'exec(@sql1)


