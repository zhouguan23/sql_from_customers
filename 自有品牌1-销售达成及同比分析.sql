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
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
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
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
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




SET @SQL9=''
SELECT @SQL9=@SQL9+' UNION ALL SELECT * FROM '+[name]A+' where BuildDate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_租赁商品销售明细' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL9=STUFF(@SQL9,1,11,'')
SET @SQL='

select a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm,
sum(isnull(b.SaleMoney,0))+sum(isnull(k.SaleMoney,0))SaleMoney,sum(isnull(b.TaxSaleGrossProfit,0))TaxSaleGrossProfit,
round(sum(isnull(f.StartCost,0))+sum(isnull(g.StockCost,0)),2)StockCost,
round(sum(isnull(f.TaxStartCost,0))+sum(isnull(g.TaxStockCost,0)),2)StockMoney

from 
(select  AreaCode,NodeCode ,c.ParentCategoryCode,case
when (CategoryCode like ''1%'' or CategoryCode like ''2%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'')  then ''46''
when (CategoryCode like ''5%'')  then ''50''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''43%'' or CategoryCode like ''44%'' or CategoryCode like ''45%'')  then ''40''
else CategoryCode end CategoryCode,c.CategoryCode bm
from TB部门信息表 b,dbo.TB商品分类表 c

where (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'')
and c.CategoryItemCode=''0000'' and c.CategoryLevel=2 and left(c.CategoryCode,1) between 1 and 5
and left(c.CategoryCode,1)  between ''1'' and ''5''

and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in (''" + replace(bm,",","'',''")+"'')") }


)a
left join

(select nodecode ,left(b.CategoryCode,2) CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,left(b.CategoryCode,2))b on a.nodecode=b.nodecode and a.bm=b.CategoryCode




left join

(select nodecode ,left(b.CategoryCode,2) CategoryCode,sum(case when b.GoodsType in (1,6,7) then 0 else    StartCost end )StartCost,sum(StartCost+StartTax)TaxStartCost  from 
 ('+@SQL6+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,left(b.CategoryCode,2))f on a.nodecode=f.nodecode and a.bm=f.CategoryCode

left join

(select nodecode ,left(b.CategoryCode,2) CategoryCode,
sum(case when b.GoodsType in (1,6,7) then 0 else   PURCHCOST +  REDEPLOYINCOST + PROFITCOST + COUNTPROFITCOST - SALECOST - REDEPLOYOUTCOST - LOSSCOST - COUNTLOSSCOST-ToGiftCost  end )StockCost,
sum((PURCHCOST+PurchTax)+(REDEPLOYINCOST+RedeployinTax) + (PROFITCOST+ProfitTax) + (COUNTPROFITCOST+CountProfitTax) - (TaxSaleCost) - (REDEPLOYOUTCOST+RedeployoutTax) - (LOSSCOST+LossTax) - (COUNTLOSSCOST+CountLossTax) -(ToGiftCost+ToGiftTax) )TAXStockCost  from 
 ('+@SQL5+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,left(b.CategoryCode,2) )g on a.nodecode=g.nodecode and a.bm=g.CategoryCode



left join

(select DeptCode nodecode ,left(b.CategoryCode,2) CategoryCode,sum(SaleIncome+saletax)SaleMoney  from 
 ('+@SQL9+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsBrand=''010001''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.deptcode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY DeptCode,left(b.CategoryCode,2))k on a.nodecode=k.nodecode and a.bm=k.CategoryCode


group by a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm 



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




SET @SQL9=''
SELECT @SQL9=@SQL9+' UNION ALL SELECT * FROM '+[name]A+' where BuildDate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_租赁商品销售明细' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL9=STUFF(@SQL9,1,11,'')
SET @SQL='

select a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm,
sum(isnull(b.SaleMoney,0))+sum(isnull(k.SaleMoney,0))SaleMoney,sum(isnull(b.TaxSaleGrossProfit,0))TaxSaleGrossProfit,
round(sum(isnull(f.StartCost,0))+sum(isnull(g.StockCost,0)),2)StockCost,
round(sum(isnull(f.TaxStartCost,0))+sum(isnull(g.TaxStockCost,0)),2)StockMoney

from 
(select  AreaCode,NodeCode ,c.ParentCategoryCode,case
when (CategoryCode like ''1%'' or CategoryCode like ''2%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'')  then ''46''
when (CategoryCode like ''5%'')  then ''50''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''43%'' or CategoryCode like ''44%'' or CategoryCode like ''45%'')  then ''40''
else CategoryCode end CategoryCode,c.CategoryCode bm
from TB部门信息表 b,dbo.TB商品分类表 c

where (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'')
and c.CategoryItemCode=''0000'' and c.CategoryLevel=2 and left(c.CategoryCode,1) between 1 and 5
and c.CategoryCode in (10,30,40,46,50)

and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in (''" + replace(bm,",","'',''")+"'')") }


)a
left join

(select nodecode ,left(b.CategoryCode,2) CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,left(b.CategoryCode,2))b on a.nodecode=b.nodecode and a.bm=b.CategoryCode




left join

(select nodecode ,left(b.CategoryCode,2) CategoryCode,sum(case when b.GoodsType in (1,6,7) then 0 else    StartCost end )StartCost,sum(StartCost+StartTax)TaxStartCost  from 
 ('+@SQL6+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,left(b.CategoryCode,2))f on a.nodecode=f.nodecode and a.bm=f.CategoryCode

left join

(select nodecode ,left(b.CategoryCode,2) CategoryCode,
sum(case when b.GoodsType in (1,6,7) then 0 else   PURCHCOST +  REDEPLOYINCOST + PROFITCOST + COUNTPROFITCOST - SALECOST - REDEPLOYOUTCOST - LOSSCOST - COUNTLOSSCOST-ToGiftCost  end )StockCost,
sum((PURCHCOST+PurchTax)+(REDEPLOYINCOST+RedeployinTax) + (PROFITCOST+ProfitTax) + (COUNTPROFITCOST+CountProfitTax) - (TaxSaleCost) - (REDEPLOYOUTCOST+RedeployoutTax) - (LOSSCOST+LossTax) - (COUNTLOSSCOST+CountLossTax) -(ToGiftCost+ToGiftTax) )TAXStockCost  from 
 ('+@SQL5+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,left(b.CategoryCode,2) )g on a.nodecode=g.nodecode and a.bm=g.CategoryCode



left join

(select DeptCode nodecode ,left(b.CategoryCode,2) CategoryCode,sum(SaleIncome+saletax)SaleMoney  from 
 ('+@SQL9+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsBrand=''010001''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.deptcode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY DeptCode,left(b.CategoryCode,2))k on a.nodecode=k.nodecode and a.bm=k.CategoryCode


group by a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm 



'exec(@sql)


select AreaCode,NodeCode ,NodeCode+' '+Nodename Nodename,WhetherNew ,a.ParentCategoryCode,a.CategoryCode,A.bm,
sum(isnull(b.Salesindex,0)) Salesindex,
sum(isnull(b.Grossprofitindex,0)) Grossprofitindex
 from 
( select  AreaCode,NodeCode,Nodename ,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112))>=20
 then 0 else 1 end  WhetherNew,c.ParentCategoryCode,c.CategoryCode,c.CategoryCode bm
from TB部门信息表 b,dbo.TB商品分类表 c

where (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and c.CategoryItemCode='0000' and c.CategoryLevel=2 and left(c.CategoryCode,1) between 1 and 5
and c.CategoryCode in (10,30,40,46,50)

and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }


)a
left join 
(select DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' )  and CategoryItemCode='0001'
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


