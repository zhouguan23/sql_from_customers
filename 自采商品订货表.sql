select a.GoodsCode,a.GoodsName,a.BaseBarCode,a.GoodsSpec,a.BaseMeasureUnit,a.WholePackRate,a.DeptCode,a.WorkStateCode,a.SupplierCode,a.SupplierName,a.PurchPrice,a.PackRate ,
sum(DAY30_SaleAmount)DAY30_SaleAmount,sum(DAY)DAY,sum(KC_Amount)KC_Amount
from
(SELECT  a.GoodsCode,b.GoodsName,b.BaseBarCode,b.GoodsSpec,b.BaseMeasureUnit,b.WholePackRate,c.DeptCode,c.WorkStateCode,d.SupplierCode,e.SupplierName,d.PurchPrice,
isnull(f.PackRate,1)PackRate,isnull(g.SaleAmount,0)-isnull(j.SaleAmount,0) DAY30_SaleAmount,isnull( h.Day,0)DAY ,isnull(I.StartAmount+I.PurchAmount+ I.RedeployinAmount+ I.ProfitAmount+ I.CountProfitAmount  - I.SaleAmount    - I.RedeployoutAmount  - I.LossAmount  -I.CountLossAmount  -I.ToGiftAmount,0)KC_Amount  FROM 
TBGOODSPROPINCLUSIONS a --取值自采商品清单
left join 
TB商品档案 b on a.GoodsCode=b.GoodsCode --关联商品名称等信息
left join 
TB部门商品经营状态表 c on a.GoodsCode=c.GoodsCode --取自采商品在为1、2、5状态的门店
left join 
TB合同商品部门对照 d on c.GoodsCode=d.GoodsCode and c.DeptCode=d.DeptCode  and d.ContractNumber in (select max(z.ContractNumber) from TB合同商品部门对照 z where d.DeptCode=z.DeptCode and d.GoodsCode=z.GoodsCode )  --取自采商品供应商、进价
left join
TB供应商档案 e on d.SupplierCode=e.SupplierCode --取供应商名称
left join 
(select b.NodeCode,a.GoodsCode,a.PackRate from 
TBWRAPCONTROL a
left join 
TBCATTODEPARTMENT b on b.DeptCatItemCode='0001' and a.DeptCode=b.DeptCategoryCode
where DeptType='0'
union all 
select DeptCode NodeCode,a.GoodsCode,a.PackRate from 
TBWRAPCONTROL a

where DeptType='1'
union all 
select NodeCode,a.GoodsCode,a.PackRate from 
TBWRAPCONTROL a
left join 
TBCATTODEPARTMENT b on b.DeptCatItemCode='0001' 
where DeptType='2') f on c.DeptCode=f.NodeCode and c.GoodsCode=f.GoodsCode --取自采商品各门店最小订货数
left join 
(select NodeCode,GoodsCode,sum(SaleAmount)SaleAmount from tb${ym}_GoodsDayPSSM where OccurDate between convert(varchar(8),getdate()-30,112) and convert(varchar(8),getdate()-1,112) group by NodeCode,GoodsCode) g on  c.DeptCode=g.NodeCode and c.GoodsCode=g.GoodsCode   --取自采商品前30天销售 
left join 
(select Deptcode,GoodsCode,count(StockDate)DAY  from tb${ym}_DAYStocks h where Amount>0 and  StockDate between convert(varchar(8),getdate()-30,112) and convert(varchar(8),getdate()-1,112) group by Deptcode,GoodsCode)h   on  c.DeptCode=h.DeptCode and c.GoodsCode=h.GoodsCode     --取自采商品有库存天数
left join 
tb${ym}_GoodsMONPSSM  i on   c.DeptCode=i.NodeCode and c.GoodsCode=i.GoodsCode --取当前库存
left join 
(select DeptCode,GoodsCode,sum(SaleAmount)SaleAmount from TB${ym}_门店促销数据 where AccDate between convert(varchar(8),getdate()-30,112) and convert(varchar(8),getdate()-1,112)group by DeptCode,GoodsCode)j on  c.DeptCode=j.DeptCode and c.GoodsCode=j.GoodsCode     --取自促销销售

where GoodsPropertyCode='2008' AND c.WorkStateCode in ('1','2','5') 
and left(C.DeptCode,1) between 1 and 2
and 1=1 ${if(len(bm) == 0,   "",   "and C.DeptCode in ('" + replace(bm,",","','")+"')")}
and 1=1 ${if(len(gys) == 0,   "",   "and d.SupplierCode in ('" + replace(gys,",","','")+"')")}
and 1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl,",","','")+"')")}

