
 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),@SQL5 VARCHAR(MAX),@SQL4 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq

SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where BuildDate between '+@qsrq+' and '+@dqrq+'
and SellCashierCode in (''9200'',''9400'',''8000'',''9000'')
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
select b.DeptCode,b.SellCashierCode,b.SellCashierName
,sum(c.SaleEarning)SaleEarning
,sum(c.SaleEarning+c.SaleTax)SaleMoney
,sum(c.SaleAmount)*case when sum(e.SaleCost)=0 or sum(e.SaleAmount)=0 then 0 else sum(e.SaleCost)/sum(e.SaleAmount) end SaleCost
,sum(c.SaleEarning)-sum(c.SaleAmount)*case when sum(e.SaleCost)=0 or sum(e.SaleAmount)=0 then 0 else sum(e.SaleCost)/sum(e.SaleAmount) end SaleGrossProfit
  from 

('+@sql2+') B
left join 
('+@sql3+' union all '+@sql5+') c on b.DeptCode=c.DeptCode and b.BillNumber=c.BillNumber
left join 
TB商品档案 d on c.GoodsCode=d.GoodsCode
LEFT JOIN 
('+@sql4+') e on c.DeptCode=e.NodeCode and c.GoodsCode=e.GoodsCode and b.BuildDate=e.OccurDate

where  b.SaleTag=0 and b.IsOutRule=0 


group  by b.DeptCode,b.SellCashierCode,b.SellCashierName

order by b.DeptCode,b.SellCashierCode,b.SellCashierName
'exec(@sql)







select a.DeptCode as 部门编码,left(c.CategoryCode,2) as 商品分类,count(left(c.CategoryCode,2)) as 客流 ,SUM(b.SaleEarning+b.SaleTax) as 销售金额,
SUM((b.SaleEarning+b.SaleTax)-b.LastPrice) as 参考毛利 from 

[1025]A.TB201811_SALEBILL a, --销售单
[1025]A.TB201811_SALEBILLDETAIL b, --销售单明细
[1025]A .tbGoods c --商品档案表 

where a.BillNumber=b.BillNumber and a.DeptCode =b.DeptCode and b.GoodsCode =c.GoodsCode  and a.SellCashierCode='8000' and a.SaleTag=0 and a.IsOutRule=0

group by a.DeptCode,left(c.CategoryCode,2)

order by left(c.CategoryCode,2) asc


select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}


