
select AreaCode,
FormatCode,
NodeCode DeptCode,
WhetherNew ,
case when WhetherNew='1'  then '新店' when year='1'  then '开业1年以上' when year>'1'  then '开业2年以上' else '0' end year    ,
ParentCategoryCode, 
CategoryCode  ,
case when NodeCode like '1%' or NodeCode like '2%' then '超市门店' when NodeCode like '9%' then '百货门店' when NodeCode like '5%' then '购物中心' end NodeTape,
isnull(c.CarryState,0)CarryState,
isnull(b.Salesindex,0) Salesindex,
isnull(b.Grossprofitindex,0) Grossprofitindex
 from 
(

select AreaCode,NodeCode,FormatCode,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112))>=20  then 0 else 1 end  WhetherNew,
case when  datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') between 12 and 23 then 1 when datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') >=24 then 2 else 0 end  year
 from 
TB部门信息表
where State!=2  and (nodecode like '1%' or NodeCode like '2%'  or NodeCode like '9%'  or NodeCode like '5%')  and NodeCode not in ('1070','1017','9999')
and OpenDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) 


 )a
left join 
(select DeptCode,
case 
when CategoryCode like '1%' then '1'
when CategoryCode like '2%' then '2'
when CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%' then '3' 
when CategoryCode like '6%' then '6' 
when CategoryCode like '8%' then '8' 
 else CategoryCode  end ParentCategoryCode,
case 
when CategoryCode like '30' or CategoryCode like '32' or CategoryCode like '33' then '30' 
when CategoryCode like '31' or CategoryCode like '34' then '31' 
when CategoryCode like '4%' then '4' 
when CategoryCode like '5%' then '5'
when CategoryCode in (610,611,620,621) then '61' 
when CategoryCode in (613,622) then '62' 
when CategoryCode like '64%' then '64' 
 else CategoryCode  end CategoryCode
,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表 

where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%' OR DeptCode   LIKE '5%')  and CategoryItemCode in ('0000','5001')  and CategoryCode not like '7%' and CategoryCode not like '39'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode,case 
when CategoryCode like '1%' then '1'
when CategoryCode like '2%' then '2'
when CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%' then '3' 
when CategoryCode like '6%' then '6' 
when CategoryCode like '8%' then '8' 
 else CategoryCode  end ,
case 
when CategoryCode like '30' or CategoryCode like '32' or CategoryCode like '33' then '30' 
when CategoryCode like '31' or CategoryCode like '34' then '31' 
when CategoryCode like '4%' then '4' 
when CategoryCode like '5%' then '5'
when CategoryCode in (610,611,620,621) then '61' 
when CategoryCode in (613,622) then '62' 
when CategoryCode like '64%' then '64' 
 else CategoryCode  end
)b on a.NodeCode=b.DeptCode
left join 
TBDAYCARRYLOG c on a.NodeCode=c.deptcode and c.CarryDate= convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
order by 2,1,5,4,3,6,7




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

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,b.CategoryCode,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'' OR NodeCode  LIKE ''9%'' OR NodeCode  LIKE ''5%'') AND nodecode<>''1047''
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,
case 
when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
when left(CategoryCode,3) in (''282'',''289'') then ''22'' 
when CategoryCode like ''30%'' or CategoryCode like ''32%'' or CategoryCode like ''33%'' or CategoryCode like ''35%'' then ''30'' 
when CategoryCode like ''31%'' or CategoryCode like ''34%'' then ''31'' 
when CategoryCode like ''4%'' then ''4'' 
when CategoryCode like ''5%'' then ''5''
when left(CategoryCode,3) in (610,611,620,621) then ''61'' 
when left(CategoryCode,3) in (613,622) then ''62'' 
when CategoryCode like ''64%'' then ''64'' 
 else left(CategoryCode,2)  end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' OR nodecode LIKE ''9%'' ) 
and left(CategoryCode,1) between 1 and 6 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,case 
when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
when left(CategoryCode,3) in (''282'',''289'') then ''22'' 
when CategoryCode like ''30%'' or CategoryCode like ''32%'' or CategoryCode like ''33%'' or CategoryCode like ''35%'' then ''30'' 
when CategoryCode like ''31%'' or CategoryCode like ''34%'' then ''31'' 
when CategoryCode like ''4%'' then ''4'' 
when CategoryCode like ''5%'' then ''5''
when left(CategoryCode,3) in (610,611,620,621) then ''61'' 
when left(CategoryCode,3) in (613,622) then ''62'' 
when CategoryCode like ''64%'' then ''64'' 
 else left(CategoryCode,2)  end
 union all 

