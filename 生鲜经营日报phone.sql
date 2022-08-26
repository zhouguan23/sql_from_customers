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
(select nodecode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
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
ORDER BY 5,3


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

GROUP BY nodecode,left(CategoryCode,2))b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,GoodsCatCode,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsCatCode like ''1%''
GROUP BY DeptCode,GoodsCatCode)c on a.nodecode= c.nodecode 


ORDER BY 1,2


'exec(@sql)



