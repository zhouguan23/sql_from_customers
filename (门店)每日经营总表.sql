select AreaCode,DeptCode,WhetherNew,defday,Y_OccurDate ,SUM(Salesindex)Salesindex,SUM(a.Grossprofitindex)Grossprofitindex from 
(select AreaCode,NodeCode DeptCode,case when OpenDate>convert(varchar(8),dateadd(yy,-1,'${dqrq}'),112) then 1 else 0 end  WhetherNew
,LEFT(CategoryCode,1)商品分类编码,case when LEFT(CategoryCode,2)in(10,11) then '10'  
     when LEFT(CategoryCode,2)in(12,13) then '12'
     when LEFT(CategoryCode,2)in(14) then '14'
     when LEFT(CategoryCode,1)in(2) then '20'
     when LEFT(CategoryCode,2)in(30,31,32) then '30'
     when LEFT(CategoryCode,2)in(33,34) then '33'
     when LEFT(CategoryCode,2)in(40,41,42,43,44,45,48,49) then '40'
     when LEFT(CategoryCode,2)in(46,47) then '46'
     when LEFT(CategoryCode,1)in(5) then '50'
     end CategoryCode,a.defday,SUM(Salesindex)Salesindex,SUM(a.Grossprofitindex)Grossprofitindex from 
(select AreaCode,NodeCode ,a.CategoryCode,a.defday,OpenDate,
round(case when isnull(b.Salesindex,0)*isnull(d.xszb,0)<>0 then isnull(b.Salesindex,0)*isnull(d.xszb,0) else isnull(c.Salesindex,0)*isnull(d.xszb,0) end ,2) Salesindex,
round(case when isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0)<>0 then  isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0) else isnull(c.Grossprofitindex,0)*isnull(d.mlzb,0) end,2) Grossprofitindex
 from 
(select  AreaCode,NodeCode ,b.OpenDate,c.CategoryCode,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b,TB商品分类表  c
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and c.CategoryItemCode='0000' and c.CategoryLevel=2 
and left(c.CategoryCode,1) between 1 and 5
and c.CategoryCode<>29   and c.CategoryCode<>19 and c.CategoryCode<>28 and c.CategoryCode<>23
and convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)>=OpenDate
and 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and b.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")})a
left join 
每日预算表 b on a.defday=b.defday and a.NodeCode=b.DeptCode
left join 
(select DeptCode,sum(Salesindex)/(DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))-case when datediff(day,dateadd(ms,0,DATEADD(mm, DATEDIFF(m,0,'${dqrq}'), 0)),OpenDate )<=0 then 0 else datediff(day,dateadd(ms,0,DATEADD(mm, DATEDIFF(m,0,'${dqrq}'), 0)),a.OpenDate ) end) Salesindex,sum(Grossprofitindex)/(DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))-case when datediff(day,dateadd(ms,0,DATEADD(mm, DATEDIFF(m,0,'${dqrq}'), 0)),OpenDate )+1<=0 then 0 else datediff(day,dateadd(ms,0,DATEADD(mm, DATEDIFF(m,0,'${dqrq}'), 0)),A.OpenDate)+1 end) Grossprofitindex from 
含税分课预算表 b
left join 
TB部门信息表 A on b.DeptCode =A.NodeCode 
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode,a.OpenDate)c on a.NodeCode=c.DeptCode 
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
where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
group by AreaCode,NodeCode ,LEFT(CategoryCode,1),
case when OpenDate>convert(varchar(8),dateadd(yy,-1,'${dqrq}'),112) then 1 else 0 end,
case when LEFT(CategoryCode,2)in(10,11) then '10'  
     when LEFT(CategoryCode,2)in(12,13) then '12'
     when LEFT(CategoryCode,2)in(14) then '14'
     when LEFT(CategoryCode,1)in(2) then '20'
     when LEFT(CategoryCode,2)in(30,31,32) then '30'
     when LEFT(CategoryCode,2)in(33,34) then '33'
     when LEFT(CategoryCode,2)in(40,41,42,43,44,45,48,49) then '40'
     when LEFT(CategoryCode,2)in(46,47) then '46'
     when LEFT(CategoryCode,1)in(5) then '50'
     end ,a.defday)a
     left join 
日期对照表 b on a.defday=b.OccurDate
group by AreaCode,deptcode,WhetherNew,defday,Y_OccurDate
order by 2,4,3



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

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=2

and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in (''" + replace(bm,",","'',''")+"'')") }
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='

