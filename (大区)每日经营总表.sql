select AreaCode,NodeCode DeptCode,WhetherNew ,
isnull(b.Salesindex,0) Salesindex,
isnull(b.Grossprofitindex,0) Grossprofitindex
 from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112))>=20
 then 0 else 1 end  WhetherNew 
from TB部门信息表 b
where  (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%') AND nodecode<>'1047'
and OpenDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
 )a
left join 
(select DeptCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)b on a.NodeCode=b.DeptCode
order by 1,2,3

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
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=0

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.nodecode ,a.SaleMoney,a.TaxSaleGrossProfit,b.SaleCount from 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%''
and b.CategoryCode not like ''35000%''
GROUP BY nodecode)a
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode)b on a.nodecode= b.nodecode



ORDER BY 1


'exec(@sql)



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE 'CASHIERMSUM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.nodecode ,a.SaleMoney,a.TaxSaleGrossProfit,b.SaleCount from 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,[000]A.tbgoods b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%''
and b.CategoryCode not like ''35000%''

GROUP BY nodecode)a
left join 
(select nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
GROUP BY nodecode)b on a.nodecode= b.nodecode



ORDER BY 1


'exec(@sql)



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between  '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=2


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
and 1=1 ${if(len(bm) == 0,   "",   "and A.AreaCode in (''" + replace(bm,",","'',''")+"'')") }
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
and 1=1 ${if(len(bm) == 0,   "",   "and A.AreaCode in (''" + replace(bm,",","'',''")+"'')") }
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
where 1=1 ${if(len(bm) == 0,   "",   "and A.AreaCode in ('" + replace(bm,",","','")+"')") } 
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



select b.CategoryCode,b.CategoryName from 

[000]A.TBDEPTCATEGORY b 
where CategoryItemCode=0013 and CategoryCode not in (3,9)
and b.CategoryCode='${bm}'

