    select 
a.CategoryCode2,a.CategoryName2,
a.CategoryCode3,a.CategoryName3  ,
isnull(SUM(Salesindex),0)Salesindex,isnull(SUM(Grossprofitindex),0)Grossprofitindex 
from 
(select a.CategoryItemCode,a.CategoryCode CategoryCode1,a.CategoryName CategoryName1,
b.CategoryCode  CategoryCode2,b.CategoryName CategoryName2,
c.CategoryCode  CategoryCode3,c.CategoryName CategoryName3 from 
TB分类对照表 a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.ParentCategoryCode and b.CategoryLevel=1
left join 
TB分类对照表 c on b.CategoryItemCode=c.CategoryItemCode and b.CategoryCode=c.ParentCategoryCode and c.CategoryLevel=2
where a.CategoryLevel=0 and a.CategoryItemCode ='0002'
)a
LEFT JOIN 
含税分课预算表 B ON b.DeptCode ='0002' and b.CategoryItemCode='0002' and BudgetYM between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
and a.CategoryCode3=B.CategoryCode

group by a.CategoryCode2,a.CategoryName2,a.CategoryCode3,a.CategoryName3

order by a.CategoryCode2,a.CategoryCode3

	  
	  DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
	SET @SQL=''
	SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期   between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' AND 商品分类编码 not LIKE ''1%'' AND 商品分类编码 not LIKE ''2%'' AND 商品分类编码 not LIKE ''6%'' AND 商品分类编码 not LIKE ''35000'' ' 
	 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6)between @qsny  and  @jsny

	
	SET @SQL=STUFF(@SQL,1,11,'')
	
	
	SET @SQL1='
	
