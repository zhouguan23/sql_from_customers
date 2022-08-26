 select a.DeptCode,a.SupplierCode,b.SupplierName,sum(SaleAmount)SaleAmount,
sum(a.SaleIncome)SaleIncome,sum(a.SaleTax)SaleTax,sum(a.SaleIncome)+sum(a.SaleTax)SaleMoney,sum(a.AutoRebate)AutoRebate,sum(a.HandRebate)HandRebate from 
(select a.DeptCode,A.EnterAccountDate BuildDate,b.SupplierCode,b.goodscode
 ,SUM(SaleAmount)SaleAmount,SUM(SaleEarning)SaleIncome,SUM(SaleTax)SaleTax,SUM(AutoRebate)AutoRebate,sum(HandRebate)HandRebate,
 sum(SaleEarning) SaleGrossProfit,sum(SaleEarning+SaleTax) TAXSaleGrossProfit

 from 
"000" .tb${YM}_SALEBILL a,"000" .tb${YM}_SALERENTDETAIL b
where IsOutRule=0  and CancelFlag ='0' and A.BillNumber =B.BillNumber AND A.DeptCode =B.DeptCode  
group by  a.DeptCode,A.EnterAccountDate,b.SupplierCode,b.goodscode)a
left join 
"000" .TBSUPPLIER b on a.SupplierCode =b.SupplierCode
group by a.DeptCode,a.SupplierCode,b.SupplierName
 order by 1,3,4

