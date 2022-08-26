
select 
 SupplierName,a.DeptCode,a.BuildDate,a.LastPerformDate,
a.BillNumber,a.GoodsCode,goodsname,a.GoodsBarCode,WorkStateCode,ControlType
,a.SalePrice,a.LastPurchPrice,a.DMSNormal,a.DMSProm
,a.SaleAmount7,a.SaleAmount30,a.Amount,a.PurchMoney,
a.PerformAmount,a.PerformMoney from 
tb${YM}_SupplierShortage a

where  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.PerformAmount else a.PerformMoney end <  case when CategoryCode not like '1%' or CategoryCode not like '2%' then a.Amount else a.PurchMoney end and LEFT(BuildDate,8)  <='${rq}' 
and CategoryCode  not like '0%' and CategoryCode  not like '6%' and CategoryCode  not like '300%'
and  1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(fl2) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
and  1=1 ${if(len(gys) == 0,   "",   "and left(a.SupplierName,7) in ('" + replace(gys,",","','")+"')") }
and  1=1 ${if(sx == 0,   "",   "and exists  ( select * from TBGOODSPROPINCLUSIONS b where a.goodscode=b.goodscode and b.GoodsPropertyCode='" +sx+"')") }
order by 1,5,6,2

select DeptCode ,GoodsCode  from 
[6001]A.TBCENTERCONTROL 
where convert(varchar(8),dateadd(mm,0,GETDATE()),112) between BeginDate and EndDate
and goodscode not like '300%'
and ControlType=1 and DeptType  =1  and  1=1 ${if(len(bm) == 0,   "",   "and DeptCode in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(fl2) == 0,   "",   "and left(goodscode,2) in ('" + replace(fl2,",","','")+"')") }