select FormatCode,A.AreaCode,A.AreaName,部门编码 DeptCode ,
case when OpenDate>convert(varchar(8),dateadd(yy,-1,''${dqrq}'' ),112) then 1 else 0 end WhetherNew,
case when 
 ( 商品分类编码 like ''10%'' or  商品分类编码 like ''11%'' )  then ''10'' 
 when  
 ( 商品分类编码 like ''12%'' or  商品分类编码 like ''13%'')  then ''12'' 
  when  
  商品分类编码 like ''2%''then ''20'' 
   when  
 ( 商品分类编码 like ''30%'' or  商品分类编码 like ''31%'' or  商品分类编码 like ''32%'')  then ''30'' 
    when  
 ( 商品分类编码 like ''33%'' or  商品分类编码 like ''34%'')  then ''33'' 
     when  
 ( 商品分类编码 like ''40%'' or  商品分类编码 like ''41%''  or  商品分类编码 like ''42%''  or  商品分类编码 like ''43%''  or  商品分类编码 like ''44%''
  or  商品分类编码 like ''45%''  or  商品分类编码 like ''48%''  or  商品分类编码 like ''49%'')  then ''40'' 
       when  
 ( 商品分类编码 like ''46%''  or  商品分类编码 like ''47%'' )  then ''46'' 
   when  
  商品分类编码 like ''5%''then ''50'' 
  else LEFT(商品分类编码,2) end  GoodsCatCode,报表日期,
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

and OpenDate<='+@dqrq+' and 商品分类编码  not like ''6%'' and 商品分类编码  not like ''19%''
GROUP BY FormatCode,A.AreaCode,A.AreaName,部门编码,case when 
 ( 商品分类编码 like ''10%'' or  商品分类编码 like ''11%'' )  then ''10'' 
 when  
 ( 商品分类编码 like ''12%'' or  商品分类编码 like ''13%'')  then ''12'' 
  when  
  商品分类编码 like ''2%''then ''20'' 
   when  
 ( 商品分类编码 like ''30%'' or  商品分类编码 like ''31%'' or  商品分类编码 like ''32%'')  then ''30'' 
    when  
 ( 商品分类编码 like ''33%'' or  商品分类编码 like ''34%'')  then ''33'' 
     when  
 ( 商品分类编码 like ''40%'' or  商品分类编码 like ''41%''  or  商品分类编码 like ''42%''  or  商品分类编码 like ''43%''  or  商品分类编码 like ''44%''
  or  商品分类编码 like ''45%''  or  商品分类编码 like ''48%''  or  商品分类编码 like ''49%'')  then ''40'' 
       when  
 ( 商品分类编码 like ''46%''  or  商品分类编码 like ''47%'' )  then ''46'' 
   when  
  商品分类编码 like ''5%''then ''50'' 
  else LEFT(商品分类编码,2) end,case when OpenDate>convert(varchar(8),dateadd(yy,-1,''${dqrq}'' ),112) then 1 else 0 end,报表日期




ORDER BY 2,4,6


'exec(@sql1)

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tbdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tbqsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=2

and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in (''" + replace(bm,",","'',''")+"'')") }
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='

select FormatCode,A.AreaCode,A.AreaName,部门编码 DeptCode ,
case when OpenDate>convert(varchar(8),dateadd(yy,-1,''${dqrq}'' ),112) then 1 else 0 end WhetherNew,
case when 
 ( 商品分类编码 like ''10%'' or  商品分类编码 like ''11%'' )  then ''10'' 
 when  
 ( 商品分类编码 like ''12%'' or  商品分类编码 like ''13%'')  then ''12'' 
  when  
  商品分类编码 like ''2%''then ''20'' 
   when  
 ( 商品分类编码 like ''30%'' or  商品分类编码 like ''31%'' or  商品分类编码 like ''32%'')  then ''30'' 
    when  
 ( 商品分类编码 like ''33%'' or  商品分类编码 like ''34%'')  then ''33'' 
     when  
 ( 商品分类编码 like ''40%'' or  商品分类编码 like ''41%''  or  商品分类编码 like ''42%''  or  商品分类编码 like ''43%''  or  商品分类编码 like ''44%''
  or  商品分类编码 like ''45%''  or  商品分类编码 like ''48%''  or  商品分类编码 like ''49%'')  then ''40'' 
       when  
 ( 商品分类编码 like ''46%''  or  商品分类编码 like ''47%'' )  then ''46'' 
   when  
  商品分类编码 like ''5%''then ''50'' 
  else LEFT(商品分类编码,2) end  GoodsCatCode,
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

and OpenDate<='+@dqrq+' and 商品分类编码  not like ''6%'' and 商品分类编码  not like ''19%''
GROUP BY FormatCode,A.AreaCode,A.AreaName,部门编码,case when 
 ( 商品分类编码 like ''10%'' or  商品分类编码 like ''11%'' )  then ''10'' 
 when  
 ( 商品分类编码 like ''12%'' or  商品分类编码 like ''13%'')  then ''12'' 
  when  
  商品分类编码 like ''2%''then ''20'' 
   when  
 ( 商品分类编码 like ''30%'' or  商品分类编码 like ''31%'' or  商品分类编码 like ''32%'')  then ''30'' 
    when  
 ( 商品分类编码 like ''33%'' or  商品分类编码 like ''34%'')  then ''33'' 
     when  
 ( 商品分类编码 like ''40%'' or  商品分类编码 like ''41%''  or  商品分类编码 like ''42%''  or  商品分类编码 like ''43%''  or  商品分类编码 like ''44%''
  or  商品分类编码 like ''45%''  or  商品分类编码 like ''48%''  or  商品分类编码 like ''49%'')  then ''40'' 
       when  
 ( 商品分类编码 like ''46%''  or  商品分类编码 like ''47%'' )  then ''46'' 
   when  
  商品分类编码 like ''5%''then ''50'' 
  else LEFT(商品分类编码,2) end,case when OpenDate>convert(varchar(8),dateadd(yy,-1,''${dqrq}'' ),112) then 1 else 0 end




