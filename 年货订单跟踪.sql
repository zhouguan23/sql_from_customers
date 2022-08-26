select c.AreaCode,left(CategoryCode,1)大分类,left(CategoryCode,2)课分类,
a.GoodsCode,a.DeptCode,a.GoodsType,a.SupplierCode,a.WorkStateCode,a.CirculationModeCode,isnull(a.BuyerOrderAmount,0)+isnull(a.OrderAmount,0)BuyerOrderAmount,isnull(a.BuyerOrderMoney,0)+ISNULL(a.OrderMoney,0)BuyerOrderMoney,a.Remark
,b.TaxCost  from 
TBYEARPOBILLDETAIL a
left join 
tbStocks b on a.deptcode=b.CounterCode and a.goodscode=b.goodscode
left join 
tb部门信息表 c on a.deptcode =c.nodecode
where CateCatCode<>'333'  and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
order by 3,1,5,7

select deptcode,CategoryCode	,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where  (DeptCode like '1%' or DeptCode like '2%') 
and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and BudgetYM in ('202001','202002')
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(sx) == 0,   "",if(or(sx == 0,sx==3),"and CategoryItemCode = '0000'",   "and CategoryItemCode = '0001'")) }
and deptcode in (select NodeCode  from 
hldw.dbo.TB部门信息表 
where OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%'))
group by deptcode,CategoryCode

select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 
and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

select ParentCategoryCode,CategoryCode,CategoryCode+' '+case when CategoryName='生鲜加工' then '加工' else CategoryName end  CategoryName from TB商品分类表  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5 and CategoryLevel<3 


select a.AreaCode,a.AreaName,a.NodeCode,a.NodeName,b.ParentCategoryCode,b.CategoryCode,b.CategoryName from 
tb部门信息表 a ,
TB商品分类表 b 
where (a.NodeCode like '1%' or a.NodeCode like '2%') and len(a.AreaCode)!=0
and NodeCode not in ('1017','1047')
and b.CategoryLevel='2' and b.CategoryItemCode='0000' and left(b.CategoryCode,1) between '3' and '5' 
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and b.CategoryCode in ('" + replace(fl,",","','")+"')") }
order by 1,3,5,6

select a.WorkStateCode,
count(distinct  a.GoodsCode  )经营SKU,
count( distinct case when  a.Remark='1' then a.GoodsCode else null end )重点商品SKU,
count( distinct case when  a.GoodsType='1' then a.GoodsCode else null end )自有品牌SKU,
sum(isnull(a.BuyerOrderMoney,0)+ISNULL(a.OrderMoney,0))计划囤货额,
sum(case when a.Remark='1' then isnull(a.BuyerOrderMoney,0)+ISNULL(a.OrderMoney,0) else 0 end )重点商品计划囤货额,
sum(case when a.GoodsType='1' then isnull(a.BuyerOrderMoney,0)+ISNULL(a.OrderMoney,0) else 0 end )自有品牌计划囤货额,
sum(年货下单额 )年货下单额,
sum(团购下单额)团购下单额,
sum(促销下单额)促销下单额,
sum(年货在途额)年货在途额,
sum(团购在途额)团购在途额,
sum(促销在途额)促销在途额,
sum(年货到货额)年货到货额,
sum(团购到货额)团购到货额,
sum(促销到货额)促销到货额,
sum(b.TaxCost)库存金额,
sum(case when a.Remark='1' then b.TaxCost else 0 end )重点商品库存金额,
sum(case when a.GoodsType='1' then b.TaxCost else 0 end )自有品牌库存金额
 from 
TBYEARPOBILLDETAIL a
left join 
tbStocks b on a.deptcode=b.CounterCode and a.goodscode=b.goodscode
left join 
tb部门信息表 c on a.deptcode =c.nodecode
left join 
(select DeptCode ,GoodsCode ,
sum(case when d.BillPropCode='01' then isnull(d.PurchMoney,0) else 0 end )年货下单额,
sum(case when d.BillPropCode='03' then isnull(d.PurchMoney,0) else 0 end )团购下单额,
sum(case when d.BillPropCode='05' then isnull(d.PurchMoney,0) else 0 end )促销下单额,
sum(case when d.BillPropCode='01' then isnull(d.WayMoney,0) else 0 end )年货在途额,
sum(case when d.BillPropCode='03' then isnull(d.WayMoney,0) else 0 end )团购在途额,
sum(case when d.BillPropCode='05' then isnull(d.WayMoney,0) else 0 end )促销在途额,
sum(case when d.BillPropCode='01' then isnull(d.PerformMoney,0) else 0 end )年货到货额,
sum(case when d.BillPropCode='03' then isnull(d.PerformMoney,0) else 0 end )团购到货额,
sum(case when d.BillPropCode='05' then isnull(d.PerformMoney,0) else 0 end )促销到货额 from 
tbAnnualorder d
group by DeptCode ,GoodsCode) d on a.DeptCode =d.DeptCode and a.GoodsCode =d.GoodsCode 
where CateCatCode<>'333' and a.deptcode not in ('1047')  and a.GoodsType='1' 

and a.DeptCode in (select NodeCode  from 
TB部门信息表 
where OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%') and 1=1 ${if(len(dq) == 0,   "",   "and AreaCode in ('" + replace(dq,",","','")+"')") } )
and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and a.SupplierCode in ('" + replace(gys,",","','")+"')") }

and 1=1 ${if(len(zd) == 0,   "",   "and a.Remark in ('" + replace(zd,",","','")+"')") }
group by a.WorkStateCode
order by a.WorkStateCode

select a.ParentCategoryCode  大分类,a.CategoryCode 课分类,
经营SKU,重点商品SKU,自有品牌SKU,
计划囤货额,
重点商品计划囤货额,
自有品牌计划囤货额,
年货下单额,
团购下单额,
促销下单额,
年货在途额,
团购在途额,
促销在途额,
年货到货额,
团购到货额,
促销到货额,
库存金额,重点商品库存金额,自有品牌库存金额
from 
tb商品分类表 a
left join 
(select left(CategoryCode,1)大分类,left(CategoryCode,2)课分类,
count(distinct case when a.WorkStateCode in (1,2,5) then  a.GoodsCode end )经营SKU,
count( distinct case when a.WorkStateCode in (1,2,5) and a.Remark='1' then a.GoodsCode else null end )重点商品SKU,
count( distinct case when a.WorkStateCode in (1,2,5) and a.GoodsType='1' then a.GoodsCode else null end )自有品牌SKU,
sum(isnull(a.BuyerOrderMoney,0)+ISNULL(a.OrderMoney,0))计划囤货额,
sum(case when a.Remark='1' then isnull(a.BuyerOrderMoney,0)+ISNULL(a.OrderMoney,0) else 0 end )重点商品计划囤货额,
sum(case when a.GoodsType='1' then isnull(a.BuyerOrderMoney,0)+ISNULL(a.OrderMoney,0) else 0 end )自有品牌计划囤货额,
sum(年货下单额 )年货下单额,
sum(团购下单额)团购下单额,
sum(促销下单额)促销下单额,
sum(年货在途额)年货在途额,
sum(团购在途额)团购在途额,
sum(促销在途额)促销在途额,
sum(年货到货额)年货到货额,
sum(团购到货额)团购到货额,
sum(促销到货额)促销到货额,
sum(b.TaxCost)库存金额,
sum(case when a.Remark='1' then b.TaxCost else 0 end )重点商品库存金额,
sum(case when a.GoodsType='1' then b.TaxCost else 0 end )自有品牌库存金额
 from 
TBYEARPOBILLDETAIL a
left join 
tbStocks b on a.deptcode=b.CounterCode and a.goodscode=b.goodscode
left join 
(select DeptCode ,GoodsCode ,
sum(case when d.BillPropCode='01' then isnull(d.PurchMoney,0) else 0 end )年货下单额,
sum(case when d.BillPropCode='03' then isnull(d.PurchMoney,0) else 0 end )团购下单额,
sum(case when d.BillPropCode='05' then isnull(d.PurchMoney,0) else 0 end )促销下单额,
sum(case when d.BillPropCode='01' then isnull(d.WayMoney,0) else 0 end )年货在途额,
sum(case when d.BillPropCode='03' then isnull(d.WayMoney,0) else 0 end )团购在途额,
sum(case when d.BillPropCode='05' then isnull(d.WayMoney,0) else 0 end )促销在途额,
sum(case when d.BillPropCode='01' then isnull(d.PerformMoney,0) else 0 end )年货到货额,
sum(case when d.BillPropCode='03' then isnull(d.PerformMoney,0) else 0 end )团购到货额,
sum(case when d.BillPropCode='05' then isnull(d.PerformMoney,0) else 0 end )促销到货额 from 
tbAnnualorder d
group by DeptCode ,GoodsCode) c on a.DeptCode =c.DeptCode and a.GoodsCode =c.GoodsCode 

where CateCatCode<>'333'  and a.deptcode not in ('1047') and a.GoodsType='1' 
and a.DeptCode in (select NodeCode  from TB部门信息表 where OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%')
and 1=1 ${if(len(dq) == 0,   "",   "and AreaCode in ('" + replace(dq,",","','")+"')") })
and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and a.SupplierCode in ('" + replace(gys,",","','")+"')") }
and 1=1 ${if(len(zd) == 0,   "",   "and a.Remark in ('" + replace(zd,",","','")+"')") }
group by left(CategoryCode,1),left(CategoryCode,2))b on a.CategoryCode=b.课分类
where a.CategoryLevel=2 and a.CategoryCode not like '0%' and a.CategoryCode not like '1%' and a.CategoryCode not like '2%' and a.CategoryCode not like '6%'
and a.CategoryItemCode ='0000' and 1=1 ${if(len(fl) == 0,   "",   "and a.CategoryCode in ('" + replace(fl,",","','")+"')") }
order by 1,2

DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX)



SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL select * from tbYEARPOBILLDETAIL'+Nodecode+' a
where  1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in (''" + replace(bm,",","'',''")+"'')") }
and    1=1 ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }
and    1=1 ${if(len(gys) == 0,   "",   "and A.SupplierCode  in (''" + replace(gys,",","'',''")+"'')") }
and    1=1 ${if(len(spbm) == 0,   "",   "and A.GoodsCode  in (''" + replace(spbm,",","'',''")+"'')") }
and    1=1 ${if(len(lztj) == 0,   "",   "and a.CirculationModeCode  in (''" + replace(lztj,",","'',''")+"'')") }
and    1=1 ${if(sx == 3,   "",if(sx == 0,"and exists(select * from hldw.dbo.tb商品档案 Y where a.goodscode=y.goodscode and y.GoodsBrand!=''010001'')",   "and exists(select * from hldw.dbo.tb商品档案 Y where a.goodscode=y.goodscode and y.GoodsBrand=''010001'')")) }
 ' 
 FROM hldw.dbo.TB部门信息表 WHERE (NodeCode like '1%' or NodeCode like '2%') and 1=1 ${if(len(bm) == 0,   "",   "and NodeCode in ('" + replace(bm,",","','")+"')") }

