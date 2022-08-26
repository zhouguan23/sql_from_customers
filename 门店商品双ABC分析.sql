select ParentCategoryCode,CategoryCode,CategoryCode+' '+CategoryName CategoryName  from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and (CategoryCode like '1%' or CategoryCode like '2%' or CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%') and CategoryLevel<=2




 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' 
where  occurdate between  '+@qsrq+' and '+@dqrq+' and 
(NODECODE LIKE ''1%'' OR NODECODE LIKE ''2%'')

 '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPSSM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='

select mx.*,
case when hz.salemoney=0 then 0 else ROUND( mx.salemoney/hz.salemoney,4)*100 end jeqz,
case when hz.SaleGrossProfit=0 then 0 else ROUND( mx.SaleGrossProfit/hz.SaleGrossProfit,4)*100 end mlqz 
into #mx
from 
(select DeptCategoryCode nodecode,GoodsCode,SUM(SaleIncome+SaleTax) salemoney,SUM(SaleGrossProfit)SaleGrossProfit,
row_number() over(partition by DeptCategoryCode order by SUM(SaleIncome+SaleTax) desc) JEXH,
row_number() over(partition by DeptCategoryCode order by SUM(SaleGrossProfit) desc) mlXH
from  ('+@SQL+') r ,[000]A.TBCATTODEPARTMENT b 
where r.nodecode=b.nodecode and b.DeptCatItemCode=0011 
and GoodsCode in (select GoodsCode from [000]A.tbgoods where  1=1  ${if(len(fl) == 0,   "",   "and left(CategoryCode,2)  in (''" + replace(fl,",","'',''")+"'')") })
and 1=1 ${if(len(bm) == 0,   "",   "and b.DeptCategoryCode  in (select DeptCategoryCode from  [000]A.TBCATTODEPARTMENT c where c.DeptCatItemCode=0011 and  c.nodecode in (''" + replace(bm,",","'',''")+"''))") }
 group by DeptCategoryCode,GoodsCode)mx
 left join 
 
 (select DeptCategoryCode nodecode,SUM(SaleIncome+SaleTax) salemoney,SUM(SaleGrossProfit)SaleGrossProfit
from  ('+@SQL+') r ,[000]A.TBCATTODEPARTMENT b 
where r.nodecode=b.nodecode and b.DeptCatItemCode=0011 
and GoodsCode in (select GoodsCode from [000]A.tbgoods where  1=1  ${if(len(fl) == 0,   "",   "and left(CategoryCode,2)  in (''" + replace(fl,",","'',''")+"'')") })
and 1=1 ${if(len(bm) == 0,   "",   "and b.DeptCategoryCode  in (select DeptCategoryCode from  [000]A.TBCATTODEPARTMENT c where c.DeptCatItemCode=0011 and  c.nodecode in (''" + replace(bm,",","'',''")+"''))") }
 group by DeptCategoryCode)hz on mx.nodecode=hz.nodecode


select r.nodecode,r.GoodsCode,g.GoodsName,g.CategoryCode,
Case When sumjeqz>0 and sumjeqz<=50 Then ''A'' When sumjeqz>50 and sumjeqz<=80 Then ''B'' When sumjeqz>80 Then ''C'' End +
Case When summlqz>0 and summlqz<=50 Then ''A'' When summlqz>50 and summlqz<=80 Then ''B'' When summlqz>80 Then ''C'' End ABC
 from 
(
 select a.*,
 (select sum(jeqz) from #mx  B where jeXH<=A.jeXH) sumjeqz,
 (select sum(mlqz) from #mx  B where mlXH<=A.mlXH) summlqz
 from #mx A) r
left join [000]A.tbgoods g on r.goodscode =g.GoodsCode 


order by 5
'exec(@sql1)







 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' 
where  occurdate between  '+@qsrq+' and '+@dqrq+' and 
(NODECODE LIKE ''1%'' OR NODECODE LIKE ''2%'')

 '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPSSM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='

select mx.*,
case when hz.salemoney=0 then 0 else ROUND( mx.salemoney/hz.salemoney,4)*100 end jeqz,
case when hz.SaleGrossProfit=0 then 0 else ROUND( mx.SaleGrossProfit/hz.SaleGrossProfit,4)*100 end mlqz 
into #mx
from 
(select nodecode,GoodsCode,SUM(SaleIncome+SaleTax) salemoney,SUM(SaleGrossProfit)SaleGrossProfit,
row_number() over(partition by nodecode order by SUM(SaleIncome+SaleTax) desc) JEXH,
row_number() over(partition by nodecode order by SUM(SaleGrossProfit) desc) mlXH
from  ('+@SQL+') r 
where GoodsCode in (select GoodsCode from [000]A.tbgoods where  1=1  ${if(len(fl) == 0,   "",   "and left(CategoryCode,2)  in (''" + replace(fl,",","'',''")+"'')") })
and    1=1 ${if(len(bm) == 0,   "",   "and nodecode  in (''" + replace(bm,",","'',''")+"'')") }
 group by nodecode,GoodsCode)mx
 left join 
 
 (select nodecode,SUM(SaleIncome+SaleTax) salemoney,SUM(SaleGrossProfit)SaleGrossProfit
from  ('+@SQL+') r 
where GoodsCode in (select GoodsCode from [000]A.tbgoods where  1=1  ${if(len(fl) == 0,   "",   "and left(CategoryCode,2)  in (''" + replace(fl,",","'',''")+"'')") })
and    1=1 ${if(len(bm) == 0,   "",   "and nodecode  in (''" + replace(bm,",","'',''")+"'')") }
 group by nodecode)hz on mx.nodecode=hz.nodecode


select r.nodecode,r.GoodsCode,g.GoodsName,s.WorkStateCode,g.CategoryCode,
Case When sumjeqz>0 and sumjeqz<=50 Then ''A'' When sumjeqz>50 and sumjeqz<=80 Then ''B'' When sumjeqz>80 Then ''C'' End +
Case When summlqz>0 and summlqz<=50 Then ''a'' When summlqz>50 and summlqz<=80 Then ''b'' When summlqz>80 Then ''c'' End ABC
 from 
(
 select a.*,
 (select sum(jeqz) from #mx  B where jeXH<=A.jeXH and nodecode=a.nodecode) sumjeqz,
 (select sum(mlqz) from #mx  B where mlXH<=A.mlXH and nodecode=a.nodecode) summlqz
 from #mx A) r
left join [000]A.tbgoods g on r.goodscode =g.GoodsCode 
left join [000]A.tbDeptWorkState  s on r.nodecode=s.DeptCode  and  r.goodscode=s.GoodsCode 

order by 6,5,2
'exec(@sql1)



