
select AreaCode,NodeCode DeptCode,WhetherNew ,case when WhetherNew='1'  then '新店' when year='1'  then '开业1年以上' when year>'1'  then '开业2年以上' else '0' end year    
 from 
(
select AreaCode,NodeCode,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(yy,-1,'${dqrq}'),112))>=20  then 0 else 1 end  WhetherNew,
case when  datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') between 12 and 23 then 1 when datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') >=24 then 2 else 0 end  year
 from 
TB部门信息表
where State!=2  and (nodecode like '1%' or NodeCode like '2%') and OpenDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) and NodeCode not like '1070'and NodeCode not like '1017'
 )a

left join 
TBDAYCARRYLOG c on a.NodeCode=c.deptcode and c.CarryDate= convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
order by 1,4,3,2

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+' and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where AccDate between '+@qsrq+' and '+@dqrq+'  and  (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店促销数据' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,ColonyCode,a.nodecode ,a.CategoryCode,CarryState,
isnull(b.SaleMoney,0)SaleMoney,
isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit ,
isnull(c.SaleMoney,0)cx_SaleMoney,
isnull(c.TaxSaleGrossProfit,0)cx_TaxSaleGrossProfit 

from 
(select distinct  AreaCode,NodeCode ,a.ColonyCode,c.CarryState,case when d.CategoryCode in (''3'',''4'',''5'',''6'') then ''3'' when d.CategoryCode =''0'' then ''7'' else d.CategoryCode  end CategoryCode   from 
TB部门信息表 a 
left join 
TBDAYCARRYLOG c on a.NodeCode=c.deptcode and c.CarryDate= '+@dqrq+' 
,
tb商品分类表 d 
where  State!=2  and (nodecode like ''1%'' or NodeCode like ''2%'') and OpenDate<=convert(varchar(8),dateadd(dd,0,''20200108''),112) 
and NodeCode not like ''1070''and NodeCode not like ''1017''
and d.CategoryLevel=''1'' and d.CategoryItemCode=''0000'' )a

left join 
(select nodecode ,case when left(b.CategoryCode,1) in (''3'',''4'',''5'') and b.GoodsBrand!=''010001'' then ''3''
when left(b.CategoryCode,1) in (''1'') and b.GoodsBrand!=''010001'' then ''1''
when left(b.CategoryCode,1) in (''2'') and b.GoodsBrand!=''010001'' then ''2''
when  b.GoodsBrand=''010001'' then ''7'' else left(b.CategoryCode,1) end CategoryCode,
sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and left(b.CategoryCode,1) between ''1'' and ''5''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,case when left(b.CategoryCode,1) in (''3'',''4'',''5'') and b.GoodsBrand!=''010001'' then ''3''
when left(b.CategoryCode,1) in (''1'') and b.GoodsBrand!=''010001'' then ''1''
when left(b.CategoryCode,1) in (''2'') and b.GoodsBrand!=''010001'' then ''2''
when  b.GoodsBrand=''010001'' then ''7'' else left(b.CategoryCode,1) end )b on a.nodecode= b.nodecode and a.CategoryCode=b.CategoryCode
left join 
(select DeptCode nodecode ,case when left(b.CategoryCode,1) in (''3'',''4'',''5'') and b.GoodsBrand!=''010001'' then ''3''
when left(b.CategoryCode,1) in (''1'') and b.GoodsBrand!=''010001'' then ''1''
when left(b.CategoryCode,1) in (''2'') and b.GoodsBrand!=''010001'' then ''2''
when  b.GoodsBrand=''010001'' then ''7'' else left(b.CategoryCode,1) end CategoryCode,
sum(SaleIncome+saletax)SaleMoney,sum(a.GrossMargin)TaxSaleGrossProfit  from 
 ('+@SQL2+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and left(b.CategoryCode,1) between ''1'' and ''5''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.DeptCode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY DeptCode,case when left(b.CategoryCode,1) in (''3'',''4'',''5'') and b.GoodsBrand!=''010001'' then ''3''
when left(b.CategoryCode,1) in (''1'') and b.GoodsBrand!=''010001'' then ''1''
when left(b.CategoryCode,1) in (''2'') and b.GoodsBrand!=''010001'' then ''2''
when  b.GoodsBrand=''010001'' then ''7'' else left(b.CategoryCode,1) end )c on a.nodecode= c.nodecode and a.CategoryCode=c.CategoryCode




ORDER BY 1,2,3,4


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

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(c.SaleCount,0)SaleCount from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%''
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode)c on a.nodecode= c.nodecode



ORDER BY 1


'exec(@sql)

select b.CategoryCode,b.CategoryName from 

[000]A.TBDEPTCATEGORY b 
where CategoryItemCode=0013 and CategoryCode not in (3,9)
and b.CategoryCode='${bm}'

select * from 
TBDAYCARRYLOG a
where a.CarryDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

