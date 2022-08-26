
select  商品编码,商品名称,部门编码,商品条码,商品单位,经营状态,流转途径,供应商,最后进价,最后售价,库存数量,含税库存成本,正常DMS+促销DMS DMS,
库存数量/case when (正常DMS+促销DMS)=0 then  0.1 else (正常DMS+促销DMS) end 可销天数,ISNULL(b.HighStockCanSellDay,9999)高库存可销标准,
datediff(day,a.最后销货日,报表日期)未销天数,isnull(b.UnSalaNotSellDay,9999)滞销天数标准,最后销货日,最后进货日,最后状态异动日  from 
    dbo.TB${YM}_门店商品历史信息  a
    left join 
    TBREPORTPARADEFINE b on b.DeptCode ='' and 分类编码 like b.GoodsCode+'%'
	where 报表日期=convert(varchar(8),dateadd(mm,0,'${rq}'),112) and round(库存数量,2)>0 and  left(部门编码 ,1) between 1 and 2 
	and 经营状态 in (1,2,3,4,5,50)  and a.含税库存成本 >500 and a.库存数量>=3 
	
	and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in ('" + replace(bm,",","','")+"')") }
    and 1=1 ${if(len(fl2) == 0,   "",   "and left(分类编码,2) in ('" + replace(fl2,",","','")+"')") } 
	and 商品类型 in (0,2) and 	
	exists(select * from TBREPORTPARADEFINE b where  b.DeptCode ='' and left(a.分类编码,4)=b.GoodsCode
	 and a.库存数量/(case when (a.正常DMS+a.促销DMS)=0 then 0.01 else(a.正常DMS+a.促销DMS) end )>b.HighStockCanSellDay)
  
order by 1,10,3

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

