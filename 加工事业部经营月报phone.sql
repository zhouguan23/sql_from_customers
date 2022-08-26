select A.AreaCode,A.AreaName,a.NodeCode DeptCode,A.WhetherNew,a.CategoryCode ,
isnull(SUM(Salesindex),0)Salesindex,isnull(SUM(Grossprofitindex),0)Grossprofitindex 
from 
(select A.AreaCode,A.AreaName,a.NodeCode,A.WhetherNew,CategoryCode,CategoryCode GoodsCatcode from 
TB部门信息表 a,TB商品分类表 b
where (a.NodeCode LIKE '1%' or a.NodeCode LIKE '2%' ) 
and b.CategoryLevel=2  and b.CategoryItemCode='0000' and CategoryCode  in (20,21,22)
)a
LEFT JOIN 
含税分课预算表 B ON A.NodeCode=b.DeptCode and a.GoodsCatcode=B.CategoryCode 
and BudgetYM between  convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and CategoryItemCode in ('0000') and DeptCode not in (0002)
group by A.AreaCode,A.AreaName,a.NodeCode,A.WhetherNew,a.CategoryCode



order by 3,4,5


	 
	  DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
	SET @SQL=''
	SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期  between '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' AND 商品分类编码 LIKE ''2%'' ' 
	 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6)between @qsny and  @jsny

	
	SET @SQL=STUFF(@SQL,1,11,'')
	
	
	SET @SQL1='
	select 部门编码,商品分类编码,商品分类等级,sum(来客数)SaleCount,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
	sum(促销销售收入)+sum(促销销项税金)CXSaleMoney,sum(促销销售收入)+sum(促销销项税金)-sum(含税促销销售成本)CXSaleGrossProfit ,
	sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
	sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
	sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
	sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
	sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
	sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本 into #sj from 
	('+@SQL+') a
	group by 部门编码,商品分类编码,商品分类等级
	
	select A.AreaCode,A.AreaName,DeptCode ,WhetherNew,GoodsCatCode
	,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,
	sum(CXSaleMoney)CXSaleMoney,sum(CXSaleGrossProfit)CXSaleGrossProfit,
	sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
	sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
	sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
	sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
	sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
	sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
	(select A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,商品分类编码 GoodsCatCode
	,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,
	sum(CXSaleMoney)CXSaleMoney,sum(CXSaleGrossProfit)CXSaleGrossProfit,
	sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
	sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
	sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
	sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
	sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
	sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
	TB部门信息表 A,
	 #sj  B
	WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')   and 商品分类等级=2 and 商品分类编码 not in( 28, 29,23)
	GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew,商品分类编码
	union all 
	select A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,case when 商品分类编码=280 then 20 when 商品分类编码 =281 then 21 else 22 end          GoodsCatCode
	,0SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,
	sum(CXSaleMoney)CXSaleMoney,sum(CXSaleGrossProfit)CXSaleGrossProfit,
	sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
	sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
	sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
	sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
	sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
	sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
	TB部门信息表 A,
	#sj  B
	WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' )   and 商品分类等级=3 and 商品分类编码 like ''28%''
	GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew,case when 商品分类编码=280 then 20 when 商品分类编码 =281 then 21 else 22 end 
		union all 
		select A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,case when 商品分类编码=29004 then 21 when 商品分类编码 in (29003,29006) then 22 else 20 end     GoodsCatCode
	,0 SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,
	sum(CXSaleMoney)CXSaleMoney,sum(CXSaleGrossProfit)CXSaleGrossProfit,
	sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
	sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
	sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
	sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
	sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
	sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
	TB部门信息表 A,
	 #sj  B
	WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')   and 商品分类等级=5 and 商品分类编码 like ''29%''
	GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew,case when 商品分类编码=29004 then 21 when 商品分类编码 in (29003,29006) then 22 else 20 end

	
	)a
	
	group by  A.AreaCode,A.AreaName,deptcode,WhetherNew,GoodsCatCode
	ORDER BY 1,3,5
	
	
	'exec(@sql1)
	


	 
	  DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tbqsrq}'),112)
