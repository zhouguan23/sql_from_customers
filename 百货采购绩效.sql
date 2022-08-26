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
when (CategoryCode like ''611%'')  then ''10''
when (CategoryCode like ''612%'' or CategoryCode like ''610%'')  then ''11''
when (CategoryCode like ''613%'' or CategoryCode like ''614%'' or CategoryCode like ''615%'' or CategoryCode like ''616%'' or CategoryCode like ''617%''or CategoryCode like ''618%'')  then ''12''
when (CategoryCode like ''621%'')  then ''13''
when (CategoryCode like ''620%'')  then ''14''
when (CategoryCode like ''622%'' or CategoryCode like ''623%'' or CategoryCode like ''624%'' or CategoryCode like ''63%'' or CategoryCode like ''30%'')  then ''15''
when (left(CategoryCode,3) in (641,643,645,646))  then ''16''
when (left(CategoryCode,3) in (642,644,647) )  then ''17''
when (CategoryCode like ''640%'')  then ''18''
else CategoryCode end CategoryCode,
case
when (CategoryCode like ''611%'')  then ''女鞋''
when (CategoryCode like ''612%'' or CategoryCode like ''610%'')  then ''男鞋''
when (CategoryCode like ''613%'' or CategoryCode like ''614%'' or CategoryCode like ''615%'' or CategoryCode like ''616%'' or CategoryCode like ''617%''or CategoryCode like ''618%'')  then ''童鞋''
when (CategoryCode like ''621%'')  then ''女装''
when (CategoryCode like ''620%'')  then ''男装''
when (CategoryCode like ''622%'' or CategoryCode like ''623%'' or CategoryCode like ''624%'' or CategoryCode like ''63%'' or CategoryCode like ''30%'')  then ''童装''
when (left(CategoryCode,3) in (641,643,645,646))  then ''婴童非食类''
when (left(CategoryCode,3) in (642,644,647) )  then ''婴童食品、用品类''
when (CategoryCode like ''640%'')  then ''婴童娱乐电玩''
else CategoryCode end CategoryName
,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(SaleIncome)SaleIncome,SUM(SaleCost)SaleCost    from 
[000]A .tbGoods a , ('+@SQL+')  b 
where a.GoodsCode =b.GoodsCode  and NodeCode like ''9%''  and (CategoryCode like ''6%''  or CategoryCode like ''3%'')
group by NodeCode ,case
when (CategoryCode like ''611%'')  then ''10''
when (CategoryCode like ''612%'' or CategoryCode like ''610%'')  then ''11''
when (CategoryCode like ''613%'' or CategoryCode like ''614%'' or CategoryCode like ''615%'' or CategoryCode like ''616%'' or CategoryCode like ''617%''or CategoryCode like ''618%'')  then ''12''
when (CategoryCode like ''621%'')  then ''13''
when (CategoryCode like ''620%'')  then ''14''
when (CategoryCode like ''622%'' or CategoryCode like ''623%'' or CategoryCode like ''624%'' or CategoryCode like ''63%'' or CategoryCode like ''30%'')  then ''15''
when (left(CategoryCode,3) in (641,643,645,646))  then ''16''
when (left(CategoryCode,3) in (642,644,647) )  then ''17''
when (CategoryCode like ''640%'')  then ''18''
else CategoryCode end,
case
when (CategoryCode like ''611%'')  then ''女鞋''
when (CategoryCode like ''612%'' or CategoryCode like ''610%'')  then ''男鞋''
when (CategoryCode like ''613%'' or CategoryCode like ''614%'' or CategoryCode like ''615%'' or CategoryCode like ''616%'' or CategoryCode like ''617%''or CategoryCode like ''618%'')  then ''童鞋''
when (CategoryCode like ''621%'')  then ''女装''
when (CategoryCode like ''620%'')  then ''男装''
when (CategoryCode like ''622%'' or CategoryCode like ''623%'' or CategoryCode like ''624%'' or CategoryCode like ''63%'' or CategoryCode like ''30%'')  then ''童装''
when (left(CategoryCode,3) in (641,643,645,646))  then ''婴童非食类''
when (left(CategoryCode,3) in (642,644,647) )  then ''婴童食品、用品类''
when (CategoryCode like ''640%'')  then ''婴童娱乐电玩''
else CategoryCode end
order by 1,2


'exec(@sql1)

