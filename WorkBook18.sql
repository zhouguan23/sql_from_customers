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
and CategoryItemCode = '0000' and BudgetYM in ('201901','201902')
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }
and deptcode in (select NodeCode  from 
TB部门信息表 
where OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%'))
group by deptcode,CategoryCode

select deptcode,CategoryCode	,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where  (DeptCode like '1%' or DeptCode like '2%') and 
CategoryItemCode = '0001' and BudgetYM in ('201901','201902')
and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }
and deptcode in (select NodeCode  from 
TB部门信息表 
where OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%'))
group by deptcode,CategoryCode

select c.AreaCode,a.DeptCode,
count(distinct case when a.WorkStateCode in (1,2,5) then a.GoodsCode else null end )经营SKU,
count( distinct case when a.WorkStateCode in (1,2,5) and  a.Remark='1' then a.GoodsCode else null end )重点商品SKU,
count( distinct case when a.WorkStateCode in (1,2,5) and  a.GoodsType='1' then a.GoodsCode else null end )自有品牌SKU,
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
 tb部门信息表 c
 left join 
TBYEARPOBILLDETAIL a  on a.deptcode =c.nodecode
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
group by DeptCode ,GoodsCode) d on a.DeptCode =d.DeptCode and a.GoodsCode =d.GoodsCode 


where CateCatCode<>'333'  
and OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%')
and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and a.SupplierCode in ('" + replace(gys,",","','")+"')") }
and 1=1 ${if(len(lztj) == 0,   "",   "and a.CirculationModeCode in ('" + replace(lztj,",","','")+"')") }
and 1=1 ${if(len(spbm) == 0,   "",   "and a.goodscode in ('" + replace(spbm,",","','")+"')") }
group by c.AreaCode,a.DeptCode
order by 1,2

select ParentCategoryCode,CategoryCode,CategoryCode+' '+case when CategoryName='生鲜加工' then '加工' else CategoryName end  CategoryName from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5 and CategoryLevel<3 

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

where CateCatCode<>'333' 
and a.DeptCode in (select NodeCode  from TB部门信息表 where OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%'))
and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and a.SupplierCode in ('" + replace(gys,",","','")+"')") }
and 1=1 ${if(len(lztj) == 0,   "",   "and a.CirculationModeCode in ('" + replace(lztj,",","','")+"')") }
and 1=1 ${if(len(spbm) == 0,   "",   "and a.goodscode in ('" + replace(spbm,",","','")+"')") }
group by left(CategoryCode,1),left(CategoryCode,2))b on a.CategoryCode=b.课分类
where a.CategoryLevel=2 and a.CategoryCode not like '0%' and a.CategoryCode not like '1%' and a.CategoryCode not like '2%' and a.CategoryCode not like '6%'
and a.CategoryItemCode ='0000' and 1=1 ${if(len(fl) == 0,   "",   "and a.CategoryCode in ('" + replace(fl,",","','")+"')") }
order by 1,2

select a.SupplierCode,
count(distinct case when a.WorkStateCode in (1,2,5)  then a.GoodsCode else null end)经营SKU,
count( distinct case when a.WorkStateCode in (1,2,5) and  a.Remark='1' then a.GoodsCode else null end )重点商品SKU,
count( distinct case when a.WorkStateCode in (1,2,5) and  a.GoodsType='1' then a.GoodsCode else null end )自有品牌SKU,
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
where CateCatCode<>'333'
and a.DeptCode in (select NodeCode  from 
TB部门信息表 
where OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%'))
and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and a.SupplierCode in ('" + replace(gys,",","','")+"')") }
and 1=1 ${if(len(lztj) == 0,   "",   "and a.CirculationModeCode in ('" + replace(lztj,",","','")+"')") }
and 1=1 ${if(len(spbm) == 0,   "",   "and a.goodscode in ('" + replace(spbm,",","','")+"')") }
group by a.SupplierCode
order by a.SupplierCode



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
where CateCatCode<>'333'
and a.DeptCode in (select NodeCode  from 
TB部门信息表 
where OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%'))
and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and a.SupplierCode in ('" + replace(gys,",","','")+"')") }
and 1=1 ${if(len(lztj) == 0,   "",   "and a.CirculationModeCode in ('" + replace(lztj,",","','")+"')") }
and 1=1 ${if(len(spbm) == 0,   "",   "and a.goodscode in ('" + replace(spbm,",","','")+"')") }
group by a.WorkStateCode
order by a.WorkStateCode

select a.CirculationModeCode,
count(distinct case when a.WorkStateCode in (1,2,5) then a.GoodsCode else null end )经营SKU,
count( distinct case when a.WorkStateCode in (1,2,5) and  a.Remark='1' then a.GoodsCode else null end )重点商品SKU,
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
where CateCatCode<>'333'
and a.DeptCode in (select NodeCode  from 
TB部门信息表 
where OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%'))
and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and a.SupplierCode in ('" + replace(gys,",","','")+"')") }
and 1=1 ${if(len(lztj) == 0,   "",   "and a.CirculationModeCode in ('" + replace(lztj,",","','")+"')") }
and 1=1 ${if(len(spbm) == 0,   "",   "and a.goodscode in ('" + replace(spbm,",","','")+"')") }
group by a.CirculationModeCode
order by a.CirculationModeCode

select a.DeptCode ,left(CategoryCode,1)大分类,left(CategoryCode,2)课分类,
count(distinct case when a.WorkStateCode in (1,2,5)  then a.GoodsCode else null end )经营SKU,
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

where CateCatCode<>'333' 
and a.DeptCode in (select NodeCode  from 
TB部门信息表 
where OpenDate <=convert(varchar(8),GETDATE(),112) and (NodeCode like '1%' or NodeCode like '2%'))
and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryCode not like '6%'
and exists(select 1 from TB部门特殊商品对照 e where  a.DeptCode =e.NodeCode and a.GoodsCode =e.GoodsCode and e.GoodsPropertyCode='1999')
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and a.SupplierCode in ('" + replace(gys,",","','")+"')") }
and 1=1 ${if(len(lztj) == 0,   "",   "and a.CirculationModeCode in ('" + replace(lztj,",","','")+"')") }
and 1=1 ${if(len(spbm) == 0,   "",   "and a.goodscode in ('" + replace(spbm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
group by a.DeptCode,left(CategoryCode,1),left(CategoryCode,2)

