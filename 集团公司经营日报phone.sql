select AreaCode,NodeCode ,a.ParentCategoryCode,LEFT(a.CategoryCode,1)CategoryCode,a.defday,
sum(round(case when isnull(b.Salesindex,0)*isnull(d.xszb,0)<>0 then isnull(b.Salesindex,0)*isnull(d.xszb,0) else isnull(c.Salesindex,0)*isnull(d.xszb,0) end ,2)) Salesindex,
sum(round(case when isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0)<>0 then  isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0) else isnull(c.Grossprofitindex,0)*isnull(d.mlzb,0) end,2)) Grossprofitindex
 from 
(select  AreaCode,NodeCode ,c.ParentCategoryCode,c.CategoryCode,c.bm,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0000'
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode='0000'
where a.CategoryItemCode='0000' and a.CategoryLevel='0' and a.CategoryCode not like '9%')  c
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and left(c.CategoryCode,1) between 1 and 5
and NodeCode  not in ('1047') AND NodeCode not in ('1017')AND NodeCode not in ('1070')
and OpenDate <= convert(varchar(8),dateadd(dd,0,GETDATE()),112)
)a
left join 
每日预算表 b on a.defday=b.defday and a.NodeCode=b.DeptCode
left join 
(select DeptCode,sum(Salesindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Salesindex,sum(Grossprofitindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)c on a.NodeCode=c.DeptCode 
left join 
(select a.DeptCode,a.CategoryCode,case when a.Salesindex=0 then 0 else a.Salesindex/b.Salesindex end xszb,
case when a.Grossprofitindex=0 then 0 else  a.Grossprofitindex/b.Grossprofitindex end mlzb  from 
(select DeptCode,CategoryCode,Salesindex,Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112))a,
(select DeptCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)b
where a.DeptCode=b.DeptCode)d on a.NodeCode=d.DeptCode and a.bm=d.CategoryCode 
where a.defday=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
group by AreaCode,NodeCode ,a.ParentCategoryCode,LEFT(a.CategoryCode,1),a.defday
order by AreaCode,NodeCode ,a.ParentCategoryCode,LEFT(a.CategoryCode,1),a.defday

select AreaCode,a.NodeCode ,a.defday,B.CategoryCode,
SUM(isnull(b.SaleMoney,0))销售金额,SUM(isnull(b.TaxSaleGrossProfit,0))销售毛利
 from 
(select  AreaCode,NodeCode ,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%') AND NodeCode not in ('1047')AND NodeCode not in ('1017')AND NodeCode not in ('1070')

)a
left join 
(select nodecode,occurdate,LEFT(b.CategoryCode,1)CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${YM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode AND b.CategoryCode not like '35%' AND b.CategoryCode not like '23%'  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and b.CategoryCode not like '23%' AND LEFT(b.CategoryCode,1) BETWEEN 1 AND 5
 and occurdate = convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) 
GROUP BY nodecode,occurdate,LEFT(b.CategoryCode,1)) b on  a.NodeCode =b.nodecode    and a.defday=b.occurdate

where  a.defday=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
group by AreaCode,a.NodeCode ,a.defday,B.CategoryCode

select AreaCode,a.NodeCode ,a.defday,
SUM(isnull(b.SaleMoney,0))销售金额,SUM(isnull(b.TaxSaleGrossProfit,0))销售毛利
 from 
(select  AreaCode,NodeCode ,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')

)a
left join 
(select nodecode,occurdate,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${YM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and b.GoodsBrand ='010001'
and b.CategoryCode not like '23%' and occurdate = convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) 
GROUP BY nodecode,occurdate) b on  a.NodeCode =b.nodecode    and a.defday=b.occurdate

where  a.defday=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) and a.NodeCode not in ('1047')
group by AreaCode,a.NodeCode ,a.defday

select a.AreaCode,a.NodeCode ,a.defday,isnull(d.CarryState,0)CarryState,
(round(case when isnull(b.Salesindex,0)<>0 then isnull(b.Salesindex,0) else isnull(c.Salesindex,0) end ,2)) Salesindex,
(round(case when isnull(b.Grossprofitindex,0)<>0 then  isnull(b.Grossprofitindex,0) else isnull(c.Grossprofitindex,0) end,2)) Grossprofitindex,
(isnull(round(e.SaleMoney,2),0))SaleMoney,
(isnull(round(e.TaxSaleGrossProfit,2),0))TaxSaleGrossProfit,
isnull(f.TaxStartCost,0)+isnull(g.TaxStartCost,0)TaxEndCost,
(isnull(round(i.SaleCount,2),0))SaleCount,
(isnull(round(h.SaleMoney,2),0))TQ_SaleMoney,
isnull(round(h.TaxSaleGrossProfit,2),0)TQ_TaxSaleGrossProfit
 from 
