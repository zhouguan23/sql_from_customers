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
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where EnterAccountDate between '+@qsrq+' and '+@dqrq+' and CategoryItemCode =''0000'' and CategoryLevel=0

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,99) LIKE '门店客单客流' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')


SET @SQL='

select a.AreaCode,A.FormatCode,a.nodecode ,isnull(b.SaleMoney,0)SaleMoney ,

row_number() OVER (PARTITION BY a.AreaCode  ORDER BY 	isnull(b.SaleMoney,0) desc	)Area_PM,
row_number() OVER (PARTITION BY a.FormatCode  ORDER BY 	isnull(b.SaleMoney,0) desc	)Format_PM,
row_number() OVER (ORDER BY 	isnull(b.SaleMoney,0) desc	)PM,

isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,
row_number() OVER (PARTITION BY a.AreaCode  ORDER BY 	isnull(b.TaxSaleGrossProfit,0) desc	)SaleGrossProfit_Area_PM,
row_number() OVER (PARTITION BY a.FormatCode  ORDER BY 	isnull(b.TaxSaleGrossProfit,0) desc	)SaleGrossProfit_Format_PM,
row_number() OVER (ORDER BY 	isnull(b.TaxSaleGrossProfit,0) desc	)_PM,

isnull(c.SaleCount,0)SaleCount,
row_number() OVER (PARTITION BY a.AreaCode  ORDER BY 	isnull(c.SaleCount,0) desc	)SaleCount_Area_PM,
row_number() OVER (PARTITION BY a.FormatCode  ORDER BY 	isnull(c.SaleCount,0) desc	)SaleCount_Format_PM,
row_number() OVER (ORDER BY 	isnull(c.SaleCount,0) desc	)SaleCount_PM,

isnull(D.EndCost  ,0)EndCost ,
  row_number() OVER (PARTITION BY a.AreaCode  ORDER BY 	isnull(D.EndCost  ,0) desc	)EndCost_Area_PM,
row_number() OVER (PARTITION BY a.FormatCode  ORDER BY 	isnull(D.EndCost  ,0) desc	)EndCost_Format_PM,
row_number() OVER (ORDER BY isnull(D.EndCost  ,0) desc	)EndCost_PM,

row_number() OVER (PARTITION BY a.AreaCode  ORDER BY isnull(b.TaxSaleGrossProfit,0)/isnull(b.SaleMoney,0) desc	)mlv_Area_PM,
row_number() OVER (PARTITION BY a.FormatCode  ORDER BY 	isnull(b.TaxSaleGrossProfit,0)/isnull(b.SaleMoney,0) desc	)mlv_Format_PM,
row_number() OVER (ORDER BY isnull(b.TaxSaleGrossProfit,0)/isnull(b.SaleMoney,0) desc	)mlv_PM,

row_number() OVER (PARTITION BY a.AreaCode  ORDER BY isnull(b.SaleMoney,0)/isnull(c.SaleCount,0)  desc	)kd_Area_PM,
row_number() OVER (PARTITION BY a.FormatCode  ORDER BY 	isnull(b.SaleMoney,0)/isnull(c.SaleCount,0)  desc	)kd_Format_PM,
row_number() OVER (ORDER BY 	isnull(b.SaleMoney,0)/isnull(c.SaleCount,0) desc	)kd_PM
from 
(select  AreaCode,FormatCode,NodeCode
from TB部门信息表 b
where  (NodeCode  LIKE ''1%'' OR NodeCode  LIKE ''2%'') AND nodecode<>''1047''
and OpenDate<='+@dqrq+' )a


left join 
(select nodecode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 ('+@SQL1+')  a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
GROUP BY nodecode)b on a.nodecode= b.nodecode
left join 
(select DeptCode nodecode ,sum(SaleCount)SaleCount  from 
 ('+@SQL2+')  a
WHERE   (DeptCode LIKE ''1%'' OR DeptCode LIKE ''2%'' ) 
GROUP BY DeptCode)c on a.nodecode= c.nodecode
left join 
(select nodecode , SUM(a.StartCost+a.StartTax
+ a.PURCHCOST+a.PurchTax --进货
+ a.REDEPLOYINCOST+a.RedeployinTax --拨入
+ a.PROFITCOST+a.ProfitTax --升溢
+ a.COUNTPROFITCOST+a.CountProfitTax --盘升
- a.TaxSaleCost  --销售
- a.REDEPLOYOUTCOST-a.RedeployoutTax --拨出
- a.LOSSCOST-a.LossTax --损耗
- a.COUNTLOSSCOST-a.CountLossTax --盘耗
- a.ToGiftCost-a.ToGiftTax --转赠品
)EndCost  
from 
 tb'+@jsny+'_GoodsMonPssm  a ,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE ''1%'' OR nodecode LIKE ''2%'' ) 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)

GROUP BY	Nodecode)d on a.nodecode= d.nodecode



order by 2,6


'exec(@sql)



