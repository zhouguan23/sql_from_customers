select b.ColonyCode,b.ColonyName,a.CategoryCode,a.goodscode,a.GoodsName,a.ProdArea,a.GoodsSpec,a.BaseMeasureUnit,a.BaseBarCode,a.IsMust from 

(select distinct ColonyCode,ColonyName from 
TB部门信息表 A 
where  (A.NodeCode LIKE '1%' OR A.NodeCode LIKE '2%') AND A.State!=2 and len(ColonyCode)!=0) b 
left join 

(select a.DeptCode,left(b.CategoryCode,2)CategoryCode,a.goodscode,b.GoodsName,b.ProdArea,b.GoodsSpec,b.BaseMeasureUnit,b.BaseBarCode,a.IsMust  from 
TBNecessaryProducts a 
left join 
TB商品档案 b on a.GoodsCode=b.GoodsCode
where DeptType='0' AND A.CategoryItemCode='0008' and  1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(sp) == 0,   "",   "and a.goodscode in ('" + replace(sp,",","','")+"')") }
)a on  b.ColonyCode=a.DeptCode 


order by 1,3,4


