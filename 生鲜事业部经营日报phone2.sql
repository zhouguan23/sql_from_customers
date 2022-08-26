 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8),
@tqjsny varchar(6), @tqqsny varchar(6),@tqqsrq varchar(8),@tqdqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
set @tqdqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @tqjsny=@tqdqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between  '+@qsrq+' and '+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) between @qsny  and  @jsny

SET @SQL=STUFF(@SQL,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where occurdate = '+@tqdqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) =  @tqjsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL1='

select a.AreaCode,A.AreaName,a.DeptCode,A.OpenDate,a.CategoryCode ,isnull(a.Salesindex,0)Salesindex,isnull(b.SaleMoney,0)SaleMoney,isnull(a.Grossprofitindex,0)Grossprofitindex,isnull(b.SaleGrossProfit,0)SaleGrossProfit
,isnull(c.SaleMoney,0)  tb_SaleMoney
,isnull(c.SaleGrossProfit,0) tb_SaleGrossProfit
 from
(select A.AreaCode,A.AreaName,a.NodeCode DeptCode,A.OpenDate,B.CategoryCode ,isnull(SUM(Salesindex),0)Salesindex,isnull(SUM(Grossprofitindex),0)Grossprofitindex  from 
TB部门信息表 A
LEFT JOIN 
含税分课预算表 B ON A.NodeCode=b.DeptCode and BudgetYM between  '+@qsny+' and '+@jsny+' and CategoryItemCode in (''0000'',''0002'')
WHERE  (a.NodeCode LIKE ''1%'' or a.NodeCode LIKE ''2%'')   and CategoryCode like ''1%'' and State!=2
and 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in (''" + replace(bm,",","'',''")+"'')") } 
GROUP BY A.AreaCode,A.AreaName,a.NodeCode ,A.OpenDate,B.CategoryCode)a
left join 
(select nodecode DeptCode,left(CategoryCode,2)CategoryCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
tb商品档案 A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND CategoryCode LIKE ''1%''
GROUP BY nodecode,left(CategoryCode,2))b on a.deptcode=b.deptcode and a.CategoryCode=b.CategoryCode
   left join 
(select nodecode DeptCode,left(CategoryCode,2)CategoryCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
tb商品档案 A,
 ('+@SQL2+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND CategoryCode LIKE ''1%''
GROUP BY nodecode,left(CategoryCode,2))c on a.deptcode=c.deptcode and a.CategoryCode=c.CategoryCode
ORDER BY 3,5


'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 ='+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=1' 
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
 AND (商品分类编码 LIKE ''1%'')
GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew
ORDER BY 3,4


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
 AND 商品分类编码 LIKE ''1%''
GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew
ORDER BY 1,3,4


'exec(@sql1)

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8),
@tqjsny varchar(6), @tqqsny varchar(6),@tqqsrq varchar(8),@tqdqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
set @tqdqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @tqjsny=@tqdqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between  '+@qsrq+' and '+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) between @qsny  and  @jsny

SET @SQL=STUFF(@SQL,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where occurdate = '+@tqdqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) =  @tqjsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL1='

select a.AreaCode,A.AreaName,a.DeptCode,A.OpenDate,a.CategoryCode ,isnull(a.Salesindex,0)Salesindex,isnull(b.SaleMoney,0)SaleMoney,isnull(a.Grossprofitindex,0)Grossprofitindex,isnull(b.SaleGrossProfit,0)SaleGrossProfit
,isnull(c.SaleMoney,0)  tb_SaleMoney
,isnull(c.SaleGrossProfit,0) tb_SaleGrossProfit
 from
(select A.AreaCode,A.AreaName,a.NodeCode DeptCode,A.OpenDate,B.CategoryCode ,isnull(SUM(Salesindex),0)Salesindex,isnull(SUM(Grossprofitindex),0)Grossprofitindex  from 
TB部门信息表 A
LEFT JOIN 
含税分课预算表 B ON A.NodeCode=b.DeptCode and BudgetYM between  '+@qsny+' and '+@jsny+' and CategoryItemCode in (''0000'',''0002'')
WHERE  (a.NodeCode LIKE ''1%'' or a.NodeCode LIKE ''2%'')   and CategoryCode like ''1%'' and State!=2
and 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in (''" + replace(bm,",","'',''")+"'')") } 
GROUP BY A.AreaCode,A.AreaName,a.NodeCode ,A.OpenDate,B.CategoryCode)a
left join 
(select nodecode DeptCode,left(CategoryCode,2)CategoryCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
tb商品档案 A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND CategoryCode LIKE ''1%''
GROUP BY nodecode,left(CategoryCode,2))b on a.deptcode=b.deptcode and a.CategoryCode=b.CategoryCode
   left join 
(select nodecode DeptCode,left(CategoryCode,2)CategoryCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
tb商品档案 A,
 ('+@SQL2+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND CategoryCode LIKE ''1%''
GROUP BY nodecode,left(CategoryCode,2))c on a.deptcode=c.deptcode and a.CategoryCode=c.CategoryCode
ORDER BY 3,5


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
WHERE A.NodeCode=b.DeptCode  and  (nodecode LIKE ''9%'') 
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

select sum(来客数)SaleCount,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
sum(促销销售收入)+sum(促销销项税金)CXSaleMoney,sum(促销销售收入)+sum(促销销项税金)-sum(含税促销销售成本)CXSaleGrossProfit,
sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
TB部门信息表 A,
 ('+@SQL+')  B
WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  



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

select nodecode DeptCode,left(CategoryCode,2)GoodsCatCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
[000]A.TBGOODS A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND
CategoryCode LIKE ''1%''
GROUP BY nodecode,left(CategoryCode,2)
ORDER BY 1,2


'exec(@sql1)

select * from 
TBDAYCARRYLOG a
where a.CarryDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

