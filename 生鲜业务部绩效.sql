 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  Occurdate between  '+@qsrq+' and '+@dqrq+' '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPSSM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='
select NodeCode ,case
when (CategoryCode like ''10%'')  then ''10''
when (CategoryCode like ''11%'')  then ''11''
when (CategoryCode like ''12%'')  then ''12''
when (CategoryCode like ''13%'')  then ''13''
when (CategoryCode like ''14%'')  then ''14''
when (CategoryCode like ''20%'' or CategoryCode like ''280%'' or CategoryCode like ''29000%'' or CategoryCode like ''29001%'' or CategoryCode like ''29002%'' or CategoryCode like ''29005%'' or CategoryCode like ''2901%'' or CategoryCode like ''2902%'')  then ''15''
when (CategoryCode like ''21%'' or CategoryCode like ''281%'' or CategoryCode like ''29004%'' )  then ''16''
when (CategoryCode like ''22%'' or CategoryCode like ''282%'' or CategoryCode like ''29003%'' or CategoryCode like ''29006%'')  then ''17''
when (CategoryCode like ''23%'')  then ''18''
when (CategoryCode like ''300%'' or CategoryCode like ''301%'' or CategoryCode like ''302%'' or CategoryCode like ''303%'' or CategoryCode like ''304%'')  then ''19''
when (CategoryCode like ''305%'' or CategoryCode like ''306%'' or CategoryCode like ''307%'' or CategoryCode like ''308%'' or CategoryCode like ''309%'')  then ''20''
when (CategoryCode like ''3107%'' or CategoryCode like ''3108%'' or CategoryCode like ''3113%'' or CategoryCode like ''3127%'' or CategoryCode like ''3137%'' or CategoryCode like ''3147%'')  then ''21''
when (left(CategoryCode,4) between ''3100'' and ''3106'' or left(CategoryCode,4) between ''3110'' and ''3112''  or left(CategoryCode,4) between ''3120'' and ''3126'' or left(CategoryCode,4) between ''3130'' and ''3136'' or left(CategoryCode,4) between ''3140'' and ''3146'' or CategoryCode like ''3190%'')  then ''22''
when (CategoryCode like ''32%'')  then ''23''
when (left(CategoryCode,3) between ''340'' and ''342''  )  then ''24''
when (left(CategoryCode,3) between ''343'' and ''346''  or CategoryCode like ''349%'' )  then ''25''
when (CategoryCode like ''40%'')  then ''29''
when (CategoryCode like ''41%'' or CategoryCode like ''42%'' or CategoryCode like ''43%'')  then ''30''
when (CategoryCode like ''44%'' or CategoryCode like ''45%'' or CategoryCode like ''48%'' or CategoryCode like ''49%'')  then ''31''
when (CategoryCode like ''46%'' or CategoryCode like ''470%'' or CategoryCode like ''471%'' or CategoryCode like ''472%'' or CategoryCode like ''474%'' or CategoryCode like ''479%'')  then ''32''
when (CategoryCode like ''473%'' or CategoryCode like ''475%'' or CategoryCode like ''476%'' or CategoryCode like ''477%'' or CategoryCode like ''478%'')  then ''33''
when (CategoryCode like ''508%'' or CategoryCode like ''5061%'' or CategoryCode like ''5062%'' or CategoryCode like ''5063%'' or CategoryCode like ''5064%'' or CategoryCode like ''5065%'' or CategoryCode like ''51%'')  then ''34''
when (CategoryCode like ''502%'' or CategoryCode like ''504%'' or CategoryCode like ''5060%'' or CategoryCode like ''50301%'' )  then ''35''
when (CategoryCode like ''500%'' or CategoryCode like ''501%'' or CategoryCode like ''505%'' or CategoryCode like ''507%'' or CategoryCode like ''509%'' or CategoryCode like ''5031%'' or CategoryCode like ''50300%'' or CategoryCode like ''50302%'' or CategoryCode like ''52%'')  then ''36''
else CategoryCode end CategoryCode,
case
when (CategoryCode like ''10%'')  then ''生食''
when (CategoryCode like ''11%'')  then ''水产''
when (CategoryCode like ''12%'')  then ''蔬菜''
when (CategoryCode like ''13%'')  then ''水果''
when (CategoryCode like ''14%'')  then ''干货''
when (CategoryCode like ''20%'' or CategoryCode like ''280%'' or CategoryCode like ''29000%'' or CategoryCode like ''29001%'' or CategoryCode like ''29002%'' or CategoryCode like ''29005%'' or CategoryCode like ''2901%'' or CategoryCode like ''2902%'')  then ''熟食''
when (CategoryCode like ''21%'' or CategoryCode like ''281%'' or CategoryCode like ''29004%'' )  then ''面点''
when (CategoryCode like ''22%'' or CategoryCode like ''282%'' or CategoryCode like ''29003%'' or CategoryCode like ''29006%'')  then ''面包''
when (CategoryCode like ''23%'')  then ''餐饮''
when (CategoryCode like ''300%'' or CategoryCode like ''301%'' or CategoryCode like ''302%'' or CategoryCode like ''303%'' or CategoryCode like ''304%'')  then ''烟酒''
when (CategoryCode like ''305%'' or CategoryCode like ''306%'' or CategoryCode like ''307%'' or CategoryCode like ''308%'' or CategoryCode like ''309%'')  then ''水饮''
when (CategoryCode like ''3107%'' or CategoryCode like ''3108%'' or CategoryCode like ''3113%'' or CategoryCode like ''3127%'' or CategoryCode like ''3137%'' or CategoryCode like ''3147%'')  then ''散装休闲''
when (left(CategoryCode,4) between ''3100'' and ''3106'' or left(CategoryCode,4) between ''3110'' and ''3112''  or left(CategoryCode,4) between ''3120'' and ''3126'' or left(CategoryCode,4) between ''3130'' and ''3136'' or left(CategoryCode,4) between ''3140'' and ''3146'' or CategoryCode like ''3190%'')  then ''量贩休闲''
when (CategoryCode like ''32%'')  then ''冲饮''
when (left(CategoryCode,3) between ''340'' and ''342''  )  then ''冷藏''
when (left(CategoryCode,3) between ''343'' and ''346''  or CategoryCode like ''349%'' )  then ''冷冻''
when (CategoryCode like ''40%'')  then ''厨用家居''
when (CategoryCode like ''41%'' or CategoryCode like ''42%'' or CategoryCode like ''43%'')  then ''家居清洁''
when (CategoryCode like ''44%'' or CategoryCode like ''45%'' or CategoryCode like ''48%'' or CategoryCode like ''49%'')  then ''文体家电''
when (CategoryCode like ''46%'' or CategoryCode like ''470%'' or CategoryCode like ''471%'' or CategoryCode like ''472%'' or CategoryCode like ''474%'' or CategoryCode like ''479%'')  then ''床用纺织''
when (CategoryCode like ''473%'' or CategoryCode like ''475%'' or CategoryCode like ''476%'' or CategoryCode like ''477%'' or CategoryCode like ''478%'')  then ''家用纺织''
when (CategoryCode like ''508%'' or CategoryCode like ''5061%'' or CategoryCode like ''5062%'' or CategoryCode like ''5063%'' or CategoryCode like ''5064%'' or CategoryCode like ''5065%'' or CategoryCode like ''51%'')  then ''何国荣''
when (CategoryCode like ''502%'' or CategoryCode like ''504%'' or CategoryCode like ''5060%'' or CategoryCode like ''50301%'' )  then ''钟亚丽''
when (CategoryCode like ''500%'' or CategoryCode like ''501%'' or CategoryCode like ''505%'' or CategoryCode like ''507%'' or CategoryCode like ''509%'' or CategoryCode like ''5031%'' or CategoryCode like ''50300%'' or CategoryCode like ''50302%'' or CategoryCode like ''52%'')  then ''胡露露''
else CategoryCode end CategoryName
,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(SaleIncome)SaleIncome,SUM(SaleCost)SaleCost    from 
[000]A .tbGoods a , ('+@SQL+')  b 
where a.GoodsCode =b.GoodsCode  and (NodeCode like ''1%'' or NodeCode like ''2%'') 
and CategoryCode not like ''0%'' and CategoryCode not like ''6%'' 
and CategoryCode not like ''33%'' 
and not exists (select * from 
(select a.NodeCode ,b.GoodsPropertyCode,b.GoodsCode from 
[000]A  .TBDEPARTMENT  a,
[000]A .TBGOODSPROPINCLUSIONS b
where b.GoodsPropertyCode=''2002'' and a.NodeCode in (''1042'',''1061'',''1058'')
and State =''0'' and OpenDate <=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) z
where  a.goodscode=z.goodscode and b.NodeCode=z.NodeCode)
group by NodeCode ,case
when (CategoryCode like ''10%'')  then ''10''
when (CategoryCode like ''11%'')  then ''11''
when (CategoryCode like ''12%'')  then ''12''
when (CategoryCode like ''13%'')  then ''13''
when (CategoryCode like ''14%'')  then ''14''
when (CategoryCode like ''20%'' or CategoryCode like ''280%'' or CategoryCode like ''29000%'' or CategoryCode like ''29001%'' or CategoryCode like ''29002%'' or CategoryCode like ''29005%'' or CategoryCode like ''2901%'' or CategoryCode like ''2902%'')  then ''15''
when (CategoryCode like ''21%'' or CategoryCode like ''281%'' or CategoryCode like ''29004%'' )  then ''16''
when (CategoryCode like ''22%'' or CategoryCode like ''282%'' or CategoryCode like ''29003%'' or CategoryCode like ''29006%'')  then ''17''
when (CategoryCode like ''23%'')  then ''18''
when (CategoryCode like ''300%'' or CategoryCode like ''301%'' or CategoryCode like ''302%'' or CategoryCode like ''303%'' or CategoryCode like ''304%'')  then ''19''
when (CategoryCode like ''305%'' or CategoryCode like ''306%'' or CategoryCode like ''307%'' or CategoryCode like ''308%'' or CategoryCode like ''309%'')  then ''20''
when (CategoryCode like ''3107%'' or CategoryCode like ''3108%'' or CategoryCode like ''3113%'' or CategoryCode like ''3127%'' or CategoryCode like ''3137%'' or CategoryCode like ''3147%'')  then ''21''
when (left(CategoryCode,4) between ''3100'' and ''3106'' or left(CategoryCode,4) between ''3110'' and ''3112''  or left(CategoryCode,4) between ''3120'' and ''3126'' or left(CategoryCode,4) between ''3130'' and ''3136'' or left(CategoryCode,4) between ''3140'' and ''3146'' or CategoryCode like ''3190%'')  then ''22''
when (CategoryCode like ''32%'')  then ''23''
when (left(CategoryCode,3) between ''340'' and ''342''  )  then ''24''
when (left(CategoryCode,3) between ''343'' and ''346''  or CategoryCode like ''349%'' )  then ''25''
when (CategoryCode like ''40%'')  then ''29''
when (CategoryCode like ''41%'' or CategoryCode like ''42%'' or CategoryCode like ''43%'')  then ''30''
when (CategoryCode like ''44%'' or CategoryCode like ''45%'' or CategoryCode like ''48%'' or CategoryCode like ''49%'')  then ''31''
when (CategoryCode like ''46%'' or CategoryCode like ''470%'' or CategoryCode like ''471%'' or CategoryCode like ''472%'' or CategoryCode like ''474%'' or CategoryCode like ''479%'')  then ''32''
when (CategoryCode like ''473%'' or CategoryCode like ''475%'' or CategoryCode like ''476%'' or CategoryCode like ''477%'' or CategoryCode like ''478%'')  then ''33''
when (CategoryCode like ''508%'' or CategoryCode like ''5061%'' or CategoryCode like ''5062%'' or CategoryCode like ''5063%'' or CategoryCode like ''5064%'' or CategoryCode like ''5065%'' or CategoryCode like ''51%'')  then ''34''
when (CategoryCode like ''502%'' or CategoryCode like ''504%'' or CategoryCode like ''5060%'' or CategoryCode like ''50301%'' )  then ''35''
when (CategoryCode like ''500%'' or CategoryCode like ''501%'' or CategoryCode like ''505%'' or CategoryCode like ''507%'' or CategoryCode like ''509%'' or CategoryCode like ''5031%'' or CategoryCode like ''50300%'' or CategoryCode like ''50302%'' or CategoryCode like ''52%'')  then ''36''
else CategoryCode end,case
when (CategoryCode like ''10%'')  then ''生食''
when (CategoryCode like ''11%'')  then ''水产''
when (CategoryCode like ''12%'')  then ''蔬菜''
when (CategoryCode like ''13%'')  then ''水果''
when (CategoryCode like ''14%'')  then ''干货''
when (CategoryCode like ''20%'' or CategoryCode like ''280%'' or CategoryCode like ''29000%'' or CategoryCode like ''29001%'' or CategoryCode like ''29002%'' or CategoryCode like ''29005%'' or CategoryCode like ''2901%'' or CategoryCode like ''2902%'')  then ''熟食''
when (CategoryCode like ''21%'' or CategoryCode like ''281%'' or CategoryCode like ''29004%'' )  then ''面点''
when (CategoryCode like ''22%'' or CategoryCode like ''282%'' or CategoryCode like ''29003%'' or CategoryCode like ''29006%'')  then ''面包''
when (CategoryCode like ''23%'')  then ''餐饮''
when (CategoryCode like ''300%'' or CategoryCode like ''301%'' or CategoryCode like ''302%'' or CategoryCode like ''303%'' or CategoryCode like ''304%'')  then ''烟酒''
when (CategoryCode like ''305%'' or CategoryCode like ''306%'' or CategoryCode like ''307%'' or CategoryCode like ''308%'' or CategoryCode like ''309%'')  then ''水饮''
when (CategoryCode like ''3107%'' or CategoryCode like ''3108%'' or CategoryCode like ''3113%'' or CategoryCode like ''3127%'' or CategoryCode like ''3137%'' or CategoryCode like ''3147%'')  then ''散装休闲''
when (left(CategoryCode,4) between ''3100'' and ''3106'' or left(CategoryCode,4) between ''3110'' and ''3112''  or left(CategoryCode,4) between ''3120'' and ''3126'' or left(CategoryCode,4) between ''3130'' and ''3136'' or left(CategoryCode,4) between ''3140'' and ''3146'' or CategoryCode like ''3190%'')  then ''量贩休闲''
when (CategoryCode like ''32%'')  then ''冲饮''
when (left(CategoryCode,3) between ''340'' and ''342''  )  then ''冷藏''
when (left(CategoryCode,3) between ''343'' and ''346''  or CategoryCode like ''349%'' )  then ''冷冻''
when (CategoryCode like ''40%'')  then ''厨用家居''
when (CategoryCode like ''41%'' or CategoryCode like ''42%'' or CategoryCode like ''43%'')  then ''家居清洁''
when (CategoryCode like ''44%'' or CategoryCode like ''45%'' or CategoryCode like ''48%'' or CategoryCode like ''49%'')  then ''文体家电''
when (CategoryCode like ''46%'' or CategoryCode like ''470%'' or CategoryCode like ''471%'' or CategoryCode like ''472%'' or CategoryCode like ''474%'' or CategoryCode like ''479%'')  then ''床用纺织''
when (CategoryCode like ''473%'' or CategoryCode like ''475%'' or CategoryCode like ''476%'' or CategoryCode like ''477%'' or CategoryCode like ''478%'')  then ''家用纺织''
when (CategoryCode like ''508%'' or CategoryCode like ''5061%'' or CategoryCode like ''5062%'' or CategoryCode like ''5063%'' or CategoryCode like ''5064%'' or CategoryCode like ''5065%'' or CategoryCode like ''51%'')  then ''何国荣''
when (CategoryCode like ''502%'' or CategoryCode like ''504%'' or CategoryCode like ''5060%'' or CategoryCode like ''50301%'' )  then ''钟亚丽''
when (CategoryCode like ''500%'' or CategoryCode like ''501%'' or CategoryCode like ''505%'' or CategoryCode like ''507%'' or CategoryCode like ''509%'' or CategoryCode like ''5031%'' or CategoryCode like ''50300%'' or CategoryCode like ''50302%'' or CategoryCode like ''52%'')  then ''胡露露''
else CategoryCode end

