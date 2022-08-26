select a.AreaCode,a.NodeCode ,a.CategoryCode,A.WhetherNew,a.defday,isnull(d.CarryState,0)CarryState,
(round(isnull(c.Salesindex,0),2)) Salesindex,
(round(isnull(c.Grossprofitindex,0),2)) Grossprofitindex,
(isnull(round(e.SaleMoney,2),0))SaleMoney,
(isnull(round(e.TaxSaleGrossProfit,2),0))TaxSaleGrossProfit,
(isnull(f.TaxStartCost,0)+isnull(g.TaxStartCost,0))TaxEndCost,
(isnull(round(i.SaleCount,2),0))SaleCount,
(isnull(round(h.SaleMoney,2),0))TQ_SaleMoney,
(isnull(round(h.TaxSaleGrossProfit,2),0))TQ_TaxSaleGrossProfit,
(isnull(round(j.SaleMeney,2),0))CX_SaleMeney
 from 
(select  AreaCode,NodeCode ,c.CategoryCode,case when datediff(day,OpenDate,'20190120')>=20 then 0 else 1 end WhetherNew
,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b,TB商品分类表 c 
where type='p' and number <= datediff(dd,dateadd(dd,-day('${dqrq}')+1,'${dqrq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%') and c.CategoryLevel='2' and c.CategoryItemCode='0000' and c.ParentCategoryCode between '1' and '5' 
and c.CategoryCode  in ('10','30','40','46','50')
and NodeCode not in ('1047','1070','1017') and convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${dqrq}')+1,'${dqrq}'),112)),112)=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
and OpenDate <= convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
)a
left join 
(select DeptCode,CategoryCode,sum(Salesindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Salesindex,sum(Grossprofitindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${dqrq}')+1, 0)))Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0001'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${dqrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode,CategoryCode)c on a.NodeCode=c.DeptCode  and a.CategoryCode=c.CategoryCode
left join 
TBDAYCARRYLOG d on a.NodeCode=d.deptcode and d.CarryDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
left join 
(select nodecode,
case when (left(CategoryCode,2) like '1%' or left(CategoryCode,2) like '2%') then '10'
when (left(CategoryCode,2) like '3%') then '30' 
when left(CategoryCode,2) like '4%' and left(CategoryCode,2) not like '46%' and left(CategoryCode,2) not like '47%' then '40'
when left(CategoryCode,2) like '46%' or left(CategoryCode,2) like '47%' then '46'
when left(CategoryCode,2) like '5%' then '50' end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${YM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode and GoodsBrand='010001' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888' and a.nodecode=z.nodecode and a.goodscode=z.goodscode)   and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and OccurDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
GROUP BY nodecode,case when (left(CategoryCode,2) like '1%' or left(CategoryCode,2) like '2%') then '10'
when (left(CategoryCode,2) like '3%') then '30' 
when left(CategoryCode,2) like '4%' and left(CategoryCode,2) not like '46%' and left(CategoryCode,2) not like '47%' then '40'
when left(CategoryCode,2) like '46%' or left(CategoryCode,2) like '47%' then '46'
when left(CategoryCode,2) like '5%' then '50' end ) e on  a.NodeCode =e.nodecode    and a.CategoryCode=e.CategoryCode
left join 
(select nodecode,case when (left(CategoryCode,2) like '1%' or left(CategoryCode,2) like '2%') then '10'
when (left(CategoryCode,2) like '3%') then '30' 
when left(CategoryCode,2) like '4%' and left(CategoryCode,2) not like '46%' and left(CategoryCode,2) not like '47%' then '40'
when left(CategoryCode,2) like '46%' or left(CategoryCode,2) like '47%' then '46'
when left(CategoryCode,2) like '5%' then '50' end CategoryCode,sum(StartCost+StartTax)TaxStartCost  from 
tb${YM}_GoodsMonPssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888'  and a.nodecode=z.nodecode and a.goodscode=z.goodscode)  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
GROUP BY nodecode,case when (left(CategoryCode,2) like '1%' or left(CategoryCode,2) like '2%') then '10'
when (left(CategoryCode,2) like '3%') then '30' 
when left(CategoryCode,2) like '4%' and left(CategoryCode,2) not like '46%' and left(CategoryCode,2) not like '47%' then '40'
when left(CategoryCode,2) like '46%' or left(CategoryCode,2) like '47%' then '46'
when left(CategoryCode,2) like '5%' then '50' end) f on  a.NodeCode =f.nodecode    and a.CategoryCode=f.CategoryCode 

left join 
(select nodecode,case when (left(CategoryCode,2) like '1%' or left(CategoryCode,2) like '2%') then '10'
when (left(CategoryCode,2) like '3%') then '30' 
when left(CategoryCode,2) like '4%' and left(CategoryCode,2) not like '46%' and left(CategoryCode,2) not like '47%' then '40'
when left(CategoryCode,2) like '46%' or left(CategoryCode,2) like '47%' then '46'
when left(CategoryCode,2) like '5%' then '50' end CategoryCode,sum((PurchCost+PurchTax)+(CompensateCost+CompensateTax)+ (RedeployinCost+RedeployinTax)+(ProfitCost+ProfitTax)+(CountProfitCost+CountProfitTax)  - TaxSaleCost  - (RedeployoutCost+RedeployoutTax) - (LossCost+LossTax)  -(CountLossCost+CountLossTax)  -(ToGiftCost+ToGiftTax))TaxStartCost  from 
tb${YM}_GoodsDayPssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode and GoodsBrand='010001' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888' and a.nodecode=z.nodecode and a.goodscode=z.goodscode)   and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and OccurDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
GROUP BY nodecode,case when (left(CategoryCode,2) like '1%' or left(CategoryCode,2) like '2%') then '10'
when (left(CategoryCode,2) like '3%') then '30' 
when left(CategoryCode,2) like '4%' and left(CategoryCode,2) not like '46%' and left(CategoryCode,2) not like '47%' then '40'
when left(CategoryCode,2) like '46%' or left(CategoryCode,2) like '47%' then '46'
when left(CategoryCode,2) like '5%' then '50' end) g on  a.NodeCode =g.nodecode  and a.CategoryCode=g.CategoryCode  
left join 
(select nodecode,case when (left(CategoryCode,2) like '1%' or left(CategoryCode,2) like '2%') then '10'
when (left(CategoryCode,2) like '3%') then '30' 
when left(CategoryCode,2) like '4%' and left(CategoryCode,2) not like '46%' and left(CategoryCode,2) not like '47%' then '40'
when left(CategoryCode,2) like '46%' or left(CategoryCode,2) like '47%' then '46'
when left(CategoryCode,2) like '5%' then '50' end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${TQYM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode and GoodsBrand='010001' AND   (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888' and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
and OccurDate=convert(varchar(8),dateadd(dd,0,'${TQRQ}'),112)
GROUP BY nodecode,case when (left(CategoryCode,2) like '1%' or left(CategoryCode,2) like '2%') then '10'
when (left(CategoryCode,2) like '3%') then '30' 
when left(CategoryCode,2) like '4%' and left(CategoryCode,2) not like '46%' and left(CategoryCode,2) not like '47%' then '40'
when left(CategoryCode,2) like '46%' or left(CategoryCode,2) like '47%' then '46'
when left(CategoryCode,2) like '5%' then '50' end ) h on  a.NodeCode =h.nodecode and a.CategoryCode=h.CategoryCode  
left join 
(select DeptCode,case when (left(GoodsCatCode,2) like '1%' or left(GoodsCatCode,2) like '2%') then '10'
when (left(GoodsCatCode,2) like '3%') then '30' 
when left(GoodsCatCode,2) like '4%' and left(GoodsCatCode,2) not like '46%' and left(GoodsCatCode,2) not like '47%' then '40'
when left(GoodsCatCode,2) like '46%' or left(GoodsCatCode,2) like '47%' then '46'
when left(GoodsCatCode,2) like '5%' then '50' end CategoryCode,sum(SaleCount)SaleCount  from 
TB${YM}_门店客单客流 a
WHERE CategoryItemCode='0001' and CategoryLevel='0'  and  (DeptCode LIKE '1%' OR DeptCode LIKE '2%' ) 
and EnterAccountDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
GROUP BY DeptCode,case when (left(GoodsCatCode,2) like '1%'  or left(GoodsCatCode,2) like '2%') then '10'
when (left(GoodsCatCode,2) like '3%') then '30' 
when left(GoodsCatCode,2) like '4%' and left(GoodsCatCode,2) not like '46%' and left(GoodsCatCode,2) not like '47%' then '40'
when left(GoodsCatCode,2) like '46%' or left(GoodsCatCode,2) like '47%' then '46'
when left(GoodsCatCode,2) like '5%' then '50' end) i on  a.NodeCode =i.DeptCode    and a.CategoryCode=i.CategoryCode

left join 
(select DeptCode,case when (left(CategoryCode,2) like '1%' or left(CategoryCode,2) like '2%') then '10'
when (left(CategoryCode,2) like '3%') then '30' 
when left(CategoryCode,2) like '4%' and left(CategoryCode,2) not like '46%' and left(CategoryCode,2) not like '47%' then '40'
when left(CategoryCode,2) like '46%' or left(CategoryCode,2) like '47%' then '46'
when left(CategoryCode,2) like '5%' then '50' end CategoryCode,SUM(saleincome+SaleTax)SaleMeney  from 
tb${YM}_门店促销数据 a ,TB商品档案 b
WHERE a.goodscode=b.goodscode and GoodsBrand='010001' and (DeptCode LIKE '1%' OR DeptCode LIKE '2%' ) 
and AccDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
GROUP BY DeptCode,case when (left(CategoryCode,2) like '1%' or left(CategoryCode,2) like '2%') then '10'
when (left(CategoryCode,2) like '3%') then '30' 
when left(CategoryCode,2) like '4%' and left(CategoryCode,2) not like '46%' and left(CategoryCode,2) not like '47%' then '40'
when left(CategoryCode,2) like '46%' or left(CategoryCode,2) like '47%' then '46'
when left(CategoryCode,2) like '5%' then '50' end) j on  a.NodeCode =j.DeptCode    and a.CategoryCode=j.CategoryCode

order by AreaCode,a.NodeCode ,a.CategoryCode,a.defday



select nodecode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit  from 
tb${YM}_GoodsDAYpssm a,tb商品档案 b 
WHERE a.goodscode=b.goodscode   and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888' and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
and OccurDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
group by nodecode


select * from 
	dbo.日期对照表
	where OccurDate =convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

