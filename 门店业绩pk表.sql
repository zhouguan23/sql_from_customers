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

select a.AreaCode,A.FormatCode,a.nodecode ,
isnull(aa.Salesindex,0)Salesindex,
isnull(b.SaleMoney,0)SaleMoney ,
isnull(aa.Grossprofitindex,0)Grossprofitindex,
isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,

isnull(c.SaleCount,0)SaleCount

from 
(select  AreaCode,FormatCode,NodeCode
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(yt) == 0,   "",   "and FormatCode in (''" + replace(yt,",","'',''")+"'')") }
and 1=1 ${if(len(dq) == 0,   "",   "and AreaCode in (''" + replace(dq,",","'',''")+"'')") }



and OpenDate<='+@dqrq+' )a
left join 
(select DeptCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE ''1%'' OR DeptCode   LIKE ''2%'' OR DeptCode   LIKE ''9%'')  and CategoryItemCode=''0000''
and BudgetYM  between '+@qsny+' and '+@jsny+'
group by DeptCode) aa on a.nodecode=aa.deptcode



left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode)c on a.nodecode= c.nodecode



order by 2,1,3


'exec(@sql)



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
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=0

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,A.FormatCode,a.nodecode ,
isnull(aa.Salesindex,0)Salesindex,
isnull(b.SaleMoney,0)SaleMoney ,
isnull(aa.Grossprofitindex,0)Grossprofitindex,
isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,

isnull(c.SaleCount,0)SaleCount

from 
(select  AreaCode,FormatCode,NodeCode
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(yt) == 0,   "",   "and FormatCode in (''" + replace(yt,",","'',''")+"'')") }
and 1=1 ${if(len(dq) == 0,   "",   "and AreaCode in (''" + replace(dq,",","'',''")+"'')") }



and OpenDate<='+@dqrq+' )a
left join 
(select DeptCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE ''1%'' OR DeptCode   LIKE ''2%'' OR DeptCode   LIKE ''9%'')  and CategoryItemCode=''0000''
and BudgetYM  between '+@qsny+' and '+@jsny+'
group by DeptCode) aa on a.nodecode=aa.deptcode



left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode)c on a.nodecode= c.nodecode



order by 2,1,3


'exec(@sql)