union all 

select NodeCode ,''201'' CategoryCode ,''烟酒专区'' CategoryName
,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(SaleIncome)SaleIncome,SUM(SaleCost)SaleCost   from 
[000]A .tbGoods a , ('+@SQL+')  b 
where a.GoodsCode =b.GoodsCode  
and (NodeCode like ''1%'' or NodeCode like ''2%'')  
and exists (select * from 
(select a.NodeCode ,b.GoodsPropertyCode,b.GoodsCode from 
[000]A  .TBDEPARTMENT  a,
[000]A .TBGOODSPROPINCLUSIONS b
where b.GoodsPropertyCode=''2002'' and a.NodeCode in (''1042'',''1061'',''1058'')
and State =''0'' and OpenDate <=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) z
where  a.goodscode=z.goodscode and b.NodeCode=z.NodeCode)
group by NodeCode 

union all 

select NodeCode ,case
when (CategoryCode like ''330%'' or CategoryCode like ''331%'' or CategoryCode like ''332%'')  then ''26''
when (CategoryCode like ''333%'' or CategoryCode like ''334%'' or CategoryCode like ''335%'' or CategoryCode like ''336%'')  then ''27''

else CategoryCode end CategoryCode ,
case
when (CategoryCode like ''330%'' or CategoryCode like ''331%'' or CategoryCode like ''332%'')  then ''调味品''
when (CategoryCode like ''333%'' or CategoryCode like ''334%'' or CategoryCode like ''335%'' or CategoryCode like ''336%'')  then ''包装粮食''

