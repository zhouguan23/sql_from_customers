 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  Occurdate between  '+@qsrq+' and '+@dqrq+' '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPSSM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='
select NodeCode ,left(CategoryCode,2)CategoryName
,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(SaleIncome)SaleIncome,SUM(SaleCost)SaleCost    from 
[000]A .tbGoods a , ('+@SQL+')  b 
where a.GoodsCode =b.GoodsCode  and (NodeCode like ''1%'' or NodeCode like ''2%'') and CategoryCode not like ''0%'' and CategoryCode not like ''6%'' and goodsname like ''%黔鲜惠%''
group by NodeCode ,left(CategoryCode,2)

order by 1,2


'exec(@sql1)

