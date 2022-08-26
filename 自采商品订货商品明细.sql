
select a.*,c.SupplierName from 
TB自采商品订货表 a 
left join 
TB商品档案 b on a.goodscode=b.GoodsCode
left join 
tb供应商档案 c on a.suppcode=c.SupplierCode

where a.BillNumber='${dj}'
order by 1,2,4,13,14


select distinct a.SupplierCode,a.SupplierCode+' '+b.SupplierName SupplierName from
TB合同商品部门对照 a
left join 
TB供应商档案 b on a.SupplierCode=b.SupplierCode --取供应商名称
where exists (select * from  TBGOODSPROPINCLUSIONS c where a.GoodsCode=c.GoodsCode and c.GoodsPropertyCode='2008')
and exists(select * from tb商品档案 d where a.goodscode=d.goodscode 
and 1=1 ${if(len(fl) == 0,   "",   "and left(d.CategoryCode,2) in ('" + replace(fl,",","','")+"')")})
and 1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode in ('" + replace(bm,",","','")+"')")}
and a.ContractNumber in (select max(z.ContractNumber) from TB合同商品部门对照 z where a.DeptCode=z.DeptCode and a.GoodsCode=z.GoodsCode ) 
order by 1