else CategoryCode end CategoryName
,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(SaleIncome)SaleIncome,SUM(SaleCost)SaleCost   from 
[000]A .tbGoods a , ('+@SQL+')  b 
where a.GoodsCode =b.GoodsCode  and (NodeCode like ''1%'' or NodeCode like ''2%'')  and nodecode not in  (1003,1004,1011,1012,1013,1017,1018,1019,1023,1024,1032,1034,1035,2001,2002,2004,2005,2006,2007,2008,2009) and CategoryCode like ''33%''
group by NodeCode ,
case
when (CategoryCode like ''330%'' or CategoryCode like ''331%'' or CategoryCode like ''332%'')  then ''26''
when (CategoryCode like ''333%'' or CategoryCode like ''334%'' or CategoryCode like ''335%'' or CategoryCode like ''336%'')  then ''27''

else CategoryCode end
,case
when (CategoryCode like ''330%'' or CategoryCode like ''331%'' or CategoryCode like ''332%'')  then ''调味品''
when (CategoryCode like ''333%'' or CategoryCode like ''334%'' or CategoryCode like ''335%'' or CategoryCode like ''336%'')  then ''包装粮食''

else CategoryCode end

union all 

select NodeCode , ''28'' as CategoryCode ,
 ''粮油(惠民生鲜店)'' as CategoryName
