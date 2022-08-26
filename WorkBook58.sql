 select  zb.DeptCode ,zb.BuildDate,zb.SaleTime,zb.BillNumber,hy.CardCode,sum(zb.SaleEarning)SaleEarning,sum(zb.SaleMoney)SaleMoney,
 zffs.PaymentModeCode,zffs.PaymentMoney 
 from(
 
 select zb.DeptCode ,zb.BuildDate,zb.SaleTime,zb.BillNumber,sum(cb.SaleEarning)SaleEarning,sum(cb.SaleMoney)SaleMoney 
 from .tb202001_SaleBill zb,
  (select DeptCode,BillNumber,sum(SaleEarning)SaleEarning,sum(SaleEarning+SaleTax)SaleMoney from .tb202001_SALEBILLDETAIL 
 group by DeptCode,BillNumber
   union all 
   select DeptCode,BillNumber,sum(SaleEarning)SaleEarning,sum(SaleEarning+SaleTax)SaleMoney from .tb202001_SALERENTDETAIL
 group by DeptCode,BillNumber)cb
   where  zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode 
   and  zb.IsOutRule ='0'   and zb.BuildDate between '20200101' and '20200110'
   group by zb.DeptCode ,zb.BuildDate,zb.BillNumber ,zb.SaleTime
   )zb

   left join 
   tb202001_CARDTRADINGDETAILS  hy on zb.BillNumber=hy.BillNumber and zb.DeptCode=hy.DepartmentCode and hy.IntegralValue>0
   left join 
   tb202001_SALEPAYMENTDETAIL zffs on zb.BillNumber=zffs.BillNumber and zb.DeptCode=zffs.DeptCode


  group by zb.DeptCode ,zb.BuildDate,zb.BillNumber,hy.CardCode,zffs.PaymentModeCode,zffs.PaymentMoney,zb.SaleTime
  order by 2