select nodecode,CategoryCode,sum(SaleMoney)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit
from
(   select nodecode ,case 
   when CounterCode in (304) then ''800''  
   when CounterCode in (155,140,159,107,212,113,192) then ''801''  
   when CounterCode in (228,165,169,2006,2009,2015,226,102) then ''802''  
   when CounterCode in (203,210,201,2002,297,191,10401,109) then ''803''  
   when CounterCode in (302,325,347) then ''804''  
   when CounterCode in (313,311) then ''805''  
   else CounterCode end  CategoryCode
,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 ('+@SQL1+')  a
 where  nodecode LIKE ''5001'' and  goodscode not like ''900000003'' and CounterCode  not in (''5001'')
 


GROUP BY nodecode,case 
   when CounterCode in (304) then ''800''  
   when CounterCode in (155,140,159,107,212,113,192) then ''801''  
   when CounterCode in (228,165,169,2006,2009,2015,226,102) then ''802''  
   when CounterCode in (203,210,201,2002,297,191,10401,109) then ''803''  
   when CounterCode in (302,325,347) then ''804''  
   when CounterCode in (313,311) then ''805''  
   else CounterCode end

union all 

select DeptCode nodecode,CategoryCode,sum(Salesindex)SaleMoney,sum(Grossprofitindex) TaxSaleGrossProfit
from 购物中心手工进帐日合计 
where defday between '+@qsrq+' and '+@dqrq+' and deptcode=''5001''
group by DeptCode,CategoryCode)a
group by nodecode,CategoryCode
 
 
 )b on a.nodecode= b.nodecode




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


SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,b.CategoryCode,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'' OR NodeCode  LIKE ''9%'') AND nodecode<>''1047''
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,
case 
when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
when left(CategoryCode,3) in (''282'',''289'') then ''22'' 
when CategoryCode like ''30%'' or CategoryCode like ''32%'' or CategoryCode like ''33%''  or CategoryCode like ''35%'' then ''30'' 
when CategoryCode like ''31%'' or CategoryCode like ''34%'' then ''31'' 
when CategoryCode like ''4%'' then ''4'' 
when CategoryCode like ''5%'' then ''5''
when left(CategoryCode,3) in (610,611,620,621) then ''61'' 
when left(CategoryCode,3) in (613,622) then ''62'' 
when CategoryCode like ''64%'' then ''64'' 
 else left(CategoryCode,2)  end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%''  OR nodecode LIKE ''9%'') 
and left(CategoryCode,1) between 1 and 6 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,case 
when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then ''20'' 
when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
when left(CategoryCode,3) in (''282'',''289'') then ''22'' 
when CategoryCode like ''30%'' or CategoryCode like ''32%'' or CategoryCode like ''33%''  or CategoryCode like ''35%'' then ''30'' 
when CategoryCode like ''31%'' or CategoryCode like ''34%'' then ''31'' 
when CategoryCode like ''4%'' then ''4'' 
when CategoryCode like ''5%'' then ''5''
when left(CategoryCode,3) in (610,611,620,621) then ''61'' 
when left(CategoryCode,3) in (613,622) then ''62'' 
when CategoryCode like ''64%'' then ''64'' 
 else left(CategoryCode,2)  end
  union all 

select nodecode,CategoryCode,sum(SaleMoney)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit
from
(   select nodecode ,case 
   when CounterCode in (304) then ''800''  
   when CounterCode in (155,140,159,107,212,113,192) then ''801''  
   when CounterCode in (228,165,169,2006,2009,2015,226,102) then ''802''  
   when CounterCode in (203,210,201,2002,297,191,10401,109) then ''803''  
   when CounterCode in (302,325,347) then ''804''  
   when CounterCode in (313,311) then ''805''  
   else CounterCode end  CategoryCode
,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 ('+@SQL1+')  a
 where  nodecode LIKE ''5001'' and  goodscode not like ''900000003'' and CounterCode  not in (''5001'')
 


GROUP BY nodecode,case 
   when CounterCode in (304) then ''800''  
   when CounterCode in (155,140,159,107,212,113,192) then ''801''  
   when CounterCode in (228,165,169,2006,2009,2015,226,102) then ''802''  
   when CounterCode in (203,210,201,2002,297,191,10401,109) then ''803''  
   when CounterCode in (302,325,347) then ''804''  
   when CounterCode in (313,311) then ''805''  
   else CounterCode end

union all 

select DeptCode nodecode,CategoryCode,sum(Salesindex)SaleMoney,sum(Grossprofitindex) TaxSaleGrossProfit
from 购物中心手工进帐日合计 
where defday between '+@qsrq+' and '+@dqrq+' and deptcode=''5001''
group by DeptCode,CategoryCode)a
group by nodecode,CategoryCode
 
 )b on a.nodecode= b.nodecode




ORDER BY 1,2


'exec(@sql)

select b.CategoryCode,b.CategoryName from 

[000]A.TBDEPTCATEGORY b 
where CategoryItemCode=0013 and CategoryCode not in (3,9)
and b.CategoryCode='${bm}'

select * from 
TBDAYCARRYLOG a
where a.CarryDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

select * from 
	dbo.日期对照表
	where OccurDate ='${dqrq}'

select * from 
HLCWDW.DBO.TB分类对照表 
where CategoryItemCode='0002' and CategoryLevel between '0' and '1'