,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(SaleIncome)SaleIncome,SUM(SaleCost)SaleCost  from 
[000]A .tbGoods a , ('+@SQL+')  b 
where a.GoodsCode =b.GoodsCode  and (NodeCode like ''1%'' or NodeCode like ''2%'')  and nodecode in  (1003,1004,1011,1012,1013,1017,1018,1019,1023,1024,1032,1034,1035,2001,2002,2004,2005,2006,2007,2008,2009) and CategoryCode like ''33%''
group by NodeCode 

union all 

select NodeCode ,case
when (CategoryCode like ''280%'' or CategoryCode like ''287%'')  then ''170''
when (CategoryCode like ''281%'' or CategoryCode like ''288%'')  then ''171''
when (CategoryCode like ''282%'' or CategoryCode like ''289%'')  then ''172''

else CategoryCode end CategoryCode ,
case
when (CategoryCode like ''280%'' or CategoryCode like ''287%'')  then ''中央厨房熟食''
when (CategoryCode like ''281%'' or CategoryCode like ''288%'')  then ''中央厨房面点''
when (CategoryCode like ''282%'' or CategoryCode like ''289%'')  then ''中央厨房面包''

else CategoryCode end CategoryName
,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(SaleIncome)SaleIncome,SUM(SaleCost)SaleCost   from 
[000]A .tbGoods a , ('+@SQL+')  b 
where a.GoodsCode =b.GoodsCode  and (NodeCode like ''7777'') and  left(CategoryCode,3) in (280,287,281,282,288,289)
group by NodeCode ,
case
when (CategoryCode like ''280%'' or CategoryCode like ''287%'')  then ''170''
when (CategoryCode like ''281%'' or CategoryCode like ''288%'')  then ''171''
when (CategoryCode like ''282%'' or CategoryCode like ''289%'')  then ''172''

