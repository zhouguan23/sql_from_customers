select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 
and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}


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

select a.AreaCode,b.CategoryCode,b.CategoryCode4,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,''${tqdqrq}''),112))>=20  then 0 else 1 end  WhetherNew,
case when  datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,''${dqrq}'') between 12 and 23 then 1 when datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,''${dqrq}'') >=24 then 2 else 0 end  year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,case 
when (CategoryCode like ''282%'' or CategoryCode like ''289%'' or CategoryCode like ''22%'')  then ''22''
when (CategoryCode like ''280%'' OR CategoryCode like ''287%'' OR CategoryCode like ''29%'' OR CategoryCode like ''20%'')  then ''20''
when (CategoryCode like ''281%'' OR CategoryCode like ''288%'' OR CategoryCode like ''21%'')  then ''21''

end CategoryCode,left(CategoryCode,4)CategoryCode4,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode like ''2%''

GROUP BY nodecode,case 
when (CategoryCode like ''282%'' or CategoryCode like ''289%'' or CategoryCode like ''22%'')  then ''22''
when (CategoryCode like ''280%'' OR CategoryCode like ''287%'' OR CategoryCode like ''29%'' OR CategoryCode like ''20%'')  then ''20''
when (CategoryCode like ''281%'' OR CategoryCode like ''288%'' OR CategoryCode like ''21%'')  then ''21''
end,left(CategoryCode,4))b on a.nodecode= b.nodecode

WHERE 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in (''" + replace(fl,",","'',''")+"'')") }



ORDER BY 1,2,3


'exec(@sql)


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

select a.AreaCode,b.CategoryCode,b.CategoryCode4,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,''${tqdqrq}''),112))>=20  then 0 else 1 end  WhetherNew,
case when  datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,''${dqrq}'') between 12 and 23 then 1 when datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,''${dqrq}'') >=24 then 2 else 0 end  year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,case when (CategoryCode like ''282%'' or CategoryCode like ''289%'' or CategoryCode like ''22%'')  then ''22''
when (CategoryCode like ''280%'' OR CategoryCode like ''287%'' OR CategoryCode like ''29%'' OR CategoryCode like ''20%'')  then ''20''
when (CategoryCode like ''281%'' OR CategoryCode like ''288%'' OR CategoryCode like ''21%'')  then ''21''
end CategoryCode,left(CategoryCode,4)CategoryCode4,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode like ''2%''

GROUP BY nodecode,case 
when (CategoryCode like ''282%'' or CategoryCode like ''289%'' or CategoryCode like ''22%'')  then ''22''
when (CategoryCode like ''280%'' OR CategoryCode like ''287%'' OR CategoryCode like ''29%'' OR CategoryCode like ''20%'')  then ''20''
when (CategoryCode like ''281%'' OR CategoryCode like ''288%'' OR CategoryCode like ''21%'')  then ''21''
end,left(CategoryCode,4))b on a.nodecode= b.nodecode

WHERE 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in (''" + replace(fl,",","'',''")+"'')") }



ORDER BY 1,2,3


'exec(@sql)


select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047,6601,6602)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}


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

select a.AreaCode,a.nodecode ,b.CategoryCode,b.CategoryCode4,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,''${tqdqrq}''),112))>=20  then 0 else 1 end  WhetherNew,
case when  datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,''${dqrq}'') 
between 12 and 23 then 1 when datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,''${dqrq}'') >=24 then 2 else 0 end  year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,case 
when (CategoryCode like ''282%'' or CategoryCode like ''289%'' or CategoryCode like ''22%'')  then ''22''
when (CategoryCode like ''280%'' OR CategoryCode like ''287%'' OR CategoryCode like ''29%'' OR CategoryCode like ''20%'')  then ''20''
when (CategoryCode like ''281%'' OR CategoryCode like ''288%'' OR CategoryCode like ''21%'')  then ''21''
end CategoryCode,
left(CategoryCode,4)CategoryCode4,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode like ''2%''

GROUP BY nodecode,case 
when (CategoryCode like ''282%'' or CategoryCode like ''289%'' or CategoryCode like ''22%'')  then ''22''
when (CategoryCode like ''280%'' OR CategoryCode like ''287%'' OR CategoryCode like ''29%'' OR CategoryCode like ''20%'')  then ''20''
when (CategoryCode like ''281%'' OR CategoryCode like ''288%'' OR CategoryCode like ''21%'')  then ''21''
end,left(CategoryCode,4))b on a.nodecode= b.nodecode
WHERE 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in (''" + replace(fl,",","'',''")+"'')") }

ORDER BY 3,4,1,2


'exec(@sql)



select 
c.CategoryCode,
isnull(c.StartCost,0)+ISNULL(d.StockCost,0)TaxCost
 from 

(select nodecode,
case when (CategoryCode like '1%' or CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end
CategoryCode,sum(StartCost+StartTax)StartCost  from 
tb${YM}_GoodsMONpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE '6666' OR nodecode LIKE '8888' ) 


GROUP BY nodecode,
case when (CategoryCode like '1%' or CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end) c 
left join 
(select nodecode,
case when (CategoryCode like '1%' or CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end CategoryCode,
sum(PURCHCOST+PurchTax --进货
+ REDEPLOYINCOST+RedeployinTax --拨入
+ PROFITCOST+ProfitTax --升溢
+ COUNTPROFITCOST+CountProfitTax --盘升
- TaxSaleCost  --销售
- REDEPLOYOUTCOST-RedeployoutTax --拨出
- LOSSCOST-LossTax --损耗
- COUNTLOSSCOST-CountLossTax --盘耗
-ToGiftCost-ToGiftTax --转赠品
)StockCost  from 
tb${YM}_Goodsdaypssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and (nodecode LIKE '6666' OR nodecode LIKE '8888' ) 

and occurdate <= convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) 
GROUP BY nodecode,
case when (CategoryCode like '1%' or CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end) d on   c.CategoryCode=d.CategoryCode




order by 1





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
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=1

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') 
and OpenDate<=''${dqrq}'' 
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
)a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and CategoryCode like ''2%''

GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsCatCode like ''2%''
GROUP BY DeptCode)c on a.nodecode= c.nodecode 



ORDER BY 1,2


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
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=1

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'')
and OpenDate<=''${dqrq}'' 
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
)a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and CategoryCode like ''2%'' 

GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
and GoodsCatCode like ''2%'' 
GROUP BY DeptCode)c on a.nodecode= c.nodecode 



ORDER BY 1,2


'exec(@sql)



