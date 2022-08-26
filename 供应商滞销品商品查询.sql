select left(分类编码,2) 二级分类编码,部门编码,分类编码,商品编码,商品名称,商品条码,供应商,流转途径,最后进价,最后售价,经营状态,最后状态异动日,最后进货日,最后销货日,
datediff(day,case when len(a.最后销货日)=0 then  a.最后进货日 else a.最后销货日 end,报表日期)未销天数,b.UnSalaNotSellDay,正常DMS+促销DMS DMS,库存数量/case when (正常DMS+促销DMS)=0 then  0.1 else (正常DMS+促销DMS) end 可销天数,库存数量,含税库存成本  from 
dbo.TB${YM}_门店商品历史信息 a 
left join 
TB商品档案 c on a.商品编码=c.GoodsCode
left join 
TBREPORTPARADEFINE b on a.商品编码 like b.goodscode+'%' 
left join 

tb合同商品部门对照 d on a.部门编码 =d.deptcode and a.商品编码=d.goodscode and ContractNumber in (select max(ContractNumber) from tb合同商品部门对照 e where d.deptcode=e.deptcode and d.SupplierCode=e.SupplierCode and d.goodscode=e.goodscode)


where 报表日期=convert(varchar(8),dateadd(mm,0,'${rq}'),112)  and round(库存数量,1)>0 and (部门编码 like '1%' or 部门编码 like '2%')
and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like '1888' and a.部门编码=z.nodecode and a.商品编码=z.goodscode)
and 商品编码 not in ('302000011','302000026','302000160','302000161','302030035','302000159','302000177','302000324','302000076','302000084','302000323','302000348','302000349','302000003','302000012','302010001','303000007','303000008','303000009','303000010','303000011','303000013','303000016','303010001','303010003','303010008','303010013','303010014','303010015','303010016')
and 分类编码 not like '300%'
and left(分类编码,2) not in (23,28,29) and c.goodstype in(0,2)
and datediff(day,case when len(a.最后销货日)=0 then  a.最后进货日 else a.最后销货日 end,报表日期)>=b.UnSalaNotSellDay
and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and d.SupplierCode in ('" + replace(gys,",","','")+"')") }
and  1=1 ${if(len(fl2) == 0,   "",   "and left(分类编码,2) in ('" + replace(fl2,",","','")+"')") } 

select distinct deptcode,goodscode from 
(select '1'DeptType,a.NodeCode DeptCode,a.DeptCatItemCode CategoryItemCode,b.GoodsCode,b.ForbidSupplier,b.dCCode,b.NGoodsRefundTerm,b.NBeginDate,b.NEndDate,b.Remark,b.SubHQCode from 
(select  DeptCatItemCode,b.CategoryCode,b.CategoryName,a.NodeCode from 
[6001]A.TBCATTODEPARTMENT a
left join
[6001]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0001'
where  a.DeptCatItemCode ='0001' 	and  1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") })a
left join 
(select * from 
[6001]A.TBRSKUPOLNO 
where DeptType ='0' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between NBeginDate and NEndDate)b on a.CategoryCode=b.DeptCode and a.DeptCatItemCode=b.CategoryItemCode
union all 
select * from 
[6001]A.TBRSKUPOLNO where DeptType ='1' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between NBeginDate and NEndDate and  1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
)a