set @qsny=@qsrq
	SET @SQL=''
	SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期  between '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' AND 商品分类编码 LIKE ''2%'' ' 
	 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6)between @qsny and  @jsny

	
	SET @SQL=STUFF(@SQL,1,11,'')
	
	
	SET @SQL1='
	select 部门编码,商品分类编码,商品分类等级,sum(来客数)SaleCount,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
	sum(促销销售收入)+sum(促销销项税金)CXSaleMoney,sum(促销销售收入)+sum(促销销项税金)-sum(含税促销销售成本)CXSaleGrossProfit ,
	sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
	sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
	sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
	sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
	sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
	sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本 into #sj from 
	('+@SQL+') a
	group by 部门编码,商品分类编码,商品分类等级
	
	select A.AreaCode,A.AreaName,DeptCode ,WhetherNew,GoodsCatCode
	,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,
	sum(CXSaleMoney)CXSaleMoney,sum(CXSaleGrossProfit)CXSaleGrossProfit,
	sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
	sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
	sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
	sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
	sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
	sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
	(select A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,商品分类编码 GoodsCatCode
	,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,
	sum(CXSaleMoney)CXSaleMoney,sum(CXSaleGrossProfit)CXSaleGrossProfit,
	sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
	sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
	sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
	sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
	sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
	sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
	TB部门信息表 A,
	 #sj  B
	WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')   and 商品分类等级=2 and 商品分类编码 not in( 28, 29,23)
	GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew,商品分类编码
	union all 
	select A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,case when 商品分类编码=280 then 20 when 商品分类编码 =281 then 21 else 22 end          GoodsCatCode
	,0SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,
	sum(CXSaleMoney)CXSaleMoney,sum(CXSaleGrossProfit)CXSaleGrossProfit,
	sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
	sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
	sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
	sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
	sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
	sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
	TB部门信息表 A,
	#sj  B
	WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' )   and 商品分类等级=3 and 商品分类编码 like ''28%''
	GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew,case when 商品分类编码=280 then 20 when 商品分类编码 =281 then 21 else 22 end 
		union all 
		select A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,case when 商品分类编码=29004 then 21 when 商品分类编码 in (29003,29006) then 22 else 20 end     GoodsCatCode
	,0 SaleCount,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,
	sum(CXSaleMoney)CXSaleMoney,sum(CXSaleGrossProfit)CXSaleGrossProfit,
	sum(销售退货金额)销售退货金额,sum(进货金额)进货金额,sum(进货退货金额)进货退货金额,sum(损益金额)损益金额,
	sum(滞销_有库存金额)滞销_有库存金额,sum(滞销_滞销金额)滞销_滞销金额,
	sum(负毛利SKU)负毛利SKU,sum(负库存SKU)负库存SKU,sum(畅销缺货SKU)畅销缺货SKU,
	sum(缺货率_SKU)缺货率_SKU,sum(缺货率_缺货SKU)缺货率_缺货SKU,
	sum(锁档SKU)锁档SKU,sum(暂禁下单SKU)暂禁下单SKU,
	sum(库存成本)库存成本,sum(含税库存金额)含税库存金额,sum(前置一月销售成本)前置一月销售成本  from 
	TB部门信息表 A,
	 #sj  B
	WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')   and 商品分类等级=5 and 商品分类编码 like ''29%''
	GROUP BY A.AreaCode,A.AreaName,部门编码,WhetherNew,case when 商品分类编码=29004 then 21 when 商品分类编码 in (29003,29006) then 22 else 20 end

	
	)a
	
	group by  A.AreaCode,A.AreaName,deptcode,WhetherNew,GoodsCatCode
	ORDER BY 1,3,5
	
	
	'exec(@sql1)
	



	 
	  DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=1' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6)between @qsny and  @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select 报表日期,A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,商品分类编码 GoodsCatCode
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
WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' )  AND 商品分类编码 LIKE ''2%'' AND 商品分类编码 not LIKE ''23%''
GROUP BY 报表日期,A.AreaCode,A.AreaName,部门编码,WhetherNew,商品分类编码
ORDER BY 4,5,6


'exec(@sql1)
	



	 
	  DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tbqsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=1' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6)between @qsny and  @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select 报表日期,A.AreaCode,A.AreaName,部门编码 DeptCode ,WhetherNew,商品分类编码 GoodsCatCode
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
WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' )  AND 商品分类编码 LIKE ''2%'' AND 商品分类编码 not LIKE ''23%''
GROUP BY 报表日期,A.AreaCode,A.AreaName,部门编码,WhetherNew,商品分类编码
ORDER BY 4,5,6


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
WHERE A.NodeCode=b.部门编码 and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' OR nodecode LIKE ''7777%'')  



'exec(@sql1)

select * from 
	dbo.日期对照表
	where OccurDate =convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

