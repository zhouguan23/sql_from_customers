

select AreaCode,A.NodeCode DeptCode,WhetherNew ,
case when WhetherNew='1'  then '新店' when year='1'  then '开业1年以上' when year>'1'  then '开业2年以上' else '0' end year    ,
b.CategoryCode,
isnull(b.Salesindex,0) Salesindex,
isnull(b.Grossprofitindex,0) Grossprofitindex
 from 
(select AreaCode,NodeCode,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112))>=20  then 0 else 1 end  WhetherNew,
case when  datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') between 12 and 23 then 1 when datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') >=24 then 2 else 0 end  year
 from 
TB部门信息表
where State!=2  and (nodecode like '1%' or NodeCode like '2%') and OpenDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }
 )a
left join 
(select DeptCode,
case when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end
CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%')  and CategoryItemCode='0001' and (CategoryCode like '1%' or CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%')
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)


group by DeptCode,case 
when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end)b on a.NodeCode=b.DeptCode





order by 1,4,3,2,5





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
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0001'' and CategoryLevel=2

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,b.CategoryCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and OpenDate<=''${dqrq}''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
)a


left join 
(select nodecode ,case when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''

GROUP BY nodecode,case 
when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,case when (GoodsCatCode like ''1%'')  then ''10''
when (GoodsCatCode like ''3%'')  then ''30''
when (GoodsCatCode like ''40%'' or GoodsCatCode like ''41%'' or GoodsCatCode like ''42%''or GoodsCatCode like ''43%'' )  then ''40''
when (GoodsCatCode like ''46%'' or GoodsCatCode like ''47%'' )  then ''46''
when (GoodsCatCode like ''5%'' )  then ''50''
end CategoryCode,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode,case 
when (GoodsCatCode like ''1%'')  then ''10''
when (GoodsCatCode like ''3%'')  then ''30''
when (GoodsCatCode like ''40%'' or GoodsCatCode like ''41%'' or GoodsCatCode like ''42%''or GoodsCatCode like ''43%'' )  then ''40''
when (GoodsCatCode like ''46%'' or GoodsCatCode like ''47%'' )  then ''46''
when (GoodsCatCode like ''5%'' )  then ''50''
end)c on a.nodecode= c.nodecode and b.CategoryCode=c.CategoryCode 


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
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0001'' and CategoryLevel=2

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,b.CategoryCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,case when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''

GROUP BY nodecode,case 
when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,case 
when (GoodsCatCode like ''1%'')  then ''10''
when (GoodsCatCode like ''3%'')  then ''30''
when (GoodsCatCode like ''40%'' or GoodsCatCode like ''41%'' or GoodsCatCode like ''42%''or GoodsCatCode like ''43%'' )  then ''40''
when (GoodsCatCode like ''46%'' or GoodsCatCode like ''47%'' )  then ''46''
when (GoodsCatCode like ''5%'' )  then ''50''
end CategoryCode,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode,case 
when (GoodsCatCode like ''1%'')  then ''10''
when (GoodsCatCode like ''3%'')  then ''30''
when (GoodsCatCode like ''40%'' or GoodsCatCode like ''41%'' or GoodsCatCode like ''42%''or GoodsCatCode like ''43%'' )  then ''40''
when (GoodsCatCode like ''46%'' or GoodsCatCode like ''47%'' )  then ''46''
when (GoodsCatCode like ''5%'' )  then ''50''
end)c on a.nodecode= c.nodecode and b.CategoryCode=c.CategoryCode



ORDER BY 1,2


'exec(@sql)



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

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and (b.CategoryCode like ''1%'' or b.CategoryCode like ''2%'' or b.CategoryCode like ''3%'' or b.CategoryCode like ''4%''or b.CategoryCode like ''5%'' )
GROUP BY nodecode)b on a.nodecode= b.nodecode


ORDER BY 1


'exec(@sql)



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')



SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and (b.CategoryCode  like ''1%'' or b.CategoryCode  like ''2%'' or b.CategoryCode  like ''3%'' or b.CategoryCode  like ''4%'' or b.CategoryCode  like ''5%'')
GROUP BY nodecode)b on a.nodecode= b.nodecode




ORDER BY 1


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
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0001'' and CategoryLevel=0

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
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and OpenDate<=''${dqrq}'' 
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
)a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''

GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
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
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0001'' and CategoryLevel=0

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
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''

GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode)c on a.nodecode= c.nodecode 



ORDER BY 1,2


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
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0001'' and CategoryLevel=4

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,b.CategoryCode,b.CategoryCode4,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,case when (GoodsCatCode like ''1%'')  then ''10''
when (GoodsCatCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end CategoryCode,left(CategoryCode,4)CategoryCode4,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''

GROUP BY nodecode,case when (GoodsCatCode like ''1%'')  then ''10''
when (GoodsCatCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end,left(CategoryCode,4))b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,case 
when (GoodsCatCode like ''1%'')  then ''10''
when (GoodsCatCode like ''3%'')  then ''30''
when (GoodsCatCode like ''40%'' or GoodsCatCode like ''41%'' or GoodsCatCode like ''42%''or GoodsCatCode like ''43%'' )  then ''40''
when (GoodsCatCode like ''46%'' or GoodsCatCode like ''47%'' )  then ''46''
when (GoodsCatCode like ''5%'' )  then ''50''
end CategoryCode,left(GoodsCatCode,4)CategoryCode4,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode,case 
when (GoodsCatCode like ''1%'')  then ''10''
when (GoodsCatCode like ''3%'')  then ''30''
when (GoodsCatCode like ''40%'' or GoodsCatCode like ''41%'' or GoodsCatCode like ''42%''or GoodsCatCode like ''43%'' )  then ''40''
when (GoodsCatCode like ''46%'' or GoodsCatCode like ''47%'' )  then ''46''
when (GoodsCatCode like ''5%'' )  then ''50''
end,left(GoodsCatCode,4))c on a.nodecode= c.nodecode and b.CategoryCode=c.CategoryCode and b.CategoryCode4=c.CategoryCode4



