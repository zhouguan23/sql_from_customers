select AreaCode,NodeCode DeptCode,LEFT(CategoryCode,1)商品分类编码,case when LEFT(CategoryCode,2)in(10,11) then '10'  
     when LEFT(CategoryCode,2)in(12,13) then '12'
     when LEFT(CategoryCode,2)in(14) then '14'
     when LEFT(CategoryCode,1)in(2) then '20'
     when LEFT(CategoryCode,2)in(30,31,32) then '30'
     when LEFT(CategoryCode,2)in(33,34) then '33'
     when LEFT(CategoryCode,2)in(40,41,42,43,44,45,48,49) then '40'
     when LEFT(CategoryCode,2)in(46,47) then '46'
     when LEFT(CategoryCode,1)in(5) then '50'
     end CategoryCode,a.defday,SUM(Salesindex)Salesindex,SUM(a.Grossprofitindex)Grossprofitindex from 
(select AreaCode,NodeCode ,a.CategoryCode,a.defday,
round(case when isnull(b.Salesindex,0)*isnull(d.xszb,0)<>0 then isnull(b.Salesindex,0)*isnull(d.xszb,0) else isnull(c.Salesindex,0)*isnull(d.xszb,0) end ,2) Salesindex,
round(case when isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0)<>0 then  isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0) else isnull(c.Grossprofitindex,0)*isnull(d.mlzb,0) end,2) Grossprofitindex
 from 
(select  AreaCode,NodeCode ,c.CategoryCode,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b,TB商品分类表  c
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and c.CategoryItemCode='0000' and c.CategoryLevel=2 
and left(c.CategoryCode,1) between 1 and 5
and c.CategoryCode<>29   and c.CategoryCode<>19 and c.CategoryCode<>28 and c.CategoryCode<>23
and 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and b.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")})a
left join 
每日预算表 b on a.defday=b.defday and a.NodeCode=b.DeptCode
left join 
(select DeptCode,sum(Salesindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Salesindex,sum(Grossprofitindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)c on a.NodeCode=c.DeptCode 
left join 
(select a.DeptCode,a.CategoryCode,case when a.Salesindex=0 then 0 else a.Salesindex/b.Salesindex end xszb,
case when a.Grossprofitindex=0 then 0 else  a.Grossprofitindex/b.Grossprofitindex end mlzb  from 
(select DeptCode,CategoryCode,Salesindex,Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112))a,
(select DeptCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)b
where a.DeptCode=b.DeptCode)d on a.NodeCode=d.DeptCode and a.CategoryCode=d.CategoryCode )a
where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } and a.defday=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
group by AreaCode,NodeCode ,LEFT(CategoryCode,1),case when LEFT(CategoryCode,2)in(10,11) then '10'  
     when LEFT(CategoryCode,2)in(12,13) then '12'
     when LEFT(CategoryCode,2)in(14) then '14'
     when LEFT(CategoryCode,1)in(2) then '20'
     when LEFT(CategoryCode,2)in(30,31,32) then '30'
     when LEFT(CategoryCode,2)in(33,34) then '33'
     when LEFT(CategoryCode,2)in(40,41,42,43,44,45,48,49) then '40'
     when LEFT(CategoryCode,2)in(46,47) then '46'
     when LEFT(CategoryCode,1)in(5) then '50'
     end ,a.defday
order by 2,4,3

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 = '+@dqrq+' and 商品分类项编码=''0000'' 
and 商品分类等级=2 and left(商品分类编码,1) between 1 and 5 and left(商品分类编码,2)<>23' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) = @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select ROW_NUMBER() OVER ( partition by  部门编码 ORDER BY 报表日期 ASC) AS XUHAO,A.AreaCode,A.AreaName,报表日期,部门编码 DeptCode ,WhetherNew,
left(商品分类编码,1)商品分类编码,
case when LEFT(商品分类编码,2)in(10,11) then ''10''  
     when LEFT(商品分类编码,2)in(12,13) then ''12''
     when LEFT(商品分类编码,2)in(14) then ''14''
     when LEFT(商品分类编码,1)in(2) then ''20''
     when LEFT(商品分类编码,2)in(30,31,32) then ''30''
     when LEFT(商品分类编码,2)in(33,34) then ''33''
     when LEFT(商品分类编码,2)in(40,41,42,43,44,45,48,49) then ''40''
     when LEFT(商品分类编码,2)in(46,47) then ''46''
     when LEFT(商品分类编码,1)in(5) then ''50''
     else ''10''     end GoodsCatCode
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
WHERE A.NodeCode=b.部门编码 and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }

GROUP BY A.AreaCode,A.AreaName,报表日期,部门编码,WhetherNew,left(商品分类编码,1),
case when LEFT(商品分类编码,2)in(10,11) then ''10''  
     when LEFT(商品分类编码,2)in(12,13) then ''12''
     when LEFT(商品分类编码,2)in(14) then ''14''
     when LEFT(商品分类编码,1)in(2) then ''20''
     when LEFT(商品分类编码,2)in(30,31,32) then ''30''
     when LEFT(商品分类编码,2)in(33,34) then ''33''
     when LEFT(商品分类编码,2)in(40,41,42,43,44,45,48,49) then ''40''
     when LEFT(商品分类编码,2)in(46,47) then ''46''
     when LEFT(商品分类编码,1)in(5) then ''50''
     else ''10'' end