else CategoryCode end,
case
when (CategoryCode like ''280%'' or CategoryCode like ''287%'')  then ''中央厨房熟食''
when (CategoryCode like ''281%'' or CategoryCode like ''288%'')  then ''中央厨房面点''
when (CategoryCode like ''282%'' or CategoryCode like ''289%'')  then ''中央厨房面包''

else CategoryCode end
order by 2,1


'exec(@sql1)



select left(a.ParentCategoryCode,1)ParentCategoryCode,left(a.CategoryCode,2)CategoryCode,a.CategoryName,
sum(isnull(b.TaxSalesindex,0)) TaxSalesindex,sum(isnull(b.TaxGrossprofitindex,0) )TaxGrossprofitindex,
sum(isnull(b.Salesindex,0))Salesindex,sum(isnull(b.Grossprofitindex,0))Grossprofitindex  from 
(select a.CategoryItemCode,b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,left('${jsrq}',6)+'01')+1, 0)))OpenDate,
a.ParentCategoryCode,a.CategoryCode ,a.CategoryName,bm from 
dbo.TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,b.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0002'

where a.CategoryItemCode='0002' and a.CategoryLevel='0' and a.CategoryCode like '1%')a
where left(b.NodeCode,1) in (1,2)  
--and datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,left('${jsrq}',6)+'01')+1, 0)))>=20
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }
)a
left join 
(select a.DeptCode,a.CategoryCode,sum(a.Salesindex) TaxSalesindex,sum(a.Grossprofitindex )TaxGrossprofitindex,
sum(b.Salesindex)Salesindex,sum(b.Grossprofitindex)Grossprofitindex from 
    [含税分课预算表]A a 
    left join 
    [无税分课预算表]A  b on a.BudgetYM =b.BudgetYM and a.CategoryCode=b.CategoryCode and a.DeptCode=b.DeptCode and a.CategoryItemCode=b.CategoryItemCode
    where a.BudgetYM between left('${qsrq}',6) and left('${jsrq}',6) 
    and a.CategoryItemCode='0000' and b.CategoryItemCode='0000'
    group by a.DeptCode,a.CategoryCode)b on a.NodeCode =b.DeptCode  and a.bm=b.CategoryCode
    group by left(a.ParentCategoryCode,1),left(a.CategoryCode,2) ,a.CategoryName