ORDER BY 1,2,3


'exec(@sql)



 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')



SET @SQL='

select a.AreaCode,a.nodecode,b.CategoryCode,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,case when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and (b.CategoryCode  like ''3%'' or b.CategoryCode  like ''4%'' or b.CategoryCode  like ''5%'')
and b.CategoryCode not like ''44%'' and b.CategoryCode not like ''45%'' and b.CategoryCode not like ''48%'' and b.CategoryCode not like ''49%''
GROUP BY nodecode,case 
when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end)b on a.nodecode= b.nodecode




ORDER BY 1


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
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0001'' and CategoryLevel=4

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,b.CategoryCode,b.CategoryCode4,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,case 
when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end CategoryCode,left(CategoryCode,4)CategoryCode4,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and GoodsBrand=''010001''

GROUP BY nodecode,case 
when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end,left(CategoryCode,4))b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,case 
when (GoodsCatCode like ''1%'')  then ''10''
when (GoodsCatCode like ''3%'')  then ''30''
when (GoodsCatCode like ''40%'' or GoodsCatCode like ''41%'' or GoodsCatCode like ''42%''or GoodsCatCode like ''43%'' )  then ''40''
when (GoodsCatCode like ''46%'' or GoodsCatCode like ''47%'' )  then ''46''
when (GoodsCatCode like ''5%'' )  then ''50''
end CategoryCode,left(GoodsCatCode,4)CategoryCode4,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode,case 
when (GoodsCatCode like ''1%'')  then ''10''
when (GoodsCatCode like ''3%'')  then ''30''
when (GoodsCatCode like ''40%'' or GoodsCatCode like ''41%'' or GoodsCatCode like ''42%''or GoodsCatCode like ''43%'' )  then ''40''
when (GoodsCatCode like ''46%'' or GoodsCatCode like ''47%'' )  then ''46''
when (GoodsCatCode like ''5%'' )  then ''50''
end,left(GoodsCatCode,4))c on a.nodecode= c.nodecode and b.CategoryCode=c.CategoryCode and b.CategoryCode4=c.CategoryCode4



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

select a.AreaCode,a.nodecode ,b.CategoryCode,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,case when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and (b.CategoryCode like ''1%'' or  b.CategoryCode like ''3%'' or b.CategoryCode like ''4%''or b.CategoryCode like ''5%'' ) and b.CategoryCode not like ''44%'' and b.CategoryCode not like ''45%'' and b.CategoryCode not like ''48%'' and b.CategoryCode not like ''49%''

GROUP BY nodecode,case when (CategoryCode like ''1%'')  then ''10''
when (CategoryCode like ''3%'')  then ''30''
when (CategoryCode like ''40%'' or CategoryCode like ''41%'' or CategoryCode like ''42%''or CategoryCode like ''43%'' )  then ''40''
when (CategoryCode like ''46%'' or CategoryCode like ''47%'' )  then ''46''
when (CategoryCode like ''5%'' )  then ''50''
end)b on a.nodecode= b.nodecode


ORDER BY 1


'exec(@sql)





select 
a.CategoryCode,
isnull(b.StartCost,0)+ISNULL(c.StockCost,0)TaxCost
 from 
(select distinct case when (CategoryCode like '1%' or CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end CategoryCode  from 
TB商品分类表 b 
where	 b.CategoryItemCode='0000' and b.CategoryLevel='2' and b.ParentCategoryCode between 1 and 5 and ParentCategoryCode not like '2%' and CategoryCode not in (44,45,48,49))a
left join 
(select 
case when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end
CategoryCode,sum(StartCost+StartTax)StartCost  from 
tb${YM}_GoodsMONpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE '6666' OR nodecode LIKE '8888' ) 
and GoodsBrand='010001'
GROUP BY 
case when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end) b on a.CategoryCode=b.CategoryCode
left join 
(select case when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
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
and GoodsBrand='010001'
and occurdate <= convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) 
GROUP BY case 
when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end) c on   a.CategoryCode=c.CategoryCode




order by 1



select 
a.CategoryCode,
isnull(b.StartCost,0)+ISNULL(c.StockCost,0)TaxCost
 from 
(select distinct case 
when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end CategoryCode  from 
TB商品分类表 b 
where	 b.CategoryItemCode='0000' and b.CategoryLevel='2' and b.ParentCategoryCode between 1 and 5 and ParentCategoryCode not like '2%' and CategoryCode not in (44,45,48,49))a
left join 
(select 
case when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end
CategoryCode,sum(StartCost+StartTax)StartCost  from 
tb${YM}_GoodsMONpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and GoodsBrand='010001'
GROUP BY 
case 
when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end) b on a.CategoryCode=b.CategoryCode
left join 
(select case 
when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
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
WHERE a.goodscode=b.goodscode  and (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and GoodsBrand='010001'
and occurdate <= convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) 
GROUP BY case 
when (CategoryCode like '1%')  then '10'
when (CategoryCode like '3%')  then '30'
when (CategoryCode like '40%' or CategoryCode like '41%' or CategoryCode like '42%'or CategoryCode like '43%' )  then '40'
when (CategoryCode like '46%' or CategoryCode like '47%' )  then '46'
when (CategoryCode like '5%' )  then '50'
end) c on   a.CategoryCode=c.CategoryCode




order by 1