select 部门编码,商品分类编码,sum(来客数)SaleCount,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
	sum(促销销售收入)+sum(促销销项税金)CXSaleMoney,sum(促销销售收入)+sum(促销销项税金)-sum(含税促销销售成本)CXSaleGrossProfit into #sj from 
	('+@SQL+') a
	group by 部门编码,商品分类编码
	
	select a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(CXSaleGrossProfit)CXSaleGrossProfit  from 
	(select a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(CXSaleGrossProfit)CXSaleGrossProfit
  from 
	(select  b.AreaCode,b.AreaName,b.NodeCode  ,b.WhetherNew,a.CategoryCode2,a.CategoryCode3,a.CategoryCode from 
(select a.CategoryItemCode,a.CategoryCode CategoryCode1,a.CategoryName CategoryName1,
b.CategoryCode  CategoryCode2,b.CategoryName CategoryName2,
c.CategoryCode  CategoryCode3,c.CategoryName CategoryName3,
d.CategoryCode from 
TB分类对照表 a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.ParentCategoryCode and b.CategoryLevel=1
left join 
TB分类对照表 c on b.CategoryItemCode=c.CategoryItemCode and b.CategoryCode=c.ParentCategoryCode and c.CategoryLevel=2
left join 
TB分类对照表 d on c.CategoryItemCode=d.CategoryItemCode and c.CategoryCode=d.ParentCategoryCode and d.CategoryLevel=3
where a.CategoryLevel=0 and a.CategoryItemCode =0002 
)a,TB部门信息表 b
where (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'') and a.CategoryCode2 not like ''33%'') A,
	 #sj  B
	WHERE A.NodeCode=b.部门编码 and  a.CategoryCode=b.商品分类编码   
	GROUP BY a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
	
	union all 
	
	select a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
	,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(CXSaleGrossProfit)CXSaleGrossProfit
  from 
	(select  b.AreaCode,b.AreaName,b.NodeCode  ,b.WhetherNew,a.CategoryCode2,a.CategoryCode3,a.CategoryCode from 
(select a.CategoryItemCode,a.CategoryCode CategoryCode1,a.CategoryName CategoryName1,
b.CategoryCode  CategoryCode2,b.CategoryName CategoryName2,
c.CategoryCode  CategoryCode3,c.CategoryName CategoryName3,
d.CategoryCode from 
TB分类对照表 a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.ParentCategoryCode and b.CategoryLevel=1
left join 
TB分类对照表 c on b.CategoryItemCode=c.CategoryItemCode and b.CategoryCode=c.ParentCategoryCode and c.CategoryLevel=2
left join 
TB分类对照表 d on c.CategoryItemCode=d.CategoryItemCode and c.CategoryCode=d.ParentCategoryCode and d.CategoryLevel=3
where a.CategoryLevel=0 and a.CategoryItemCode =0002 
)a,TB部门信息表 b
where (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  and nodecode not in (1003,1004,1011,1012,1013,1017,1018,1019,1023,1024,1032,1034,1035,2001,2002,2004,2005,2006,2007,2008,2009)
and (a.CategoryCode3  like ''331%'' or a.CategoryCode3  like ''332%'')) A,
	 #sj  B
	WHERE A.NodeCode=b.部门编码 and  a.CategoryCode=b.商品分类编码   
	GROUP BY a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3

	union all 
	
	select a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(CXSaleGrossProfit)CXSaleGrossProfit
  from 
	(select  b.AreaCode,b.AreaName,b.NodeCode  ,b.WhetherNew,a.CategoryCode2,a.CategoryCode3,a.CategoryCode from 
(select a.CategoryItemCode,a.CategoryCode CategoryCode1,a.CategoryName CategoryName1,
b.CategoryCode  CategoryCode2,b.CategoryName CategoryName2,
c.CategoryCode  CategoryCode3,c.CategoryName CategoryName3,
d.CategoryCode from 
TB分类对照表 a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.ParentCategoryCode and b.CategoryLevel=1
left join 
TB分类对照表 c on b.CategoryItemCode=c.CategoryItemCode and b.CategoryCode=c.ParentCategoryCode and c.CategoryLevel=2
left join 
TB分类对照表 d on c.CategoryItemCode=d.CategoryItemCode and c.CategoryCode=d.ParentCategoryCode and d.CategoryLevel=3
where a.CategoryLevel=0 and a.CategoryItemCode =0002 
)a,TB部门信息表 b
where (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  and nodecode in (1003,1004,1011,1012,1013,1017,1018,1019,1023,1024,1032,1034,1035,2001,2002,2004,2005,2006,2007,2008,2009)
and (a.CategoryCode3  like ''333%'' )) A,
	#sj  B
	WHERE A.NodeCode=b.部门编码 and  a.CategoryCode=b.商品分类编码   
	GROUP BY a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3



	
	)a
	
	group by  a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
	ORDER BY 1,3,5,6
	
	
	
	'exec(@sql1)
	
    
    


	  
	  DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tbqsrq}'),112)
set @qsny=@qsrq
	SET @SQL=''
	SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期   between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' AND 商品分类编码 not LIKE ''1%'' AND 商品分类编码 not LIKE ''2%'' AND 商品分类编码 not LIKE ''6%'' AND 商品分类编码 not LIKE ''35000''' 
	 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6)between @qsny  and  @jsny

	
	SET @SQL=STUFF(@SQL,1,11,'')
	
	
	SET @SQL1='
