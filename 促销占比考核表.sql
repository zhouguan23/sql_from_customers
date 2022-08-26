
select a.AreaCode,a.FormatCode,a.DeptCode,a.OpenDate,a.WhetherNew,a.CategoryCode,
isnull(a.SaleMoney,0)SaleMoney,isnull(a.TaxSaleGrossProfit,0)TaxSaleGrossProfit,
ISNULL(b.SaleMoney,0)cxSaleMoney
 from 
(select a.AreaCode,a.FormatCode,a.NodeCode DeptCode,a.OpenDate,
case 
when a.NodeCode in (1041,1043,1046,1009,1042) then '0'
when datediff(day,a.OpenDate,convert(varchar(8),dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,convert(varchar(8),dateadd(dd,0,DATEADD(DAY,-1,CAST((left('${dqrq}',4)+'-'+right('${dqrq}',2)+'-'+'01')AS DATETIME))),112))+1, 0)),112))+1<=20 then '1' 
when datediff(month,a.OpenDate,convert(varchar(8),dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,convert(varchar(8),dateadd(dd,0,DATEADD(DAY,-1,CAST((left('${dqrq}',4)+'-'+right('${dqrq}',2)+'-'+'01')AS DATETIME))),112))+1, 0)),112)) between 1 and 6 then '2'
else '3' end WhetherNew,
case when c.GoodsBrand ='010001' then '7' when left(c.CategoryCode,1) in (3,4,5) then '3'  else  left(c.CategoryCode,1) end CategoryCode,
isnull(sum(b.SaleIncome +SaleTax ),0)SaleMoney,isnull(sum(b.TaxSaleGrossProfit),0)TaxSaleGrossProfit

from 
TB部门信息表 a
left join 
tb${dqrq}_GoodsDayPSSM b on a.NodeCode =b.NodeCode 
left join 
TB商品档案 c on b.GoodsCode =c.GoodsCode 
where (a.NodeCode  LIKE '1%' OR a.NodeCode  LIKE '2%') AND a.WhetherNew !='-1'
and a.OpenDate<convert(varchar(8),dateadd(dd,0,DATEADD(DAY,-1,CAST((left('${dqrq}',4)+'-'+right('${dqrq}',2)+'-'+'01')AS DATETIME))),112)
and left(c.CategoryCode,1) not in (0,6)
group by a.AreaCode,a.FormatCode,a.NodeCode,a.OpenDate,
case 
when a.NodeCode in (1041,1043,1046,1009,1042) then '0'
when datediff(day,a.OpenDate,convert(varchar(8),dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,convert(varchar(8),dateadd(dd,0,DATEADD(DAY,-1,CAST((left('${dqrq}',4)+'-'+right('${dqrq}',2)+'-'+'01')AS DATETIME))),112))+1, 0)),112))+1<=20 then '1' 
when datediff(month,a.OpenDate,convert(varchar(8),dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,convert(varchar(8),dateadd(dd,0,DATEADD(DAY,-1,CAST((left('${dqrq}',4)+'-'+right('${dqrq}',2)+'-'+'01')AS DATETIME))),112))+1, 0)),112)) between 1 and 6 then '2'
else '3' end ,
case when c.GoodsBrand ='010001' then '7'  when left(c.CategoryCode,1) in (3,4,5) then '3' else  left(c.CategoryCode,1) end)a
left join 
(select deptcode,case  when b.GoodsBrand ='010001' then '7' when left(b.CategoryCode,1) in (3,4,5) then '3' else  left(b.CategoryCode,1) end CategoryCode,
 sum(SaleIncome+saletax) SaleMoney from 
tb${dqrq}_门店促销数据 a 
left join 
TB商品档案  b on a.GoodsCode =b.GoodsCode
group by  deptcode,case when b.GoodsBrand ='010001' then '7' when left(b.CategoryCode,1) in (3,4,5) then '3'  else  left(b.CategoryCode,1) end)b on a.deptcode=b.deptcode and a.CategoryCode=b.CategoryCode
order by 1,2,3,6

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

select a.nodecode ,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit from 
(select  AreaCode,NodeCode
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and OpenDate<=''${dqrq}'' )a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and b.CategoryCode not like ''23%''
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
GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode)c on a.nodecode= c.nodecode

where  1=1 ${if(len(dq) == 0,   "",   "and a.AreaCode in (''" + replace(dq,",","'',''")+"'')") }

ORDER BY 1


'exec(@sql)

select b.CategoryCode,b.CategoryName from 

[000]A.TBDEPTCATEGORY b 
where CategoryItemCode=0013 and CategoryCode not in (3,9)
and b.CategoryCode='${bm}'