union all 
SELECT  a.GoodsCode,b.GoodsName,b.BaseBarCode,b.GoodsSpec,b.BaseMeasureUnit,b.WholePackRate,c.DeptCode,c.WorkStateCode,d.SupplierCode,e.SupplierName,d.PurchPrice,
isnull(f.PackRate,1)PackRate,isnull(g.SaleAmount,0)-isnull(j.SaleAmount,0) DAY30_SaleAmount,isnull(h.Day,0)DAY ,0 KC_Amount  FROM 
TBGOODSPROPINCLUSIONS a --取值自采商品清单
left join 
TB商品档案 b on a.GoodsCode=b.GoodsCode --关联商品名称等信息
left join 
TB部门商品经营状态表 c on a.GoodsCode=c.GoodsCode --取自采商品在为1、2、5状态的门店
left join 
TB合同商品部门对照 d on c.GoodsCode=d.GoodsCode and c.DeptCode=d.DeptCode and d.ContractNumber in (select max(z.ContractNumber) from TB合同商品部门对照 z where d.DeptCode=z.DeptCode and d.GoodsCode=z.GoodsCode )   -- 取自采商品供应商、进价
left join
TB供应商档案 e on d.SupplierCode=e.SupplierCode  --取供应商名称
left join 
(select b.NodeCode,a.GoodsCode,a.PackRate from 
TBWRAPCONTROL a
left join 
TBCATTODEPARTMENT b on b.DeptCatItemCode='0001' and a.DeptCode=b.DeptCategoryCode
where DeptType='0'
union all 
select DeptCode NodeCode,a.GoodsCode,a.PackRate from 
TBWRAPCONTROL a

where DeptType='1'
union all 
select NodeCode,a.GoodsCode,a.PackRate from 
TBWRAPCONTROL a
left join 
TBCATTODEPARTMENT b on b.DeptCatItemCode='0001' 
where DeptType='2') f on c.DeptCode=f.NodeCode and c.GoodsCode=f.GoodsCode --取自采商品各门店最小订货数
left join 
(select NodeCode,GoodsCode,sum(SaleAmount)SaleAmount from tb${syym}_GoodsDayPSSM where OccurDate between convert(varchar(8),getdate()-30,112) and convert(varchar(8),getdate()-1,112) group by NodeCode,GoodsCode) g on  c.DeptCode=g.NodeCode and c.GoodsCode=g.GoodsCode   --取自采商品前30天销售 
left join 
(select Deptcode,GoodsCode,count(StockDate)DAY  from tb${syym}_DAYStocks h where Amount>0 and  StockDate between convert(varchar(8),getdate()-30,112) and convert(varchar(8),getdate()-1,112) group by Deptcode,GoodsCode)h   on  c.DeptCode=h.DeptCode and c.GoodsCode=h.GoodsCode     --取自采商品有库存天数
left join 
(select DeptCode,GoodsCode,sum(SaleAmount)SaleAmount from TB${syym}_门店促销数据 where AccDate between convert(varchar(8),getdate()-30,112) and convert(varchar(8),getdate()-1,112)group by DeptCode,GoodsCode)j on  c.DeptCode=j.DeptCode and c.GoodsCode=j.GoodsCode     --取自促销销售
where GoodsPropertyCode='2008' AND c.WorkStateCode in ('1','2','5') 
and left(C.DeptCode,1) between 1 and 2
and 1=1 ${if(len(bm) == 0,   "",   "and C.DeptCode in ('" + replace(bm,",","','")+"')")}
and 1=1 ${if(len(gys) == 0,   "",   "and d.SupplierCode in ('" + replace(gys,",","','")+"')")}
and 1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl,",","','")+"')")}
)a

group by a.GoodsCode,a.GoodsName,a.BaseBarCode,a.GoodsSpec,a.BaseMeasureUnit,a.WholePackRate,a.DeptCode,a.WorkStateCode,a.SupplierCode,a.SupplierName,a.PurchPrice,a.PackRate
ORDER BY 9,1,7



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