order by 1,2



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  OccurDate between  '+@qsrq+' and '+@dqrq+' 
and 1=1 ${if(len(bm) == 0,   "",   "and NodeCode in (''" + replace(bm,",","'',''")+"'')") }  ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,9,99)= '_GoodsdayPSSM' and SUBSTRING(name,3,6) between  @qsny and @jsny
 SET @SQL1=STUFF(@SQL1,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  EnterAccountDate between '+@qsrq+' and '+@dqrq+' 
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in (''" + replace(bm,",","'',''")+"'')") }  ' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,9,99)='_SaleBill' and SUBSTRING(name,3,6) between  @qsny and @jsny
SET @SQL2=STUFF(@SQL2,1,11,'')

SET @SQL3=''
SELECT @SQL3=@SQL3+' UNION ALL SELECT * FROM [000]A.'+[name]A+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND  SUBSTRING(name,9,99)='_SALERENTDETAIL' and SUBSTRING(name,3,6) between  @qsny and @jsny
SET @SQL3=STUFF(@SQL3,1,11,'')

SET @SQL='
select left(CategoryCode,1)CategoryCode1,left(CategoryCode,2)CategoryCode,
SUM(SaleIncome)SaleIncome,SUM(SaleMoney)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit
from
(select b.NodeCode ,left(CategoryCode,2)CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 [000]A .tbGoods a ,
('+@SQL1+') b 
 where a.GoodsCode =b.GoodsCode   
  and left(CategoryCode,1) in (''1'')  and left(b.NodeCode,1)  in (1,2)

 group by b.NodeCode ,left(CategoryCode,2) 
  
 
 union all 
 
 select zb.DeptCode,left(CategoryCode,2) CategoryCode2,
  sum(SaleEarning)SaleIncome,sum(SaleEarning+SaleTax)SaleMoney ,sum(SaleEarning) SaleGrossProfit,sum(SaleEarning+SaleTax) TaxSaleGrossProfit
 from  ('+@SQL2+')  zb  ,('+@SQL3+') cb ,[000]A .tbGoods c 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
 and cb.GoodsCode=c.GoodsCode 
 and LEFT(c.CategoryCode,1) in (''1'') and left(zb.DeptCode,1)  in (1,2)
 group by zb.DeptCode,left(CategoryCode,2))a
  group by left(CategoryCode,1),left(CategoryCode,2)


 
 

  order by 1,3,2
 


'exec(@sql)


select a.ParentCategoryCode,a.CategoryCode ,a.CategoryName,
sum(isnull(b.ProcePayMoney,0))ProcePayMoney,sum(isnull(b.TaxRateDiff,0) )TaxRateDiff,
sum(isnull(b.LossProfitMoney,0))LossProfitMoney,sum(isnull(b.Newstoreortaxrate,0))Newstoreortaxrate,
sum(isnull(b.Maoriadjustmentoftheprocessing,0))Maoriadjustmentoftheprocessing,sum(isnull(b.Incomeadjustment,0))Incomeadjustment from 

(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,b.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0002'
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode='0000'
where a.CategoryItemCode='0000' and a.CategoryLevel='0' and a.CategoryCode like '1%')a

left join 
TB门店绩效表毛利扣减表 b on b. CategoryItemCode='0002' and a.bm=b.CategoryCode and HappenYM between left('${qsrq}',6) and left('${jsrq}',6) 
    group by a.ParentCategoryCode,a.CategoryCode ,a.CategoryName
order by 1,2