select AreaCode,
FormatCode,
NodeCode DeptCode,
WhetherNew ,
case when WhetherNew='1'  then '新店' when year='1'  then '开业1年以上' when year>'1'  then '开业2年以上' else '0' end year    ,
ParentCategoryCode, 
CategoryCode  ,
case when NodeCode like '1%' or NodeCode like '2%' then '超市门店' when NodeCode like '9%' then '百货门店' when NodeCode like '5%' then '购物中心' end NodeTape,
isnull(c.CarryState,0)CarryState,
isnull(b.Salesindex,0) Salesindex,
isnull(b.Grossprofitindex,0) Grossprofitindex
 from 
(

select AreaCode,NodeCode,FormatCode,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112))>=20  then 0 else 1 end  WhetherNew,
case when  datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') between 12 and 23 then 1 
when datediff(MONTH,case when  day(OpenDate)<=10 then OpenDate else convert(varchar(8),dateadd(mm,1,OpenDate),112)end ,'${dqrq}') >=24 then 2 else 0 end  year
 from 
TB部门信息表
where State!=2  and (nodecode like '1%' or NodeCode like '2%'  )  and NodeCode not in ('1070','1017','9999')
and OpenDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) 


 )a
left join 
(select DeptCode,'7' ParentCategoryCode,CategoryCode
,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表 

where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%')  
and CategoryItemCode in ('0001') and CategoryCode in ('10','30','40','46','50')
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode,CategoryCode
)b on a.NodeCode=b.DeptCode
left join 
TBDAYCARRYLOG c on a.NodeCode=c.deptcode and c.CarryDate= convert(varchar(8),dateadd(dd,0,'20200226'),112)
order by 2,1,5,4,3,6,7





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

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,b.CategoryCode,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'' ) AND nodecode not in (''1047'',''1070'')
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,
case 
when left(CategoryCode,1) in (''1'',''2'') then ''10'' 
when left(CategoryCode,1) in (''3'') then ''30'' 
when left(CategoryCode,2) in (''40'',''41'',''42'',''43'',''44'',''45'',''48'',''49'') then ''40'' 
when left(CategoryCode,2) in (''46'',''46'') then ''46'' 
when left(CategoryCode,1) in (''5'') then ''50''   end CategoryCode,
sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' OR nodecode LIKE ''9%'' ) 
and b.GoodsBrand  =''010001''
and left(CategoryCode,1) between 1 and 6 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,case 
when left(CategoryCode,1) in (''1'',''2'') then ''10'' 
when left(CategoryCode,1) in (''3'') then ''30'' 
when left(CategoryCode,2) in (''40'',''41'',''42'',''43'',''44'',''45'',''48'',''49'') then ''40'' 
when left(CategoryCode,2) in (''46'',''46'') then ''46'' 
when left(CategoryCode,1) in (''5'') then ''50''   end

 
 
 )b on a.nodecode= b.nodecode




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


SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,b.CategoryCode,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'' ) AND nodecode not in (''1047'',''1070'')
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,
case 
when left(CategoryCode,1) in (''1'',''2'') then ''10'' 
when left(CategoryCode,1) in (''3'') then ''30'' 
when left(CategoryCode,2) in (''40'',''41'',''42'',''43'',''44'',''45'',''48'',''49'') then ''40'' 
when left(CategoryCode,2) in (''46'',''46'') then ''46'' 
when left(CategoryCode,1) in (''5'') then ''50''   end CategoryCode,
sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' OR nodecode LIKE ''9%'' ) 
and b.GoodsBrand  =''010001''
and left(CategoryCode,1) between 1 and 6 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,case 
when left(CategoryCode,1) in (''1'',''2'') then ''10'' 
when left(CategoryCode,1) in (''3'') then ''30'' 
when left(CategoryCode,2) in (''40'',''41'',''42'',''43'',''44'',''45'',''48'',''49'') then ''40'' 
when left(CategoryCode,2) in (''46'',''46'') then ''46'' 
when left(CategoryCode,1) in (''5'') then ''50''   end

 
 
 )b on a.nodecode= b.nodecode




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


SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,b.CategoryCode,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'' ) AND nodecode not in (''1047'',''1070'')
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,left(CategoryCode,2) CategoryCode,
sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' OR nodecode LIKE ''9%'' ) 
and left(CategoryCode,2) =''35''
and exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,left(CategoryCode,2)

 
 
 )b on a.nodecode= b.nodecode




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


SET @SQL='

select a.AreaCode,a.nodecode ,a.WhetherNew ,a.year,b.CategoryCode,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,''${tqdqrq}'')>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,''${dqrq}'')year
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'' ) AND nodecode not in (''1047'',''1070'')
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,left(CategoryCode,2) CategoryCode,
sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' OR nodecode LIKE ''9%'' ) 
and left(CategoryCode,2) =''35''
and exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode,left(CategoryCode,2)

 
 
 )b on a.nodecode= b.nodecode




ORDER BY 1,2


'exec(@sql)