SET @SQL1=STUFF(@SQL1,1,11,'')


SET @SQL='

 select a.deptcode,left(CategoryCode,2)CategoryCode,left(CategoryCode,2),
case when a.workStateCode in (1,2,5) then ''经营商品'' else ''锁档商品'' end workStateCode,a.CirculationModeCode,a.SupplierCode,
IsImportGoods,
sum(StoreOrderMoney)StoreOrderMoney,
case when sum(BuyerOrderMoney)=0 then 0 else  sum(StoreOrderMoney)-sum(BuyerOrderMoney) end BuyerOrderMoney,
case when sum(OrderMoney) =0 then 0 else sum(OrderMoney)- case when sum(BuyerOrderMoney)=0 then sum(StoreOrderMoney) else  sum(BuyerOrderMoney) end  end   OrderMoney ,
      sum(d.SaleMoney) LastyearMoney,
isnull(SUM(b.TaxCost),0) TaxStockCost
,sum( e.Amount*A.PurchPrice)申请在途数量
,sum( ee.Amount*A.PurchPrice)订单在途数量
,sum( eee.Amount*A.PurchPrice)配送在途数量
,sum( f.Amount)到货数量
,sum( f.PurchMoney)到货成本 from
('+@SQL1+')a
left join 
hldw.dbo.tbStocks b on a.deptcode=b.CounterCode and a.goodscode=b.goodscode
left join 
TBNodeVS c on a.deptcode=c.nodecode
left join 
TBAnnualgoodsVSYear d on d.DataType=''0'' and  a.goodscode=d.goodscode and c.Y_VSnodecode=d.nodecode
left join 
(select deptcode,goodscode,sum(Amount)Amount from [hldw]A.dbo.tbGoodsWayArrivalannual where BillState=0 group by deptcode,goodscode) e on a.deptcode=e.deptcode and a.goodscode=e.goodscode
left join 
(select deptcode,goodscode,sum(Amount)Amount from [hldw]A.dbo.tbGoodsWayArrivalannual where BillState=1 group by deptcode,goodscode) ee on a.deptcode=ee.deptcode and a.goodscode=ee.goodscode
left join 
(select deptcode,goodscode,sum(Amount)Amount from [hldw]A.dbo.tbGoodsWayArrivalannual where BillState=2 group by deptcode,goodscode) eee on a.deptcode=eee.deptcode and a.goodscode=eee.goodscode
left join 
(select NodeCode deptcode,goodscode,sum(PurchAmount+RedeployinAmount)Amount,sum(PurchCost+PurchTax +RedeployinCost+RedeployinTax)PurchMoney 
from (select * from [hldw]A.dbo.tb201912_goodsdaypssm where OccurDate between 20191209 and 20200124 
union all 
       select * from [hldw]A.dbo.tb202001_goodsdaypssm where OccurDate between 20191209 and 20200124 )a 
group by nodecode,goodscode) f on a.deptcode=f.deptcode and a.goodscode=f.goodscode


group by a.deptcode,left(CategoryCode,2),case when a.workStateCode in (1,2,5) then ''经营商品'' else ''锁档商品'' end,CirculationModeCode,a.SupplierCode,a.IsImportGoods


'exec(@sql)




select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047,6601,6602)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}


