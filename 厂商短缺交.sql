

select a.SupplierName SuppCode,left(a.CategoryCode,1)GoodsCatCode1,left(a.CategoryCode,2)GoodsCatCode,
COUNT(a.GoodsCode)SKU,COUNT(distinct a.BillNumber)XDS,
sum(a.Amount)Amount,sum(a.PurchMoney)PurchMoney,sum(a.PerformAmount)PerformAmount,sum(a.PerformMoney)PerformMoney,
COUNT(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end =0 then  a.GoodsCode else null  end )q_SKU
,COUNT(distinct case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end =0 then  a.BillNumber else null  end )q_XDS
,sum(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end =0 then  a.Amount else 0  end )q_Amount
,sum(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end =0 then  a.PurchMoney else 0  end)q_PurchMoney
,
COUNT(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end >0 and  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end <  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.Amount else a.PurchMoney end then  a.GoodsCode else null  end )d_SKU
,COUNT(distinct case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end >0 and  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end <  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.Amount else a.PurchMoney end then  a.BillNumber else null  end )d_XDS
,sum(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end >0 and  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end <  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.Amount else a.PurchMoney end then  a.Amount else 0  end )d_Amount
,sum(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end >0 and  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end <  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.Amount else a.PurchMoney end then  a.PurchMoney else 0  end)d_PurchMoney


 from 
tb${YM}_SupplierShortage  a
left join 
dbo.TB部门信息表 d on a.DeptCode=d.nodecode 
where  CategoryCode not like '0%' and CategoryCode not like '6%' and CategoryCode not like '300%' 
and len(a.SupplierName)>0  and a.BuildDate <='${rq}'
and  1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(fl2) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
and  1=1 ${if(len(gys) == 0,   "",   "and left(a.SupplierName,7) in ('" + replace(gys,",","','")+"')") }
and  1=1 ${if(sx == 0,   "",   "and exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='" +sx+"')") }

group by a.SupplierName,left(a.CategoryCode,1),left(a.CategoryCode,2)

order by 2,3,1



select AreaCode,AreaName,a.SupplierName SuppCode,a.DeptCode,
COUNT(a.GoodsCode)SKU,COUNT(distinct a.BillNumber)XDS,
sum(a.Amount)Amount,sum(a.PurchMoney)PurchMoney,sum(a.PerformAmount)PerformAmount,sum(a.PerformMoney)PerformMoney,
COUNT(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end =0 then  a.GoodsCode else null  end )q_SKU
,COUNT(distinct case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end =0 then  a.BillNumber else null  end )q_XDS
,sum(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end =0 then  a.Amount else 0  end )q_Amount
,sum(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end =0 then  a.PurchMoney else 0  end)q_PurchMoney
,
COUNT(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end >0 and  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end <  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.Amount else a.PurchMoney end then  a.GoodsCode else null  end )d_SKU
,COUNT(distinct case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end >0 and  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end <  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.Amount else a.PurchMoney end then  a.BillNumber else null  end )d_XDS
,sum(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end >0 and  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end <  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.Amount else a.PurchMoney end then  a.Amount else 0  end )d_Amount
,sum(case when case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end >0 and  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end <  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.Amount else a.PurchMoney end then  a.PurchMoney else 0  end)d_PurchMoney


 from 
tb${YM}_SupplierShortage  a
left join 
dbo.TB部门信息表 d on a.DeptCode=d.nodecode 
where  CategoryCode not like '0%' and CategoryCode not like '6%' and CategoryCode not like '300%' 
and len(a.SupplierName)>0   and a.BuildDate <='${rq}'
and  1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(fl2) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
and  1=1 ${if(len(gys) == 0,   "",   "and left(a.SupplierName,7) in ('" + replace(gys,",","','")+"')") }
and  1=1 ${if(sx == 0,   "",   "and exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='" +sx+"')") }

group by AreaCode,AreaName,a.SupplierName,a.DeptCode

order by 1,4,3

