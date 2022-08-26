select AreaCode,AreaName,FormatCode,FormatName,a.SuppCode SuppCode,a.DeptCode,left(a.GoodsCatCode,1)GoodsCatCode1,a.GoodsCatCode,
a.SKU,a.XDS,a.Amount,a.PurchMoney,a.PerformAmount,a.PerformMoney,
isnull(b.SKU,0) q_SKU,isnull(b.XDS,0) q_XDS,isnull(b.Amount,0) q_Amount,isnull(b.PurchMoney,0) q_PurchMoney,
isnull(c.SKU,0) d_SKU,isnull(c.XDS,0) d_XDS,isnull(c.Amount,0) d_Amount,isnull(c.PurchMoney,0) d_PurchMoney 
from 
(select a.SupplierName SuppCode,a.DeptCode,left(a.CategoryCode,2)GoodsCatCode,
COUNT(a.GoodsCode)SKU,COUNT(distinct a.BillNumber)XDS,
sum(a.Amount)Amount,sum(a.PurchMoney)PurchMoney,sum(a.PerformAmount)PerformAmount,sum(a.PerformMoney)PerformMoney from 
tb${YM}_Logisticsdistribution  a
where LEFT(BuildDate,8)  <='${rq}'  and CategoryCode not like '0%' and CategoryCode not like '6%' and CategoryCode not like '300%' 
and  1=1 ${if(len(fl2) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
and  1=1 ${if(len(gys) == 0,   "",   "and a.SupplierName in ('" + replace(gys,",","','")+"')") }
and  1=1 ${
 if(sx == '010001',   "and exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='010001')"
,if(sx == '2001',   "and exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='2001')"
,if(sx == '3', " and ControlType='是' "
,if(sx == '4', "and not exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='010001') and ControlType='否' ",""))))}

group by a.SupplierName,a.DeptCode,left(a.CategoryCode,2))a
left join 
(select a.SupplierName SuppCode,a.DeptCode,left(a.CategoryCode,2)GoodsCatCode,
COUNT(a.GoodsCode)SKU,COUNT(distinct a.BillNumber)XDS,
sum(a.Amount)Amount,sum(a.PurchMoney)PurchMoney,sum(a.PerformAmount)PerformAmount,sum(a.PerformMoney)PerformMoney from 
tb${YM}_Logisticsdistribution  a
where LEFT(BuildDate,8)  <='${rq}' and case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end =0 and CategoryCode not like '0%' and CategoryCode not like '6%' and CategoryCode not like '300%'
and  1=1 ${if(len(fl2) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
and  1=1 ${if(len(gys) == 0,   "",   "and a.SupplierName in ('" + replace(gys,",","','")+"')") }
and  1=1 ${
 if(sx == '010001',   "and exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='010001')"
,if(sx == '2001',   "and exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='2001')"
,if(sx == '3', " and ControlType='是' "
,if(sx == '4', "and not exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='010001') and ControlType='否' ",""))))}
group by a.SupplierName,a.DeptCode,left(a.CategoryCode,2)
)b on a.SuppCode=b.suppcode and a.DeptCode=b.deptcode and a.GoodsCatCode=b.GoodsCatCode 
left join 
(select a.SupplierName SuppCode,a.DeptCode,left(a.CategoryCode,2)GoodsCatCode,
COUNT(a.GoodsCode)SKU,COUNT(distinct a.BillNumber)XDS,
sum(a.Amount-a.PerformAmount)Amount,sum(a.PurchMoney-a.PerformMoney)PurchMoney from 
tb${YM}_Logisticsdistribution  a 
where LEFT(BuildDate,8)  <='${rq}'
and  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end >0
and  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end <  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.Amount else a.PurchMoney end


and CategoryCode not like '0%' and CategoryCode not like '6%' and CategoryCode not like '300%' and  1=1 ${if(len(fl2) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
and  1=1 ${if(len(gys) == 0,   "",   "and a.SupplierName in ('" + replace(gys,",","','")+"')") }
and  1=1 ${
 if(sx == '010001',   "and exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='010001')"
,if(sx == '2001',   "and exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='2001')"
,if(sx == '3', " and ControlType='是' "
,if(sx == '4', "and not exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='010001') and ControlType='否' ",""))))}
group by a.SupplierName,a.DeptCode,left(a.CategoryCode,2)
)c on a.SuppCode=c.suppcode and a.DeptCode=c.deptcode and a.GoodsCatCode=c.GoodsCatCode 
left join 
dbo.TB部门信息表 d on a.DeptCode=d.nodecode 

where 1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode  in ('" + replace(bm,",","','")+"')") }

order by 8,6,5




SELECT SupplierCode+' '+SupplierName SupplierName,SuppType 
FROM [000]A.TBSUPPLIER
where SuppType in ('OEM','自采','战略')

