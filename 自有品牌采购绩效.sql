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
select NodeCode ,case
when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''30%'' or CategoryCode like ''31%'' or CategoryCode like ''32%'' or CategoryCode like ''33%'')  then ''30''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'')  then ''46''
when (CategoryCode like ''5%'')  then ''50''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''43%'' or CategoryCode like ''44%'' or CategoryCode like ''45%'')  then ''40''
else CategoryCode end CategoryCode,
case
when (CategoryCode like ''1%'' )  then ''生鲜''
when (CategoryCode like ''14%'' or CategoryCode like ''30%'' or CategoryCode like ''31%'' or CategoryCode like ''32%'' or CategoryCode like ''33%'')  then ''食品''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'')  then ''家纺''
when (CategoryCode like ''5%'')  then ''日化''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''43%'' or CategoryCode like ''44%'' or CategoryCode like ''45%'')  then ''家居''
else CategoryCode end CategoryName
,SUM(SaleIncome+SaleTax)SaleMoney,SUM(TAXSaleGrossProfit)SaleGrossProfit,SUM(SaleIncome)SaleIncome,SUM(SaleCost)SaleCost    from 
[000]A .tbGoods a , ('+@SQL+')  b 
where a.GoodsCode =b.GoodsCode  and (NodeCode like ''1%'' or NodeCode like ''2%'') and CategoryCode not like ''0%'' and CategoryCode not like ''6%''  and GoodsBrand=''010001''
group by NodeCode ,NodeCode ,case
when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''30%'' or CategoryCode like ''31%'' or CategoryCode like ''32%'' or CategoryCode like ''33%'')  then ''30''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'')  then ''46''
when (CategoryCode like ''5%'')  then ''50''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''43%'' or CategoryCode like ''44%'' or CategoryCode like ''45%'')  then ''40''
else CategoryCode end ,
case
when (CategoryCode like ''1%'' )  then ''生鲜''
when (CategoryCode like ''14%'' or CategoryCode like ''30%'' or CategoryCode like ''31%'' or CategoryCode like ''32%'' or CategoryCode like ''33%'')  then ''食品''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'')  then ''家纺''
when (CategoryCode like ''5%'')  then ''日化''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''43%'' or CategoryCode like ''44%'' or CategoryCode like ''45%'')  then ''家居''
else CategoryCode end
order by 1,2


'exec(@sql1)

