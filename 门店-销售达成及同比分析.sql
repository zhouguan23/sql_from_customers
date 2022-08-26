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

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),@SQL4 VARCHAR(MAX),@SQL5 VARCHAR(MAX),@SQL6 VARCHAR(MAX),@SQL7 VARCHAR(MAX),@SQL8 VARCHAR(MAX),@SQL9 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)

set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+' AND CategoryLevel=''2'' and CategoryItemCode  in(''0000'',''0001'')
and (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,9,99)  LIKE '_FLREPORTDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')

SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+' and CategoryLevel=''0'' and CategoryItemCode  in(''0000'')
and (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,9,99)  LIKE '_FLREPORTDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')

SET @SQL='

select a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm,isnull(e.SaleCount,0)DeptSaleCount,
sum(isnull(b.SaleMoney,0))SaleMoney,sum(isnull(b.TaxSaleGrossProfit,0))TaxSaleGrossProfit,
sum(isnull(b.SaleCount,0))SaleCount,sum(isnull(c.TaxStockCost,0))StockMoney

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

(select a.nodecode ,a.CategoryCode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(SaleCount)SaleCount  from 
 ('+@SQL1+')  a
group by a.nodecode ,a.CategoryCode )b on a.nodecode=b.nodecode and a.bm=b.CategoryCode
left join 
(select a.nodecode ,a.CategoryCode ,sum(StockCost+TaxStockCost)TaxStockCost  from 
 ('+@SQL1+')  a
 where occurdate='+@dqrq+'
group by a.nodecode ,a.CategoryCode )c on a.nodecode=c.nodecode and a.bm=c.CategoryCode
left join

(select a.nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
group by a.nodecode  )e on a.nodecode=e.nodecode 



group by a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm ,isnull(e.SaleCount,0)
ORDER BY a.AreaCode,a.NodeCode ,a.CategoryCode ,a.ParentCategoryCode,a.bm


'exec(@sql)



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),@SQL4 VARCHAR(MAX),@SQL5 VARCHAR(MAX),@SQL6 VARCHAR(MAX),@SQL7 VARCHAR(MAX),@SQL8 VARCHAR(MAX),@SQL9 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)

set @dqrq=convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+' AND CategoryLevel=''2'' and CategoryItemCode  in(''0000'',''0001'')
and (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,9,99)  LIKE '_FLREPORTDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')

SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+' and CategoryLevel=''0'' and CategoryItemCode  in(''0000'')
and (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,9,99)  LIKE '_FLREPORTDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')

SET @SQL='

select a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm,isnull(e.SaleCount,0)DeptSaleCount,
sum(isnull(b.SaleMoney,0))SaleMoney,sum(isnull(b.TaxSaleGrossProfit,0))TaxSaleGrossProfit,
sum(isnull(b.SaleCount,0))SaleCount,sum(isnull(c.TaxStockCost,0))StockMoney

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

(select a.nodecode ,a.CategoryCode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(SaleCount)SaleCount  from 
 ('+@SQL1+')  a
group by a.nodecode ,a.CategoryCode )b on a.nodecode=b.nodecode and a.bm=b.CategoryCode
left join 
(select a.nodecode ,a.CategoryCode ,sum(StockCost+TaxStockCost)TaxStockCost  from 
 ('+@SQL1+')  a
 where occurdate='+@dqrq+'
group by a.nodecode ,a.CategoryCode )c on a.nodecode=c.nodecode and a.bm=c.CategoryCode
left join

(select a.nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
group by a.nodecode  )e on a.nodecode=e.nodecode 



group by a.AreaCode,a.NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm ,isnull(e.SaleCount,0)
ORDER BY a.AreaCode,a.NodeCode ,a.CategoryCode ,a.ParentCategoryCode,a.bm


'exec(@sql)



select AreaCode,NodeCode ,NodeCode+' '+Nodename Nodename,WhetherNew,a.ParentCategoryCode,a.CategoryCode,A.bm,a.defday,
 row_number() over(partition by  AreaCode,NodeCode ,Nodename ,WhetherNew,a.ParentCategoryCode,LEFT(a.CategoryCode,1),A.BM order by a.defday asc) as ID,