(select  AreaCode,NodeCode ,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and NodeCode not in ('1047','1070','1017') and convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
and OpenDate <= convert(varchar(8),dateadd(dd,0,GETDATE()),112)
)a
left join 
每日预算表 b on a.NodeCode=b.DeptCode and b.defday=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
left join 
(select DeptCode,sum(Salesindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Salesindex,sum(Grossprofitindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)c on a.NodeCode=c.DeptCode 
left join 
TBDAYCARRYLOG d on a.NodeCode=d.deptcode and d.CarryDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
left join 
(select nodecode,occurdate,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${YM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode AND b.CategoryCode not like '35%' AND b.CategoryCode not like '23%'  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and OccurDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
GROUP BY nodecode,occurdate) e on  a.NodeCode =e.nodecode   
left join 
(select nodecode,sum(StartCost+StartTax)TaxStartCost  from 
tb${YM}_GoodsMonPssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode AND b.CategoryCode not like '35%' AND b.CategoryCode not like '23%'  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
GROUP BY nodecode) f on  a.NodeCode =f.nodecode    

left join 
(select nodecode,sum((PurchCost+PurchTax)+(CompensateCost+CompensateTax)+ (RedeployinCost+RedeployinTax)+(ProfitCost+ProfitTax)+(CountProfitCost+CountProfitTax)  - TaxSaleCost  - (RedeployoutCost+RedeployoutTax) - (LossCost+LossTax)  -(CountLossCost+CountLossTax)  -(ToGiftCost+ToGiftTax))TaxStartCost  from 
tb${YM}_GoodsDayPssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode AND b.CategoryCode not like '35%' AND b.CategoryCode not like '23%'  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and OccurDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
GROUP BY nodecode) g on  a.NodeCode =g.nodecode    
left join 
(select nodecode,occurdate,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${TQYM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode AND b.CategoryCode not like '35%' AND b.CategoryCode not like '23%'  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and OccurDate=convert(varchar(8),dateadd(dd,0,'${tqrq}'),112)
GROUP BY nodecode,occurdate) h on  a.NodeCode =h.nodecode   
left join 
(select DeptCode,sum(SaleCount)SaleCount  from 
TB${YM}_门店客单客流 a
WHERE a.CategoryItemCode='0000' and a.CategoryLevel='0'  and  (DeptCode LIKE '1%' OR DeptCode LIKE '2%' ) 
and EnterAccountDate=convert(varchar(8),dateadd(dd,0,'${tqrq}'),112)
GROUP BY DEPTCODE) i on  a.NodeCode =i.DEPTCODE  

order by AreaCode,a.NodeCode ,a.defday

select AreaCode,a.NodeCode ,a.defday,
SUM(isnull(b.SaleMoney,0))销售金额,SUM(isnull(b.TaxSaleGrossProfit,0))销售毛利
 from 
(select  AreaCode,b.NodeCode ,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${tqrq}')+1,'${tqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${tqrq}')+1,'${tqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${tqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')


)a
left join 
(select nodecode,occurdate,LEFT(b.CategoryCode,2)CategoryCode ,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${TQYM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
AND b.CategoryCode not like '35000%' AND b.CategoryCode not like '23%' and occurdate = convert(varchar(8),dateadd(dd,0,'${tqrq}'),112) 
GROUP BY nodecode,occurdate,LEFT(b.CategoryCode,2)) b on  a.NodeCode =b.nodecode    and a.defday=b.occurdate
where  a.defday=convert(varchar(8),dateadd(dd,0,'${tqrq}'),112) 
group by AreaCode,a.NodeCode ,a.defday

select a.AreaCode,a.NodeCode ,a.defday,
SUM(isnull(b.SaleMeney,0))租赁销售  from 
(select  AreaCode,NodeCode ,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')

 )a 
left join 
(select b.BuildDate AccDate,b.DeptCode,SUM(saleincome+SaleTax)SaleMeney from 
TB商品档案 a,
tb${YM}_租赁商品销售明细 b
where a.GoodsCode =b.goodscode  and LEFT(a.CategoryCode,1) between 1 and 5
AND a.CategoryCode not like '35000%' AND a.CategoryCode not like '23%'
group by b.BuildDate ,b.DeptCode)b on  a.NodeCode =b.DeptCode     and a.defday=b.AccDate
where  a.defday=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) 
group by a.AreaCode,a.NodeCode ,a.defday


select SUM(isnull(b.SaleMoney,0))销售金额,SUM(isnull(b.TaxSaleGrossProfit,0))销售毛利
 from 
(select  AreaCode,NodeCode ,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')

)a
left join 
(select nodecode,occurdate,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${YM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
AND b.CategoryCode not like '35%' AND b.CategoryCode not like '23%'
GROUP BY nodecode,occurdate) b on  a.NodeCode =b.nodecode    and a.defday=b.occurdate


select * from 
	dbo.日期对照表
	where OccurDate =convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

select distinct AreaCode,AreaName from dbo.TB部门信息表 

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,dateadd(dd,-day(@dqrq)+1,@dqrq)),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  报表日期 between '+@qsrq+' and '+@dqrq+' and 商品分类项编码=''0000'' and 商品分类等级=0' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_分类报表数据源' and SUBSTRING(name,3,6) between @qsny and  @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='

select SUM(Salesindex)Salesindex,SUM(Grossprofitindex)Grossprofitindex,
sum(SaleMoney)SaleMoney,sum(SaleGrossProfit )SaleGrossProfit from 
TB部门信息表 a 
left join 
(select  DeptCode ,SUM(Salesindex)Salesindex,SUM(Grossprofitindex)Grossprofitindex 
from 含税分课预算表
where  BudgetYM between '+@qsny+' and '+@jsny+' and CategoryItemCode=''0000''
group by DeptCode)b on a.nodecode=b.deptcode

left join 
 ( select 部门编码,sum(销售金额)SaleMoney,sum(正常销售收入)+sum(促销销售收入)+sum(正常销项税金)+sum(促销销项税金)-sum(含税正常销售成本)-sum(含税促销销售成本)SaleGrossProfit
  from ( '+@SQL+')a
   group by  部门编码 ) c on a.nodecode=c.部门编码 
where (nodecode LIKE ''1%'' or nodecode LIKE ''2%'' ) 




'exec(@sql1)

select a.AreaCode,a.NodeCode ,A.WhetherNew,a.defday,isnull(d.CarryState,0)CarryState,
(round(case when isnull(b.Salesindex,0)<>0 then isnull(b.Salesindex,0) else isnull(c.Salesindex,0) end ,2)) Salesindex,
(round(case when isnull(b.Grossprofitindex,0)<>0 then  isnull(b.Grossprofitindex,0) else isnull(c.Grossprofitindex,0) end,2)) Grossprofitindex,
(isnull(round(e.SaleMoney,2),0))SaleMoney,
(isnull(round(e.TaxSaleGrossProfit,2),0))TaxSaleGrossProfit,
(isnull(f.TaxStartCost,0)+isnull(g.TaxStartCost,0))TaxEndCost,
(isnull(round(i.SaleCount,2),0))SaleCount,
(isnull(round(h.SaleMoney,2),0))TQ_SaleMoney,
(isnull(round(h.TaxSaleGrossProfit,2),0))TQ_TaxSaleGrossProfit,
(isnull(round(j.SaleMeney,2),0))CX_SaleMeney
 from 
(select  AreaCode,NodeCode ,case when datediff(day,OpenDate,'${tqrq}')>=20 then 0 else 1 end WhetherNew
,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and NodeCode not in ('1047','1070','1017') and convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
and OpenDate <= convert(varchar(8),dateadd(dd,0,GETDATE()),112)
)a
left join 
每日预算表 b on a.NodeCode=b.DeptCode and b.defday=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
left join 
(select DeptCode,sum(Salesindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Salesindex,sum(Grossprofitindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)c on a.NodeCode=c.DeptCode 
left join 
TBDAYCARRYLOG d on a.NodeCode=d.deptcode and d.CarryDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
left join 
(select nodecode,occurdate,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${YM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888' and a.nodecode=z.nodecode and a.goodscode=z.goodscode) AND b.CategoryCode not like '23%'  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and OccurDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
GROUP BY nodecode,occurdate) e on  a.NodeCode =e.nodecode   
left join 
(select nodecode,sum(StartCost+StartTax)TaxStartCost  from 
tb${YM}_GoodsMonPssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888' and a.nodecode=z.nodecode and a.goodscode=z.goodscode) AND b.CategoryCode not like '23%'  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
GROUP BY nodecode) f on  a.NodeCode =f.nodecode    

left join 
(select nodecode,sum((PurchCost+PurchTax)+(CompensateCost+CompensateTax)+ (RedeployinCost+RedeployinTax)+(ProfitCost+ProfitTax)+(CountProfitCost+CountProfitTax)  - TaxSaleCost  - (RedeployoutCost+RedeployoutTax) - (LossCost+LossTax)  -(CountLossCost+CountLossTax)  -(ToGiftCost+ToGiftTax))TaxStartCost  from 
tb${YM}_GoodsDayPssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888' and a.nodecode=z.nodecode and a.goodscode=z.goodscode) AND b.CategoryCode not like '23%'  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and OccurDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
GROUP BY nodecode) g on  a.NodeCode =g.nodecode    
left join 
(select nodecode,occurdate,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${TQYM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888' and a.nodecode=z.nodecode and a.goodscode=z.goodscode) AND b.CategoryCode not like '23%'  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and OccurDate=convert(varchar(8),dateadd(dd,0,'${tqrq}'),112)
GROUP BY nodecode,occurdate) h on  a.NodeCode =h.nodecode   
left join 
(select DeptCode,sum(SaleCount)SaleCount  from 
TB${YM}_门店客单客流 a
WHERE CategoryItemCode='0000' and CategoryLevel='0'  and  (DeptCode LIKE '1%' OR DeptCode LIKE '2%' ) 
and EnterAccountDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
GROUP BY DeptCode) i on  a.NodeCode =i.DeptCode   

left join 
(select DeptCode,SUM(saleincome+SaleTax)SaleMeney  from 
tb${YM}_门店促销数据 a
WHERE (DeptCode LIKE '1%' OR DeptCode LIKE '2%' ) 
and AccDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
GROUP BY DeptCode) j on  a.NodeCode =j.DeptCode   

order by AreaCode,a.NodeCode ,a.defday

select AreaCode,NodeCode ,a.defday,
SUM(isnull(SaleCount,0))销售客流  from 
(select  AreaCode,NodeCode ,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')


)a
left join 
TB${YM}_门店客单客流 b on  a.NodeCode =b.DeptCode     and a.defday=b.EnterAccountDate  and b.CategoryItemCode='0000' and b.CategoryLevel='0'
where  a.defday=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) 
group by AreaCode,NodeCode ,a.defday

select a.AreaCode,a.NodeCode ,a.defday,
SUM(isnull(b.SaleMeney,0))促销销售  from 
(select  AreaCode,NodeCode ,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')

 )a 
left join 
(select b.AccDate,b.DeptCode,SUM(saleincome+SaleTax)SaleMeney from 
tb${YM}_门店促销数据 b
group by b.AccDate,b.DeptCode)b on  a.NodeCode =b.DeptCode     and a.defday=b.AccDate
where  a.defday=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
group by a.AreaCode,a.NodeCode ,a.defday

select AreaCode,NodeCode ,a.defday,
sum(round(isnull(c.Salesindex,0) ,2)) Salesindex,
sum(round(isnull(c.Grossprofitindex,0),2)) Grossprofitindex
 from 
(select  AreaCode,NodeCode ,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and NodeCode  not in ('1047')
)a

left join 
(select DeptCode,sum(Salesindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Salesindex,sum(Grossprofitindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0001'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)c on a.NodeCode=c.DeptCode 

where a.defday=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) and a.NodeCode not in ('1047')
group by AreaCode,NodeCode ,a.defday
order by AreaCode,NodeCode ,a.defday

select sum(round(isnull(c.Salesindex,0) ,2)) Salesindex,
sum(round(isnull(c.Grossprofitindex,0),2)) Grossprofitindex
 from 
(select  AreaCode,NodeCode ,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' or NodeCode  LIKE '2%') and len(AreaCode)>0
and NodeCode  not in ('1047')
)a
left join 
(select DeptCode,sum(Salesindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Salesindex,sum(Grossprofitindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)c on a.NodeCode=c.DeptCode 


