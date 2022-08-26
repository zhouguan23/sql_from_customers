
 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),@SQL4 VARCHAR(MAX),@SQL5 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8),@je VARCHAR(MAX)
set @je=${je}
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where AccDate between '+@qsrq+' and '+@dqrq+'
and 1=1 ${if(len(bm) == 0,   "",   "and DepartmentCode in (''" + replace(bm,",","'',''")+"'')") } 
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_CARDTRADINGDETAILS' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')

SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where BuildDate between '+@qsrq+' and '+@dqrq+'
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SaleBill' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')

SET @SQL3=''
SELECT @SQL3=@SQL3+' UNION ALL SELECT DeptCode,BillNumber,GoodsCode,SaleAmount,SaleEarning,SaleTax,ScoreMulti,IntegralValue FROM '+[name]A+' 
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SALEBILLDETAIL' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL3=STUFF(@SQL3,1,11,'')

SET @SQL5=''
SELECT @SQL5=@SQL5+' UNION ALL SELECT DeptCode,BillNumber,GoodsCode,SaleAmount,SaleEarning,SaleTax,''1''ScoreMulti,''0''IntegralValue FROM '+[name]A+' 
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SALERENTDETAIL' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL5=STUFF(@SQL5,1,11,'')

SET @SQL4=''
SELECT @SQL4=@SQL4+' UNION ALL SELECT * FROM '+[name]A+' where Occurdate between '+@qsrq+' and '+@dqrq+'
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPSSM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL4=STUFF(@SQL4,1,11,'')

SET @SQL='
select a.DepartmentCode,a.AccDate,a.TradingTime,a.CardCode,BirthDay
,a.BillNumber,a.PosNo,a.IntegralValue,a.SaleMoney zd_SaleMoney,b.SellCashierCode,b.SellCashierName,c.GoodsCode,d.GoodsName,d.GoodsType
,c.ScoreMulti
,c.SaleAmount
,(c.SaleEarning+c.SaleTax)SaleMoney
,(c.SaleAmount)*case when (e.TaxSaleCost)=0 or (e.SaleAmount)=0 then 0 else (e.TaxSaleCost)/(e.SaleAmount) end TaxSaleCost
,(c.SaleEarning+c.SaleTax)-(c.SaleAmount)*case when (e.TaxSaleCost)=0 or (e.SaleAmount)=0 then 0 else (e.TaxSaleCost)/(e.SaleAmount) end TaxSaleGrossProfit
  from 
('+@sql1+') a 
left join 
('+@sql2+') B on a.DepartmentCode=b.DeptCode and a.BillNumber=b.BillNumber
left join 
('+@sql3+' union all '+@sql5+') c on b.DeptCode=c.DeptCode and b.BillNumber=c.BillNumber
left join 
TB商品档案 d on c.GoodsCode=d.GoodsCode
LEFT JOIN 
('+@sql4+') e on c.DeptCode=e.NodeCode and c.GoodsCode=e.GoodsCode and b.BuildDate=e.OccurDate

where a.SaleMoney>='+@je+' and a.IntegralValue>0 and b.SaleTag=0 and b.IsOutRule=0 


order by a.DepartmentCode,a.AccDate,a.BillNumber


'exec(@sql)







select CardCode,a.MemberCode,CardInNum,AccountsCode,typeID,LevelID,MemberName,MemberName,MobilePhone,CardState from 
[9001]A.TBCARD a 
left join 
[9001]A.TBMEMBER b on a.MemberCode=b.MemberCode
where a.typeID not in (1) and CardState =2 and a.MemberCode !=''

select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}


select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