sum(round(case when isnull(b.Salesindex,0)*isnull(d.xszb,0)<>0 then isnull(b.Salesindex,0)*isnull(d.xszb,0) else isnull(c.Salesindex,0)*isnull(d.xszb,0) end ,2)) Salesindex,
sum(round(case when isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0)<>0 then  isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0) else isnull(c.Grossprofitindex,0)*isnull(d.mlzb,0) end,2)) Grossprofitindex
 from 
(select  AreaCode,NodeCode,Nodename  ,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112))>=20
 then 0 else 1 end  WhetherNew,c.ParentCategoryCode,c.CategoryCode,c.bm,

convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${qsrq}')+1,'${qsrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0000'
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode='0000'
where a.CategoryItemCode='0000' and a.CategoryLevel='0' and a.CategoryCode not like '9%')  c
where type='p' and number <= datediff(dd,dateadd(dd,-day('${qsrq}')+1,'${qsrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and left(c.CategoryCode,1) between 1 and 5
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }

and OpenDate <= convert(varchar(8),dateadd(dd,0,GETDATE()),112)
)a
left join 
每日预算表 b on a.defday=b.defday and a.NodeCode=b.DeptCode
left join 
(select DeptCode,sum(Salesindex)/(DATEDIFF(DD,convert(varchar(8),dateadd(dd,0,'${qsrq}'),112) , convert(varchar(8),dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)),112))+1)Salesindex,
sum(Grossprofitindex)/(DATEDIFF(DD,convert(varchar(8),dateadd(dd,0,'${qsrq}'),112) , convert(varchar(8),dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)),112))+1)Grossprofitindex from 
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
where a.DeptCode=b.DeptCode)d on a.NodeCode=d.DeptCode and a.bm=d.CategoryCode 

group by AreaCode,NodeCode ,Nodename ,WhetherNew,a.ParentCategoryCode,a.CategoryCode,A.BM,a.defday
order by AreaCode,NodeCode ,Nodename ,WhetherNew,a.ParentCategoryCode,a.CategoryCode,A.BM,a.defday


select b.CategoryCode,b.CategoryName from 

[000]A.TBDEPTCATEGORY b 
where CategoryItemCode=0013 and CategoryCode not in (3,9)
and b.CategoryCode='${bm}'

select  * from 
tb分类对照表
where CategoryItemCode='0000' and CategoryLevel<=1


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),@SQL4 VARCHAR(MAX),@SQL5 VARCHAR(MAX),@SQL6 VARCHAR(MAX),@SQL7 VARCHAR(MAX),@SQL8 VARCHAR(MAX),@SQL9 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)

set @dqrq=convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+' AND CategoryLevel=''0'' and CategoryItemCode  in(''0000'',''0001'')
and (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,9,99)  LIKE '_FLREPORTDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')


SET @SQL='

select a.occurdate,a.nodecode ,a.CategoryCode 
, row_number() over(partition by  nodecode ,CategoryCode order by OccurDate asc) as ID
,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(SaleCount)SaleCount,sum(SaleCount)SaleCount  from 
 ('+@SQL1+')  a
 where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in (''" + replace(bm,",","'',''")+"'')") }
group by a.occurdate,a.nodecode ,a.CategoryCode

'exec(@sql)



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),@SQL4 VARCHAR(MAX),@SQL5 VARCHAR(MAX),@SQL6 VARCHAR(MAX),@SQL7 VARCHAR(MAX),@SQL8 VARCHAR(MAX),@SQL9 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)

set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+' AND CategoryLevel=''0'' and CategoryItemCode  in(''0000'',''0001'')
and (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,9,99)  LIKE '_FLREPORTDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')


SET @SQL='

select a.occurdate,a.nodecode 
, row_number() over(partition by  nodecode  order by OccurDate asc) as ID
,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(SaleCount)SaleCount,sum(StockCost+TaxStockCost )TaxStockCost  from 
 ('+@SQL1+')  a
 where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in (''" + replace(bm,",","'',''")+"'')") }
group by a.occurdate,a.nodecode

'exec(@sql)



