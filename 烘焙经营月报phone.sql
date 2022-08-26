 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8),
@tqjsny varchar(6), @tqqsny varchar(6),@tqqsrq varchar(8),@tqdqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
set @tqdqrq=convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112)
set @tqjsny=@tqdqrq
set @tqqsrq=convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @tqqsny=@tqqsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between  '+@qsrq+' and '+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) between @qsny  and  @jsny

SET @SQL=STUFF(@SQL,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between  '+@tqqsrq+' and '+@tqdqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) between @tqqsny  and  @tqjsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL1='

select a.AreaCode,A.AreaName,a.DeptCode,A.OpenDate,a.CategoryCode ,isnull(a.Salesindex,0)Salesindex,isnull(b.SaleMoney,0)SaleMoney,isnull(a.Grossprofitindex,0)Grossprofitindex,isnull(b.SaleGrossProfit,0)SaleGrossProfit
,case when DATEDIFF(DD,OpenDate,CONVERT(varchar(15) , dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,''${tqdqrq}'')+1, 0)),112))+1>=20 then isnull(b.SaleMoney,0) else  0 end kb_SaleMoney
,case when DATEDIFF(DD,OpenDate,CONVERT(varchar(15) , dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,''${tqdqrq}'')+1, 0)),112))+1>=20 then isnull(b.SaleGrossProfit,0) else  0 end kb_SaleGrossProfit
,case when DATEDIFF(DD,OpenDate,CONVERT(varchar(15) , dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,''${tqdqrq}'')+1, 0)),112))+1>=20 then isnull(c.SaleMoney,0) else  0 end tb_SaleMoney
,case when DATEDIFF(DD,OpenDate,CONVERT(varchar(15) , dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,''${tqdqrq}'')+1, 0)),112))+1>=20 then isnull(c.SaleGrossProfit,0) else  0 end tb_SaleGrossProfit
 from
(select A.AreaCode,A.AreaName,a.NodeCode DeptCode,A.OpenDate,B.CategoryCode ,isnull(SUM(Salesindex),0)Salesindex,isnull(SUM(Grossprofitindex),0)Grossprofitindex  from 
TB部门信息表 A
LEFT JOIN 
含税分课预算表 B ON A.NodeCode=b.DeptCode and BudgetYM between  '+@qsny+' and '+@jsny+' and CategoryItemCode in (''0000'',''0002'')
WHERE  (a.NodeCode LIKE ''1%'' or a.NodeCode LIKE ''2%'')   and CategoryCode like ''22%'' and CategoryCode not like ''28'' and State!=2
and 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in (''" + replace(bm,",","'',''")+"'')") } 
GROUP BY A.AreaCode,A.AreaName,a.NodeCode ,A.OpenDate,B.CategoryCode)a
left join 
(select nodecode DeptCode,case when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end GoodsCatCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
tb商品档案 A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND CategoryCode LIKE ''2%''
GROUP BY nodecode,case when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end)b on a.deptcode=b.deptcode and a.CategoryCode=b.GoodsCatCode

   left join 
(select nodecode DeptCode,case when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end GoodsCatCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
tb商品档案 A,
 ('+@SQL2+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')  AND CategoryCode LIKE ''2%''
GROUP BY nodecode,case when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end)c on a.deptcode=c.deptcode and a.CategoryCode=c.GoodsCatCode
ORDER BY 1,5,3


'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between  '+@qsrq+' and '+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssM' and SUBSTRING(name,3,6) between @qsny  and  @jsny


 SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select a.AreaCode,A.AreaName,a.DeptCode,isnull(b.SaleMoney,0)SaleMoney

 from
(select A.AreaCode,A.AreaName,a.NodeCode DeptCode,A.OpenDate  from 
TB部门信息表 A
WHERE  (a.NodeCode LIKE ''1%'' or a.NodeCode LIKE ''2%'')  and State!=2
GROUP BY A.AreaCode,A.AreaName,a.NodeCode ,A.OpenDate)a
left join 
(select nodecode DeptCode,sum(SaleIncome+SaleTax)SaleMoney,sum(TaxSaleGrossProfit)SaleGrossProfit
  from 
tb商品档案 A,
 ('+@SQL+')  B
WHERE A.goodscode=b.goodscode and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'')
GROUP BY nodecode)b on a.deptcode=b.deptcode 

ORDER BY 1,3


'exec(@sql1)


select * from 
	dbo.日期对照表
	where OccurDate =convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

