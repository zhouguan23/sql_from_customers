select * from 
[6001]A.TBORDERPROP

select a.DeptCode,a.CategoryCode,a.GoodsCode,a.GoodsName,a.BaseBarCode,a.WholeMeasureUnit,a.PurchTaxRate,b.SupplierCode,c.SupplierName,b.ContractNumber,b.PurchPrice,i.CirculationModeCode,a.WholePackRate,
case when len(j.GoodsCode)>0 then '1' else '0' end DirectSign,k.促销种类 昨日促销,l.促销种类 到货日促销,
isnull(sum(d.Amount),0)Amount,isnull(sum(e.Amount),0)WayAmount,isnull(sum(f.SaleAmount),0)SaleAmount from 
(select a.DeptCode,b.CategoryCode,a.GoodsCode,b.GoodsName,b.BaseBarCode,b.WholeMeasureUnit,b.PurchTaxRate ,b.WholePackRate from 
TB部门商品经营状态表 a ,
tb商品档案 b

where a.GoodsCode=b.GoodsCode and a.WorkStateCode in (1,2,5) and b.GoodsType='2' and b.CategoryCode like '${fl}%'
and a.DeptCode='${bm}')a
left join 
TB合同商品部门对照 b on a.DeptCode=b.DeptCode and a.GoodsCode=b.goodscode  and b.ContractNumber = (select max(ContractNumber) from TB合同商品部门对照 z where b.DeptCode=z.DeptCode and b.GoodsCode=z.GoodsCode)
left join 
TB供应商档案 c on b.SupplierCode=c.SupplierCode
left join 
tbStocks d on a.DeptCode=d.CounterCode and a.GoodsCode=d.GoodsCode
left join 
tbWayArrivalannual e on a.DeptCode=e.DeptCode and a.GoodsCode=e.GoodsCode
left join 
(select nodecode,goodscode,sum(SaleAmount)SaleAmount from
tb${=FORMAT(TODAY()-1,"yyyyMM")}_GoodsDayPSSM 
where occurdate= CONVERT(varchar(100),dateadd(DD,-1,getdate()),112)
group by nodecode,goodscode
) f on a.DeptCode=f.NodeCode and a.GoodsCode=f.GoodsCode


left join 
TB部门商品流转途径表 i on a.DeptCode=i.DeptCode and a.GoodsCode=i.GoodsCode
left join 

(select distinct NodeCode,goodscode  from 
(select NodeCode,goodscode from 
(select  DeptCatItemCode,b.CategoryCode,b.CategoryName,a.NodeCode from 
TBCATTODEPARTMENT a
left join
TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0001'
where  a.DeptCatItemCode ='0001' 	)a
left join 
(select * from 
TBDIRECTCONTROL
where DeptType ='0' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between BeginDate and EndDate)b on a.CategoryCode=b.DeptCode and a.DeptCatItemCode=b.CategoryItemCode
union all 
select deptcode,goodscode from 
TBDIRECTCONTROL  where DeptType ='1' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between BeginDate and EndDate)a)j on a.DeptCode=j.NodeCode and a.GoodsCode=j.GoodsCode
left join 
(select distinct  a.促销门店,a.商品编码,a.促销种类 from 
TB档期选品商品明细 a ,
master..spt_values b ,
TB商品档案 c 
where type='p'  and a.商品编码=c.GoodsCode and convert(varchar(10),dateadd(dd,-number,convert(varchar(8),dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0, CONVERT(varchar(100),dateadd(DD,0,getdate()),112) )+1, 0)),112)),112) between a.起始日期 and a.结束日期
and convert(varchar(10),dateadd(dd,-number,convert(varchar(8),dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0, CONVERT(varchar(100),dateadd(DD,0,getdate()),112) )+1, 0)),112)),112)= CONVERT(varchar(100),dateadd(DD,-1,getdate()),112) 
and c.CategoryCode like '1%') k on a.DeptCode=k.促销门店 and a.goodscode=k.商品编码
left join 
(select distinct  a.促销门店,a.商品编码,a.促销种类 from 
TB档期选品商品明细 a ,
master..spt_values b ,
TB商品档案 c 
where type='p'  and a.商品编码=c.GoodsCode and convert(varchar(10),dateadd(dd,-number,convert(varchar(8),dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0, CONVERT(varchar(100),dateadd(DD,2,getdate()),112) )+1, 0)),112)),112) between a.起始日期 and a.结束日期
and convert(varchar(10),dateadd(dd,-number,convert(varchar(8),dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0, CONVERT(varchar(100),dateadd(DD,0,getdate()),112) )+1, 0)),112)),112)= CONVERT(varchar(100),dateadd(DD,2,getdate()),112) and c.CategoryCode like '1%') l on a.DeptCode=l.促销门店 and a.goodscode=l.商品编码


group by a.DeptCode,a.CategoryCode,a.GoodsCode,a.GoodsName,a.BaseBarCode,a.WholeMeasureUnit,a.PurchTaxRate,b.SupplierCode,c.SupplierName,b.ContractNumber,b.PurchPrice,i.CirculationModeCode,WholePackRate,case when len(j.GoodsCode)>0 then '1' else '0' end ,
k.促销种类,l.促销种类
order by 19 desc 



select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,2) between 10 and 14 
and CategoryLevel=2

select a.* from 
(select NodeCode,goodscode,DCCode from 
(select  DeptCatItemCode,b.CategoryCode,b.CategoryName,a.NodeCode from 
[6001]A.TBCATTODEPARTMENT a
left join
[6001]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0001'
where  a.DeptCatItemCode ='0001' 	)a
left join 
(select * from 
[6001]A.TBSKUDC 
where DeptType ='0' )b on a.CategoryCode=b.DeptCode and a.DeptCatItemCode=b.CategoryItemCode
union all 
select deptcode,goodscode,DCCode from 
[6001]A.TBSKUDC where DeptType ='1' )a,
[6001]A.tbgoods b 
where a.GoodsCode=b.goodscode and b.GoodsType='2'  and  a.nodecode='${bm}' and b.CategoryCode like '${fl}%'

select a.DeptCode,b.CategoryCode,a.GoodsCode,b.GoodsName,b.BaseBarCode,b.WholeMeasureUnit,b.PurchTaxRate ,b.WholePackRate from 
TB部门商品经营状态表 a ,
tb商品档案 b

where a.GoodsCode=b.GoodsCode and a.WorkStateCode in (1,2,5) and b.GoodsType='2' and b.CategoryCode like '${fl}%'
and a.DeptCode='${bm}'

select SpecialTypeCode,SpecialTypeCode+' '+replace(SpecialTypeName,'(生鲜)周促销商品','周促销') SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE

