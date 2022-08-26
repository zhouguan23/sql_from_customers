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



SET @SQL='

select a.AreaCode,A.FormatCode,a.nodecode ,
isnull(aa.Salesindex,0)Salesindex,
isnull(b.SaleMoney,0)SaleMoney ,
isnull(aa.Grossprofitindex,0)Grossprofitindex,
isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit

from 
(select  AreaCode,FormatCode,NodeCode,c.ParentCategoryCode,c.CategoryCode,c.bm
from TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode=''0000''
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode=''0000''
where a.CategoryItemCode=''0000'' and a.CategoryLevel=''0'' and a.CategoryCode not like ''9%'')c
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and c.ParentCategoryCode=''4''
and OpenDate <= convert(varchar(8),dateadd(dd,0,GETDATE()),112)
and 1=1 ${if(len(yt) == 0,   "",   "and FormatCode in (''" + replace(yt,",","'',''")+"'')") }
and 1=1 ${if(len(dq) == 0,   "",   "and AreaCode in (''" + replace(dq,",","'',''")+"'')") }



and OpenDate<='+@dqrq+' )a
left join 
(select DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where (DeptCode   LIKE ''1%'' OR DeptCode   LIKE ''2%'' OR DeptCode   LIKE ''9%'')  and CategoryItemCode=''0000''
and BudgetYM  between '+@qsny+' and '+@jsny+' 
group by DeptCode,CategoryCode) aa on a.nodecode=aa.deptcode  and a.bm=aa.CategoryCode 



left join 
(select nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''
   when left(b.CategoryCode,2) in (''35'') then ''30''    
   else left(b.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''
   when left(b.CategoryCode,2) in (''35'') then ''30''    
   else left(b.CategoryCode,2) end)b on a.nodecode=b.nodecode  and a.bm=b.CategoryCode 



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



SET @SQL='

select a.AreaCode,A.FormatCode,a.nodecode ,
isnull(aa.Salesindex,0)Salesindex,
isnull(b.SaleMoney,0)SaleMoney ,
isnull(aa.Grossprofitindex,0)Grossprofitindex,
isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit

from 
(select  AreaCode,FormatCode,NodeCode,c.ParentCategoryCode,c.CategoryCode,c.bm
from TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode=''0000''
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode=''0000''
where a.CategoryItemCode=''0000'' and a.CategoryLevel=''0'' and a.CategoryCode not like ''9%'')c
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and c.ParentCategoryCode=''4''
and OpenDate <= convert(varchar(8),dateadd(dd,0,GETDATE()),112)
and 1=1 ${if(len(yt) == 0,   "",   "and FormatCode in (''" + replace(yt,",","'',''")+"'')") }
and 1=1 ${if(len(dq) == 0,   "",   "and AreaCode in (''" + replace(dq,",","'',''")+"'')") }



and OpenDate<='+@dqrq+' )a
left join 
(select DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where (DeptCode   LIKE ''1%'' OR DeptCode   LIKE ''2%'' OR DeptCode   LIKE ''9%'')  and CategoryItemCode=''0000''
and BudgetYM  between '+@qsny+' and '+@jsny+' 
group by DeptCode,CategoryCode) aa on a.nodecode=aa.deptcode  and a.bm=aa.CategoryCode 



left join 
(select nodecode ,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''
   when left(b.CategoryCode,2) in (''35'') then ''30''    
   else left(b.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,case when (left(b.CategoryCode,3) in (''280'',''287'') or b.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(b.CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(b.CategoryCode,3) in (''282'',''289'') then ''22''
   when left(b.CategoryCode,2) in (''35'') then ''30''    
   else left(b.CategoryCode,2) end)b on a.nodecode=b.nodecode  and a.bm=b.CategoryCode 



order by 2,1,3


'exec(@sql)




