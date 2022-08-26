

select AreaCode,A.NodeCode DeptCode,WhetherNew ,
case when WhetherNew='1'  then '新店' when year='1'  then '开业1年以上' when year>'1'  then '开业2年以上' else '0' end year    ,
b.CategoryCode,
isnull(b.Salesindex,0) Salesindex,
isnull(b.Grossprofitindex,0) Grossprofitindex
 from 
(select AreaCode,NodeCode,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112))>=20  then 0 else 1 end  WhetherNew,
case when  datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') between 12 and 23 then 1 when datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') >=24 then 2 else 0 end  year
 from 
TB部门信息表
where State!=2  and (nodecode like '1%' or NodeCode like '2%') and OpenDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }
 )a
left join 
(select DeptCode,left(CategoryCode,2)CategoryCode,
sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%')  
and CategoryItemCode='0000' and CategoryCode like '1%' 
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)


group by DeptCode,left(CategoryCode,2))b on a.NodeCode=b.DeptCode





order by 1,4,3,2,5





 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=1

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and OpenDate<=''${dqrq}'' 
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
)a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and CategoryCode like ''1%''

GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsCatCode like ''1%''
GROUP BY DeptCode)c on a.nodecode= c.nodecode 



ORDER BY 1,2


'exec(@sql)







 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=1

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and OpenDate<=''${dqrq}'' 
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
)a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and CategoryCode like ''1%''

GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsCatCode like ''1%''
GROUP BY DeptCode)c on a.nodecode= c.nodecode 



ORDER BY 1,2


'exec(@sql)







 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=2

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,b.CategoryCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and OpenDate<=''${dqrq}''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
)a


left join 
(select nodecode ,left(CategoryCode,2) CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and CategoryCode like ''1%''

GROUP BY nodecode,left(CategoryCode,2))b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,GoodsCatCode CategoryCode,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsCatCode like ''1%''
GROUP BY DeptCode,GoodsCatCode)c on a.nodecode= c.nodecode and b.CategoryCode=c.CategoryCode 


ORDER BY 1,2


'exec(@sql)



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tbqsrq}'),112)
set @qsny=@qsrq

SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=1' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between @qsny  and  @jsny

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
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  BuildDate = '+@dqrq+' ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_租赁商品销售明细' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select ROW_NUMBER() OVER ( partition by  DeptCode ORDER BY BuildDate ASC) AS XUHAO,BuildDate,DeptCode ,WhetherNew,left(goodscode,2) GoodsCatCode
,sum(SaleIncome+SaleTax)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
TB部门信息表 A,
 ('+@SQL+')  B
WHERE A.NodeCode=b.DeptCode  and  (nodecode LIKE ''1%'' or nodecode LIKE ''2%'') 
GROUP BY BuildDate,DeptCode ,WhetherNew,left(goodscode,2)
ORDER BY 1,2,3,4

'exec(@sql1)



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=0' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between @qsny  and  @jsny

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
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  EnterAccountDate between  '+@qsrq+' and '+@dqrq+' and GoodsPropertyCode=''2005'' and CategoryLevel=2 ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_特殊分类销售' and SUBSTRING(name,3,6) between @qsny  and  @jsny
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
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  EnterAccountDate between  '+@qsrq+' and '+@dqrq+' and GoodsPropertyCode=''2005'' and CategoryLevel=1 ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_特殊分类销售' and SUBSTRING(name,3,6) between @qsny  and  @jsny
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
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=2

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,b.CategoryCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and OpenDate<=''${dqrq}''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
)a


left join 
(select nodecode ,left(CategoryCode,2) CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and CategoryCode like ''1%''

GROUP BY nodecode,left(CategoryCode,2))b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,GoodsCatCode CategoryCode,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsCatCode like ''1%''
GROUP BY DeptCode,GoodsCatCode)c on a.nodecode= c.nodecode and b.CategoryCode=c.CategoryCode 


ORDER BY 1,2


'exec(@sql)




select AreaCode,NodeCode DeptCode,WhetherNew ,case when WhetherNew='1'  then '新店' when year='1'  then '开业1年以上' when year>'1'  then '开业2年以上' else '0' end year    ,
isnull(b.Salesindex,0) Salesindex,
isnull(b.Grossprofitindex,0) Grossprofitindex
 from 
(select AreaCode,NodeCode,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112))>=20  then 0 else 1 end  WhetherNew,
case when  datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') between 12 and 23 then 1 when datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') >=24 then 2 else 0 end  year
 from 
TB部门信息表
where State!=2  and (nodecode like '1%' or NodeCode like '2%') and OpenDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
 )a
left join 
(select DeptCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%')  and CategoryItemCode='0000' and CategoryCode like '1%'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)


group by DeptCode)b on a.NodeCode=b.DeptCode
order by 1,4,3,2


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')



SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and (b.CategoryCode  like ''1%'' or b.CategoryCode  like ''2%'' or b.CategoryCode  like ''3%'' or b.CategoryCode  like ''4%'' or b.CategoryCode  like ''5%'')
GROUP BY nodecode)b on a.nodecode= b.nodecode




ORDER BY 1


'exec(@sql)

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')



SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and (b.CategoryCode like ''1%'' or b.CategoryCode like ''2%'' or b.CategoryCode like ''3%'' or b.CategoryCode like ''4%''or b.CategoryCode like ''5%'' )
GROUP BY nodecode)b on a.nodecode= b.nodecode


ORDER BY 1


'exec(@sql)





select 
a.CategoryCode,
isnull(b.StartCost,0)+ISNULL(c.StockCost,0)TaxCost
 from 
(select distinct left(CategoryCode,2) CategoryCode  from 
TB商品分类表 b 
where	 b.CategoryItemCode='0000' and b.CategoryLevel='2' and b.ParentCategoryCode between 1 and 5 and ParentCategoryCode like '1%' and CategoryCode not in (19))a
left join 
(select 
left(CategoryCode,2)CategoryCode,sum(StartCost+StartTax)StartCost  from 
tb${YM}_GoodsMONpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and CategoryCode like '1%'
GROUP BY left(CategoryCode,2)) b on a.CategoryCode=b.CategoryCode
left join 
(select left(CategoryCode,2) CategoryCode,
sum(PURCHCOST+PurchTax --进货
+ REDEPLOYINCOST+RedeployinTax --拨入
+ PROFITCOST+ProfitTax --升溢
+ COUNTPROFITCOST+CountProfitTax --盘升
- TaxSaleCost  --销售
- REDEPLOYOUTCOST-RedeployoutTax --拨出
- LOSSCOST-LossTax --损耗
- COUNTLOSSCOST-CountLossTax --盘耗
-ToGiftCost-ToGiftTax --转赠品
)StockCost  from 
tb${YM}_Goodsdaypssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and CategoryCode like '1%'
and occurdate <= convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) 
GROUP BY left(CategoryCode,2)) c on   a.CategoryCode=c.CategoryCode




order by 1

