select AreaCode,NodeCode DeptCode,Nodename,WhetherNew ,
isnull(b.Salesindex,0) Salesindex,
isnull(b.Grossprofitindex,0) Grossprofitindex
 from 
(select  AreaCode,NodeCode,Nodename,case when 
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
GROUP BY nodecode)a
left join 
(select nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
GROUP BY nodecode)b on a.nodecode= b.nodecode



ORDER BY 1


'exec(@sql)



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),@SQL4 VARCHAR(MAX),@SQL5 VARCHAR(MAX),@SQL6 VARCHAR(MAX),@SQL7 VARCHAR(MAX),@SQL8 VARCHAR(MAX),@SQL9 VARCHAR(MAX),
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

SET @SQL3=''
SELECT @SQL3=@SQL3+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=2

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL3=STUFF(@SQL3,1,11,'')

SET @SQL4=''
SELECT @SQL4=@SQL4+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=1

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL4=STUFF(@SQL4,1,11,'')

SET @SQL5=''
SELECT @SQL5=@SQL5+' UNION ALL SELECT * FROM '+[name]A+' where occurdate <= '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) = @jsny

SET @SQL5=STUFF(@SQL5,1,11,'')

SET @SQL6=''
SELECT @SQL6=@SQL6+' UNION ALL SELECT * FROM '+[name]A+' 

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_Goodsmonpssm' and SUBSTRING(name,3,6) = @jsny

SET @SQL6=STUFF(@SQL6,1,11,'')

SET @SQL7=''
SELECT @SQL7=@SQL7+' UNION ALL SELECT * FROM '+[name]A+' where AccDate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_门店促销销售' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL7=STUFF(@SQL7,1,11,'')

SET @SQL8=''
SELECT @SQL8=@SQL8+' UNION ALL SELECT * FROM '+[name]A+' a 
where not exists(select 1 from 
TB部门特殊商品对照 b
where b.GoodsPropertyCode=''2002'' and a.部门编码=b.NodeCode and a.商品编码=b.goodscode) 
and  a.经营状态 in (1,2,5) and 报表日期<='+@dqrq+'
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '报表数据源' and SUBSTRING(name,3,6) = @jsny

SET @SQL8=STUFF(@SQL8,1,11,'')

SET @SQL9=''
SELECT @SQL9=@SQL9+' UNION ALL SELECT * FROM '+[name]A+' where BuildDate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_租赁商品销售明细' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL9=STUFF(@SQL9,1,11,'')
SET @SQL='

select a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm,
sum(isnull(b.SaleMoney,0))+sum(isnull(k.SaleMoney,0))SaleMoney,sum(isnull(b.TaxSaleGrossProfit,0))TaxSaleGrossProfit,
sum(isnull(b.SaleCost,0))SaleCost,sum(isnull(h.cxSaleMoney,0))CXSaleMoney,
sum(isnull(j.SaleMoney,0))QHSaleMoney,
isnull(e.SaleCount,0)SaleCount,isnull(d.SaleCount,0)SaleCount1 ,sum(isnull(c.SaleCount,0))SaleCount2, 
round(sum(isnull(f.StartCost,0))+sum(isnull(g.StockCost,0)),2)StockCost,
round(sum(isnull(f.TaxStartCost,0))+sum(isnull(g.TaxStockCost,0)),2)StockMoney,
sum(isnull(i.可订货次数,0))可订货次数,sum(isnull(i.门店缺货次数,0))门店缺货次数

from 
(select  AreaCode,NodeCode ,c.ParentCategoryCode,c.CategoryCode,c.bm
from TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode=''0000''
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode=''0000''
where a.CategoryItemCode=''0000'' and a.CategoryLevel=''0'' and a.CategoryCode not like ''9%'' and left(c.CategoryCode,2) not in (''28'',''29''))  c
where (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'')
and left(c.CategoryCode,1) between 1 and 5 

and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in (''" + replace(bm,",","'',''")+"'')") }

)a
left join

(select nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(case when b.GoodsType in (1,6,7) then 0 else   SaleCost end )SaleCost  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%''
GROUP BY nodecode,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end)b on a.nodecode=b.nodecode and a.bm=b.CategoryCode
left join