select 部门编码,商品分类编码,sum(来客数)SaleCount,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
	sum(促销销售收入)+sum(促销销项税金)CXSaleMoney,sum(促销销售收入)+sum(促销销项税金)-sum(含税促销销售成本)CXSaleGrossProfit into #sj from 
	('+@SQL+') a
	group by 部门编码,商品分类编码
	
	select a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(CXSaleGrossProfit)CXSaleGrossProfit  from 
	(select a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(CXSaleGrossProfit)CXSaleGrossProfit
  from 
	(select  b.AreaCode,b.AreaName,b.NodeCode  ,b.WhetherNew,a.CategoryCode2,a.CategoryCode3,a.CategoryCode from 
(select a.CategoryItemCode,a.CategoryCode CategoryCode1,a.CategoryName CategoryName1,
b.CategoryCode  CategoryCode2,b.CategoryName CategoryName2,
c.CategoryCode  CategoryCode3,c.CategoryName CategoryName3,
d.CategoryCode from 
TB分类对照表 a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.ParentCategoryCode and b.CategoryLevel=1
left join 
TB分类对照表 c on b.CategoryItemCode=c.CategoryItemCode and b.CategoryCode=c.ParentCategoryCode and c.CategoryLevel=2
left join 
TB分类对照表 d on c.CategoryItemCode=d.CategoryItemCode and c.CategoryCode=d.ParentCategoryCode and d.CategoryLevel=3
where a.CategoryLevel=0 and a.CategoryItemCode =0002 
)a,TB部门信息表 b
where (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'') and a.CategoryCode2 not like ''33%'') A,
	 #sj  B
	WHERE A.NodeCode=b.部门编码 and  a.CategoryCode=b.商品分类编码   
	GROUP BY a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
	
	union all 
	
	select a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
	,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(CXSaleGrossProfit)CXSaleGrossProfit
  from 
	(select  b.AreaCode,b.AreaName,b.NodeCode  ,b.WhetherNew,a.CategoryCode2,a.CategoryCode3,a.CategoryCode from 
(select a.CategoryItemCode,a.CategoryCode CategoryCode1,a.CategoryName CategoryName1,
b.CategoryCode  CategoryCode2,b.CategoryName CategoryName2,
c.CategoryCode  CategoryCode3,c.CategoryName CategoryName3,
d.CategoryCode from 
TB分类对照表 a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.ParentCategoryCode and b.CategoryLevel=1
left join 
TB分类对照表 c on b.CategoryItemCode=c.CategoryItemCode and b.CategoryCode=c.ParentCategoryCode and c.CategoryLevel=2
left join 
TB分类对照表 d on c.CategoryItemCode=d.CategoryItemCode and c.CategoryCode=d.ParentCategoryCode and d.CategoryLevel=3
where a.CategoryLevel=0 and a.CategoryItemCode =0002 
)a,TB部门信息表 b
where (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  and nodecode not in (1003,1004,1011,1012,1013,1017,1018,1019,1023,1024,1032,1034,1035,2001,2002,2004,2005,2006,2007,2008,2009)
and (a.CategoryCode3  like ''331%'' or a.CategoryCode3  like ''332%'')) A,
	 #sj  B
	WHERE A.NodeCode=b.部门编码 and  a.CategoryCode=b.商品分类编码   
	GROUP BY a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3

	union all 
	
	select a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(CXSaleGrossProfit)CXSaleGrossProfit
  from 
	(select  b.AreaCode,b.AreaName,b.NodeCode  ,b.WhetherNew,a.CategoryCode2,a.CategoryCode3,a.CategoryCode from 
(select a.CategoryItemCode,a.CategoryCode CategoryCode1,a.CategoryName CategoryName1,
b.CategoryCode  CategoryCode2,b.CategoryName CategoryName2,
c.CategoryCode  CategoryCode3,c.CategoryName CategoryName3,
d.CategoryCode from 
TB分类对照表 a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.ParentCategoryCode and b.CategoryLevel=1
left join 
TB分类对照表 c on b.CategoryItemCode=c.CategoryItemCode and b.CategoryCode=c.ParentCategoryCode and c.CategoryLevel=2
left join 
TB分类对照表 d on c.CategoryItemCode=d.CategoryItemCode and c.CategoryCode=d.ParentCategoryCode and d.CategoryLevel=3
where a.CategoryLevel=0 and a.CategoryItemCode =0002 
)a,TB部门信息表 b
where (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  and nodecode in (1003,1004,1011,1012,1013,1017,1018,1019,1023,1024,1032,1034,1035,2001,2002,2004,2005,2006,2007,2008,2009)
and (a.CategoryCode3  like ''333%'' )) A,
	#sj  B
	WHERE A.NodeCode=b.部门编码 and  a.CategoryCode=b.商品分类编码   
	GROUP BY a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3



	
	)a
	
	group by  a.AreaCode,a.AreaName,a.NodeCode  ,a.WhetherNew,a.CategoryCode2,a.CategoryCode3
	ORDER BY 1,3,5,6
	
	
	
	'exec(@sql1)
	
    
    



 
	  DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=1' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6)  between @qsny  and  @jsny


SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select 报表日期,A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,0 GoodsCatCode
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
 AND (商品分类编码 LIKE ''3%'' or 商品分类编码 LIKE ''4%'' or 商品分类编码 LIKE ''5%'')
 AND 商品分类编码 not LIKE ''35000''
GROUP BY 报表日期,A.AreaCode,A.AreaName,部门编码,WhetherNew
ORDER BY 1,4,5


'exec(@sql1)


 
 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tbqsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=1' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6)  between @qsny  and  @jsny

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
 AND (商品分类编码 LIKE ''3%'' or 商品分类编码 LIKE ''4%'' or 商品分类编码 LIKE ''5%'')
 AND 商品分类编码 not LIKE ''35000''
GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew
ORDER BY 1,3,4


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
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期  between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=0' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between @qsny  and  @jsny

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