ORDER BY 1,3,4,6

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

select c.DeptCategoryCode  AreaCode,a.DeptCode,case when b.DeptCategoryCode in (02,06) then ''1'' else ''0'' END WhetherNew 
,商品分类编码,GoodsCatCode
,a.SaleMoney,a.SaleGrossProfit
from 
(select nodecode DeptCode ,left(CategoryCode,1)商品分类编码,
case when left(CategoryCode,2) in(10,11) then ''10''  
     when left(CategoryCode,2) in(12,13) then ''12''
     when left(CategoryCode,2) in(14) then ''14''
     when left(CategoryCode,2) in(2) then ''20''
     when left(CategoryCode,2) in(30,31,32) then ''30''
     when left(CategoryCode,2) in(33,34) then ''33''
     when left(CategoryCode,2) in(40,41,42,43,44,45,48,49) then ''40''
     when left(CategoryCode,2) in(46,47) then ''46''
     when left(CategoryCode,2) in(5) then ''50''
     else ''10'' end GoodsCatCode,
sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
[000]A.TBGOODS A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  
AND CategoryCode not like ''23%''
GROUP BY nodecode,left(CategoryCode,1),
case when left(CategoryCode,2) in(10,11) then ''10''  
     when left(CategoryCode,2) in(12,13) then ''12''
     when left(CategoryCode,2) in(14) then ''14''
     when left(CategoryCode,2) in(2) then ''20''
     when left(CategoryCode,2) in(30,31,32) then ''30''
     when left(CategoryCode,2) in(33,34) then ''33''
     when left(CategoryCode,2) in(40,41,42,43,44,45,48,49) then ''40''
     when left(CategoryCode,2) in(46,47) then ''46''
     when left(CategoryCode,2) in(5) then ''50''
     else ''10'' end)a
left join 
[000]A.TBCATTODEPARTMENT b on a.deptcode =b.nodecode  and b.DeptCatItemCode =''0000''
left join 
[000]A.TBCATTODEPARTMENT c on a.deptcode =c.nodecode  and c.DeptCatItemCode =''0013''
where 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in (''" + replace(bm,",","'',''")+"'')") } 
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

select ROW_NUMBER() OVER(order by sum(销售金额) desc) as 全公司排名,ROW_NUMBER() OVER(partition by FormatCode order by sum(销售金额) desc) as 业态排名,
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

GROUP BY FormatCode,A.AreaCode,A.AreaName,部门编码,WhetherNew
ORDER BY 3,4


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

select ROW_NUMBER() OVER(order by a.SaleMoney desc) as 全公司排名,ROW_NUMBER() OVER(partition by c.DeptCategoryCode order by a.SaleMoney desc) as 大区排名,
c.DeptCategoryCode AreaCode,a.DeptCode,case when b.DeptCategoryCode in (02,06) then ''1'' else ''0'' END WhetherNew ,0 商品分类编码,a.SaleMoney,a.SaleGrossProfit
from 
(select nodecode DeptCode ,
sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
[000]A.TBGOODS A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'') 
and CategoryCode not like ''23%'' 
GROUP BY nodecode)a
left join 
[000]A.TBCATTODEPARTMENT b on a.deptcode =b.nodecode  and b.DeptCatItemCode =''0000''
left join 
[000]A.TBCATTODEPARTMENT c on a.deptcode =c.nodecode  and c.DeptCatItemCode =''0013''
where 1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode in (''" + replace(bm,",","'',''")+"'')") } 
ORDER BY 3,4


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

select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,'店'),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'')  NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流') ,'阳关站' ,''),'中央大街' ,'')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表 a

where  1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") }


and  left(a.nodecode,1) between 1 and 9 and a.nodecode  not like '6%' and a.nodecode  not like '7%' and a.nodecode  not like '8%'

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

select  DeptCode ,SUM(Salesindex)Salesindex,SUM(Grossprofitindex)Grossprofitindex
,sum(SaleMoney)SaleMoney,sum(SaleMoney)SaleGrossProfit
  from 
(select  DeptCode ,SUM(Salesindex)Salesindex,SUM(Grossprofitindex)Grossprofitindex 
from 含税分课预算表
where  BudgetYM between '+@qsny+' and '+@jsny+' and CategoryItemCode=''0000''
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in (''" + replace(bm,",","'',''")+"'')") }
and 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>1 , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>2) ,""," and deptcode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}
group by DeptCode) A,
 (
 select 部门编码,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit
  from ( '+@SQL+')a
  where 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in (''" + replace(bm,",","'',''")+"'')") } 
 group by  部门编码 ) B
WHERE  A.deptcode=b.部门编码 

GROUP BY DeptCode
ORDER BY 3,4


'exec(@sql1)

