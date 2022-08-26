select AreaCode,NodeCode DeptCode,WhetherNew,LEFT(CategoryCode,1)商品一级编码,CategoryCode 商品分类编码,defday,Y_OccurDate ,SUM(Salesindex)Salesindex,SUM(a.Grossprofitindex)Grossprofitindex from 
(select AreaCode,NodeCode ,WhetherNew ,a.ParentCategoryCode,a.CategoryCode,a.defday,
round(case when isnull(b.Salesindex,0)*isnull(d.xszb,0)<>0 then isnull(b.Salesindex,0)*isnull(d.xszb,0) else isnull(c.Salesindex,0)*isnull(d.xszb,0) end ,2) Salesindex,
round(case when isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0)<>0 then  isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0) else isnull(c.Grossprofitindex,0)*isnull(d.mlzb,0) end,2) Grossprofitindex
 from 
(select  AreaCode,NodeCode,case when OpenDate>convert(varchar(8),dateadd(yy,-1,'${dqrq}'),112) then 1 else 0 end  WhetherNew ,c.ParentCategoryCode,c.CategoryCode,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b,TB商品分类表  c
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and c.CategoryItemCode='0000' and c.CategoryLevel=2 
and left(c.CategoryCode,1) between 1 and 5 and OpenDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
and c.CategoryCode<>29   and c.CategoryCode<>19 and c.CategoryCode<>28 and c.CategoryCode<>23  )a
left join 
每日预算表 b on a.defday=b.defday and a.NodeCode=b.DeptCode
left join 
(select DeptCode,sum(Salesindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Salesindex,sum(Grossprofitindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)c on a.NodeCode=c.DeptCode 
left join 
(select a.DeptCode,a.CategoryCode,case when a.Salesindex=0 then 0 else a.Salesindex/b.Salesindex end xszb,
case when a.Grossprofitindex=0 then 0 else  a.Grossprofitindex/b.Grossprofitindex end mlzb  from 
(select DeptCode,CategoryCode,Salesindex,Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112))a,
(select DeptCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)b
where a.DeptCode=b.DeptCode)d on a.NodeCode=d.DeptCode and a.CategoryCode=d.CategoryCode )a
left join 
日期对照表 b on a.defday=b.OccurDate
where 1=1 ${if(len(bm) == 0,   "",   "and a.NodeCode in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") } 
group by AreaCode,NodeCode ,WhetherNew,LEFT(CategoryCode,1),CategoryCode,defday,Y_OccurDate 
order by 1,2,5,3,6

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=0 
and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in (''" + replace(bm,",","'',''")+"'')") }
 ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select * from (
select ROW_NUMBER() OVER(order by sum(销售金额) desc) as 全公司排名,ROW_NUMBER() OVER(partition by FormatCode order by sum(销售金额) desc) as 大区排名,
FormatCode,A.AreaCode,A.AreaName,部门编码 DeptCode ,case when OpenDate>convert(varchar(8),dateadd(yy,-1,''${dqrq}'' ),112) then 1 else 0 end WhetherNew,0 GoodsCatCode
,报表日期,sum(来客数)SaleCount,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
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
and OpenDate<='+@dqrq+'
GROUP BY FormatCode,A.AreaCode,A.AreaName,部门编码,case when OpenDate>convert(varchar(8),dateadd(yy,-1,''${dqrq}'' ),112) then 1 else 0 end,报表日期)a

ORDER BY 3,4


'exec(@sql1)

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tbqsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=0
and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in (''" + replace(bm,",","'',''")+"'')") } ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select * from (
select ROW_NUMBER() OVER(order by sum(销售金额) desc) as 全公司排名,ROW_NUMBER() OVER(partition by FormatCode order by sum(销售金额) desc) as 大区排名,
FormatCode,A.AreaCode,A.AreaName,部门编码 DeptCode ,case when OpenDate>convert(varchar(8),dateadd(yy,-1,''${dqrq}'' ),112) then 1 else 0 end WhetherNew,0 GoodsCatCode
,报表日期,sum(来客数)SaleCount,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
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
and OpenDate<='+@dqrq+'
GROUP BY FormatCode,A.AreaCode,A.AreaName,部门编码,case when OpenDate>convert(varchar(8),dateadd(yy,-1,''${dqrq}'' ),112) then 1 else 0 end,报表日期)a