(select  DeptCode nodecode ,GoodsCatCode CategoryCode,sum(SaleCount)SaleCount  from 
 ('+@SQL3+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsCatCode not like ''23%''
GROUP BY DeptCode ,GoodsCatCode )c on a.nodecode=c.nodecode and a.bm=c.CategoryCode

left join

(select  DeptCode nodecode ,GoodsCatCode CategoryCode,sum(SaleCount)SaleCount  from 
 ('+@SQL4+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode ,GoodsCatCode )d on a.nodecode=d.nodecode and a.ParentCategoryCode=d.CategoryCode
left join

(select  DeptCode nodecode ,GoodsCatCode CategoryCode,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode ,GoodsCatCode )e on a.nodecode=e.nodecode 

left join

(select nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end CategoryCode,sum(case when b.GoodsType in (1,6,7) then 0 else    StartCost end )StartCost,sum(StartCost+StartTax)TaxStartCost  from 
 ('+@SQL6+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%''
GROUP BY nodecode,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end )f on a.nodecode=f.nodecode and a.bm=f.CategoryCode

left join

(select nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end CategoryCode,
sum(case when b.GoodsType in (1,6,7) then 0 else   PURCHCOST +  REDEPLOYINCOST + PROFITCOST + COUNTPROFITCOST - SALECOST - REDEPLOYOUTCOST - LOSSCOST - COUNTLOSSCOST-ToGiftCost  end )StockCost,
sum((PURCHCOST+PurchTax)+(REDEPLOYINCOST+RedeployinTax) + (PROFITCOST+ProfitTax) + (COUNTPROFITCOST+CountProfitTax) - (TaxSaleCost) - (REDEPLOYOUTCOST+RedeployoutTax) - (LOSSCOST+LossTax) - (COUNTLOSSCOST+CountLossTax) -(ToGiftCost+ToGiftTax) )TAXStockCost  from 
 ('+@SQL5+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%''
GROUP BY nodecode,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end )g on a.nodecode=g.nodecode and a.bm=g.CategoryCode

left join

(select DeptCode nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)cxSaleMoney  from 
 ('+@SQL7+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%''
GROUP BY DeptCode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end )h on a.nodecode=h.nodecode and a.bm=h.CategoryCode

left join

(select 部门编码 nodecode ,left(b.CategoryCode,2)CategoryCode,count(商品编码)可订货次数,sum(case when a.库存数量<=0 and a.促销DMS +a.正常DMS >0.00 and a.中央控制标识=0  then 1 else 0 end )门店缺货次数  from 
 ('+@SQL8+')  a,tb商品档案 b 
WHERE a.商品编码=b.goodscode  and  (部门编码 LIKE ''1%'' OR 部门编码 LIKE ''2%'' )  and b.GoodsType=''0''
and b.CategoryCode not like ''1%'' and b.CategoryCode not like ''2%'' and b.CategoryCode not like ''6%'' and b.CategoryCode not like ''300%''
GROUP BY 部门编码 ,left(b.CategoryCode,2))i on a.nodecode=i.nodecode and a.bm=i.CategoryCode

left join

(select nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%'' and b.GoodsBrand=''010001''
GROUP BY nodecode,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end)j on a.nodecode=j.nodecode and a.bm=j.CategoryCode
left join

(select DeptCode nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney  from 
 ('+@SQL9+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%'' 
GROUP BY DeptCode,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end)k on a.nodecode=k.nodecode and a.bm=k.CategoryCode


group by a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm ,isnull(d.SaleCount,0),isnull(e.SaleCount,0)
ORDER BY a.AreaCode,a.NodeCode ,a.CategoryCode ,a.ParentCategoryCode,a.bm


'exec(@sql)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),@SQL4 VARCHAR(MAX),@SQL5 VARCHAR(MAX),@SQL6 VARCHAR(MAX),@SQL7 VARCHAR(MAX),@SQL8 VARCHAR(MAX),@SQL9 VARCHAR(MAX),
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
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=0

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')

SET @SQL3=''
SELECT @SQL3=@SQL3+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=2

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL3=STUFF(@SQL3,1,11,'')

SET @SQL4=''
SELECT @SQL4=@SQL4+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=1

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL4=STUFF(@SQL4,1,11,'')


SET @SQL7=''
SELECT @SQL7=@SQL7+' UNION ALL SELECT * FROM '+[name]A+' where AccDate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_门店促销销售' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL7=STUFF(@SQL7,1,11,'')


SET @SQL9=''
SELECT @SQL9=@SQL9+' UNION ALL SELECT * FROM '+[name]A+' where BuildDate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_租赁商品销售明细' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL9=STUFF(@SQL9,1,11,'')
SET @SQL='

select a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm,
sum(isnull(b.SaleMoney,0))+sum(isnull(k.SaleMoney,0))SaleMoney,sum(isnull(b.TaxSaleGrossProfit,0))TaxSaleGrossProfit,
sum(isnull(b.SaleCost,0))SaleCost,sum(isnull(h.cxSaleMoney,0))CXSaleMoney,
sum(isnull(j.SaleMoney,0))QHSaleMoney,
isnull(e.SaleCount,0)SaleCount,isnull(d.SaleCount,0)SaleCount1 ,sum(isnull(c.SaleCount,0))SaleCount2

from 
(select  AreaCode,NodeCode ,c.ParentCategoryCode,c.CategoryCode,c.bm
from TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode=''0000''
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode=''0000''
where a.CategoryItemCode=''0000'' and a.CategoryLevel=''0'' and a.CategoryCode not like ''9%'' and c.CategoryCode not like ''29%'' and c.CategoryCode not like ''28%'')  c
where (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'')
and left(c.CategoryCode,1) between 1 and 5
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in (''" + replace(bm,",","'',''")+"'')") }

)a
left join

(select nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(case when b.GoodsType in (1,6,7) then 0 else   SaleCost end )SaleCost  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%''
GROUP BY nodecode,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end)b on a.nodecode=b.nodecode and a.bm=b.CategoryCode
left join

(select  DeptCode nodecode ,GoodsCatCode CategoryCode,sum(SaleCount)SaleCount  from 
 ('+@SQL3+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsCatCode not like ''23%''
GROUP BY DeptCode ,GoodsCatCode )c on a.nodecode=c.nodecode and a.bm=c.CategoryCode

left join

(select  DeptCode nodecode ,GoodsCatCode CategoryCode,sum(SaleCount)SaleCount  from 
 ('+@SQL4+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode ,GoodsCatCode )d on a.nodecode=d.nodecode and a.ParentCategoryCode=d.CategoryCode
left join

(select  DeptCode nodecode ,GoodsCatCode CategoryCode,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode ,GoodsCatCode )e on a.nodecode=e.nodecode 

left join


(select DeptCode nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)cxSaleMoney  from 
 ('+@SQL7+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%''
GROUP BY DeptCode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end )h on a.nodecode=h.nodecode and a.bm=h.CategoryCode

left join


(select nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%'' and b.GoodsBrand=''010001''
GROUP BY nodecode,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end)j on a.nodecode=j.nodecode and a.bm=j.CategoryCode
left join

(select DeptCode nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney  from 
 ('+@SQL9+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%'' 
GROUP BY DeptCode,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(b.CategoryCode,2) end)k on a.nodecode=k.nodecode and a.bm=k.CategoryCode


group by a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode ,a.bm,isnull(d.SaleCount,0),isnull(e.SaleCount,0)
ORDER BY a.AreaCode,a.NodeCode,a.bm,a.CategoryCode ,a.ParentCategoryCode


'exec(@sql)


select AreaCode,NodeCode ,NodeCode+' '+Nodename Nodename,WhetherNew ,a.ParentCategoryCode,a.CategoryCode,A.bm,
sum(isnull(b.Salesindex,0)) Salesindex,
sum(isnull(b.Grossprofitindex,0)) Grossprofitindex
 from 
(select  AreaCode,NodeCode,Nodename ,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112))>=20
 then 0 else 1 end  WhetherNew,c.ParentCategoryCode,c.CategoryCode,c.bm
from TB部门信息表 b,
(select a.CategoryItemCode,case when a.CategoryCode='7' then '3' else a.CategoryCode end  ParentCategoryCode,case when b.CategoryCode='39' then '30' else b.CategoryCode end CategoryCode,b.CategoryName,c.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode 
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode 
where a.CategoryItemCode='0000' and a.CategoryLevel='0' 
and a.CategoryCode  like '9%'   )  c
where (NodeCode  LIKE '9%' )
and left(c.CategoryCode,1) between 6 and 6  
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }

)a
left join 
(select DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where( DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode,CategoryCode)b on a.NodeCode=b.DeptCode and a.bm=b.CategoryCode

group by AreaCode,NodeCode,Nodename,WhetherNew,a.ParentCategoryCode,a.CategoryCode,A.bm
order by AreaCode,NodeCode,Nodename,WhetherNew,A.bm,a.CategoryCode,a.ParentCategoryCode

select b.CategoryCode,b.CategoryName from 

[000]A.TBDEPTCATEGORY b 
where CategoryItemCode=0013 and CategoryCode not in (3,9)
and b.CategoryCode='${bm}'

select  * from 
tb分类对照表
where CategoryItemCode='0000' and CategoryLevel<=1


select 
NodeCode,NodeName ,NodeCode+' '+NodeName Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表

where 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")} and left(nodecode,1) in ('9') and nodecode not in ('9999') and len(AreaCode)>0 