ORDER BY 2,4,6


'exec(@sql1)

select AreaCode,NodeCode,case when OpenDate>convert(varchar(8),dateadd(yy,-1,'${dqrq}'),112) then 1 else 0 end  WhetherNew
,case when 
 ( CategoryCode like '10%' or  CategoryCode like '11%' )  then '10' 
 when  
 ( CategoryCode like '12%' or  CategoryCode like '13%')  then '12' 
  when  
  CategoryCode like '2%'then '20' 
   when  
 ( CategoryCode like '30%' or  CategoryCode like '31%' or  CategoryCode like '32%')  then '30' 
    when  
 ( CategoryCode like '33%' or  CategoryCode like '34%')  then '33' 
     when  
 ( CategoryCode like '40%' or  CategoryCode like '41%'  or  CategoryCode like '42%'  or  CategoryCode like '43%'  or  CategoryCode like '44%'
  or  CategoryCode like '45%'  or  CategoryCode like '48%'  or  CategoryCode like '49%')  then '40' 
       when  
 ( CategoryCode like '46%'  or  CategoryCode like '47%' )  then '46' 
   when  
  CategoryCode like '5%'then '50' 
  else LEFT(CategoryCode,2) end CategoryCode,SUM(Salesindex)Salesindex,SUM(a.Grossprofitindex)Grossprofitindex from 
(select AreaCode,NodeCode ,a.CategoryCode,a.defday,OpenDate,
round(case when isnull(b.Salesindex,0)*isnull(d.xszb,0)<>0 then isnull(b.Salesindex,0)*isnull(d.xszb,0) else isnull(c.Salesindex,0)*isnull(d.xszb,0) end ,2) Salesindex,
round(case when isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0)<>0 then  isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0) else isnull(c.Grossprofitindex,0)*isnull(d.mlzb,0) end,2) Grossprofitindex
 from 
(select  AreaCode,NodeCode ,b.OpenDate,c.CategoryCode,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b,TB商品分类表  c
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and c.CategoryItemCode='0000' and c.CategoryLevel=2 
and left(c.CategoryCode,1) between 1 and 5
and c.CategoryCode<>29   and c.CategoryCode<>19 and c.CategoryCode<>28 and c.CategoryCode<>23
and convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)>=OpenDate
and 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and b.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")})a
left join 
每日预算表 b on a.defday=b.defday and a.NodeCode=b.DeptCode
left join 
(select DeptCode,sum(Salesindex)/(DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))-case when datediff(day,dateadd(ms,0,DATEADD(mm, DATEDIFF(m,0,'${dqrq}'), 0)),OpenDate )<=0 then 0 else datediff(day,dateadd(ms,0,DATEADD(mm, DATEDIFF(m,0,'${dqrq}'), 0)),a.OpenDate ) end) Salesindex,sum(Grossprofitindex)/(DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))-case when datediff(day,dateadd(ms,0,DATEADD(mm, DATEDIFF(m,0,'${dqrq}'), 0)),OpenDate )+1<=0 then 0 else datediff(day,dateadd(ms,0,DATEADD(mm, DATEDIFF(m,0,'${dqrq}'), 0)),A.OpenDate)+1 end) Grossprofitindex from 
含税分课预算表 b
left join 
TB部门信息表 A on b.DeptCode =A.NodeCode 
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode,a.OpenDate)c on a.NodeCode=c.DeptCode 
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
where 1=1 ${if(len(bm) == 0,   "",   "and a.NodeCode in ('" + replace(bm,",","','")+"')") } 
group by 
AreaCode,NodeCode,case when OpenDate>convert(varchar(8),dateadd(yy,-1,'${dqrq}'),112) then 1 else 0 end
,case when 
 ( CategoryCode like '10%' or  CategoryCode like '11%' )  then '10' 
 when  
 ( CategoryCode like '12%' or  CategoryCode like '13%')  then '12' 
  when  
  CategoryCode like '2%'then '20' 
   when  
 ( CategoryCode like '30%' or  CategoryCode like '31%' or  CategoryCode like '32%')  then '30' 
    when  
 ( CategoryCode like '33%' or  CategoryCode like '34%')  then '33' 
     when  
 ( CategoryCode like '40%' or  CategoryCode like '41%'  or  CategoryCode like '42%'  or  CategoryCode like '43%'  or  CategoryCode like '44%'
  or  CategoryCode like '45%'  or  CategoryCode like '48%'  or  CategoryCode like '49%')  then '40' 
       when  
 ( CategoryCode like '46%'  or  CategoryCode like '47%' )  then '46' 
   when  
  CategoryCode like '5%'then '50' 
  else LEFT(CategoryCode,2) end


     
order by 2,4,3



select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店') NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店') Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表 a

where   left(a.nodecode,1) between 1 and 2 
and a.nodecode='${bm}'