ORDER BY 3,4


'exec(@sql1)

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=5
and  1=1 ${if(len(fl) == 0,   "",   "and left(商品分类编码,2) in (''" + replace(fl,",","'',''")+"'')") } 
and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in (''" + replace(bm,",","'',''")+"'')") }
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='


select FormatCode,A.AreaCode,A.AreaName,部门编码 DeptCode ,
case when OpenDate>convert(varchar(8),dateadd(yy,-1,''20180917'' ),112) then 1 else 0 end WhetherNew,
case when 
 ( 商品分类编码 like ''281%'' or  商品分类编码 like ''21%'' or  商品分类编码 like ''288%'')  then ''21'' 
 when  
 (商品分类编码 in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 商品分类编码 like ''280%'' or  商品分类编码 like ''20%'' or  商品分类编码 like ''287%'')  then ''20'' 
  when  
 (商品分类编码 in (29003,29006) or 
 商品分类编码 like ''282%'' or  商品分类编码 like ''22%'' or  商品分类编码 like ''289%'')  then ''22'' 
  else LEFT(商品分类编码,2) end GoodsCatCode,
sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
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

and OpenDate<='+@dqrq+' and 商品分类编码  not like ''6%''
GROUP BY FormatCode,A.AreaCode,A.AreaName,部门编码,case when 
 ( 商品分类编码 like ''281%'' or  商品分类编码 like ''21%'' or  商品分类编码 like ''288%'')  then ''21'' 
 when  
 (商品分类编码 in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 商品分类编码 like ''280%'' or  商品分类编码 like ''20%'' or  商品分类编码 like ''287%'')  then ''20'' 
  when  
 (商品分类编码 in (29003,29006) or 
 商品分类编码 like ''282%'' or  商品分类编码 like ''22%'' or  商品分类编码 like ''289%'')  then ''22'' 
  else LEFT(商品分类编码,2) end,case when OpenDate>convert(varchar(8),dateadd(yy,-1,''20180917'' ),112) then 1 else 0 end




ORDER BY 7,1,2,4,6,5


'exec(@sql1)

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tbqsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=5
and  1=1 ${if(len(fl) == 0,   "",   "and left(商品分类编码,2) in (''" + replace(fl,",","'',''")+"'')") } 
and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in (''" + replace(bm,",","'',''")+"'')") }
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='


select FormatCode,A.AreaCode,A.AreaName,部门编码 DeptCode ,
case when OpenDate>convert(varchar(8),dateadd(yy,-1,''20180917'' ),112) then 1 else 0 end WhetherNew,
case when 
 ( 商品分类编码 like ''281%'' or  商品分类编码 like ''21%'' or  商品分类编码 like ''288%'')  then ''21'' 
 when  
 (商品分类编码 in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 商品分类编码 like ''280%'' or  商品分类编码 like ''20%'' or  商品分类编码 like ''287%'')  then ''20'' 
  when  
 (商品分类编码 in (29003,29006) or 
 商品分类编码 like ''282%'' or  商品分类编码 like ''22%'' or  商品分类编码 like ''289%'')  then ''22'' 
  else LEFT(商品分类编码,2) end GoodsCatCode,
sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit,
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

and OpenDate<='+@dqrq+' and 商品分类编码  not like ''6%''
GROUP BY FormatCode,A.AreaCode,A.AreaName,部门编码,case when 
 ( 商品分类编码 like ''281%'' or  商品分类编码 like ''21%'' or  商品分类编码 like ''288%'')  then ''21'' 
 when  
 (商品分类编码 in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 商品分类编码 like ''280%'' or  商品分类编码 like ''20%'' or  商品分类编码 like ''287%'')  then ''20'' 
  when  
 (商品分类编码 in (29003,29006) or 
 商品分类编码 like ''282%'' or  商品分类编码 like ''22%'' or  商品分类编码 like ''289%'')  then ''22'' 
  else LEFT(商品分类编码,2) end,case when OpenDate>convert(varchar(8),dateadd(yy,-1,''20180917'' ),112) then 1 else 0 end




ORDER BY 7,1,2,4,6,5


'exec(@sql1)

