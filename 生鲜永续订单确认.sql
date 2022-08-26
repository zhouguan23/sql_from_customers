select * from 
tbApplyBill

select c.SupplierCode,c.ContractNumber,a.goodscode,d.GoodsName,d.BaseBarCode,d.WholeMeasureUnit,d.PurchTaxRate,a.Amount,c.PurchPrice,a.Amount*c.PurchPrice PurchMoney,0 PurchTax,a.StoreAmount,WayAmount from 
tbApplyBill a
left join 
TB部门商品流转途径表 b on a.BuildDeptCode=b.DeptCode and a.goodscode =b.GoodsCode
left join 
TB合同商品部门对照 c on a.BuildDeptCode=c.DeptCode and a.goodscode=c.GoodsCode 
left join 
TB商品档案 d on a.GoodsCode=d.goodscode 
where b.CirculationModeCode='1'
and a.BillNumber='${dj}' and a.BuildDeptCode='${bm}' 

select c.SupplierCode,c.ContractNumber,a.goodscode,d.GoodsName,d.BaseBarCode,d.WholeMeasureUnit,d.PurchTaxRate,a.Amount,c.PurchPrice,a.Amount*c.PurchPrice PurchMoney,0 PurchTax,a.StoreAmount,WayAmount from 
tbApplyBill a
left join 
TB部门商品流转途径表 b on a.BuildDeptCode=b.DeptCode and a.goodscode =b.GoodsCode
left join 
TB合同商品部门对照 c on a.BuildDeptCode=c.DeptCode and a.goodscode=c.GoodsCode 
left join 
TB商品档案 d on a.GoodsCode=d.goodscode 
where b.CirculationModeCode='3'
and a.BillNumber='${dj}' and a.BuildDeptCode='${bm}' 

