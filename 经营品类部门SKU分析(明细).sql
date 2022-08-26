select b.CategoryCode,a.DeptCode ,a.GoodsCode,b.GoodsName,b.BaseBarCode ,b.GoodsType,b.BuildDate,b.ProdArea,b.GoodsSpec,b.WholePackRate,b.PurchTaxRate,b.SaleTaxRate,b.Durability,b.GoodsLength,b.GoodsWidth,b.GoodsHeight
,d.SupplierCode
,case when e.PurchSign ='1' then '999999' when len(d.PurchPrice)>0  then d.PurchPrice else b.PurchPrice end PurchPrice
,case when e.CustomSign ='1' then '999999' when len(f.SalePrice)>0  then f.SalePrice else b.SalePrice end SalePrice
,a.WorkStateCode,c.CirculationModeCode
,case when len(g1.GoodsPropertyCode)>0 then '1' else 0 end 进口商品
,case when len(g2.GoodsPropertyCode)>0 then '1' else 0 end 烟酒专区
,case when len(g3.GoodsPropertyCode)>0 then '1' else 0 end 土特产
,case when len(g4.GoodsPropertyCode)>0 then '1' else 0 end 网红商品
,case when len(g5.GoodsPropertyCode)>0 then '1' else 0 end 生鲜优选
,case when len(h.GoodsCode)>0 then '1' else 0 end 中央控制
,case when len(i.GoodsCode)>0 then '1' else 0 end 直流控制
,case when len(J.GoodsCode)>0 then '1' else 0 end 退货控制
,case when len(gxsp.GoodsCode)>0 then '1' else 0 end 共性商品
,case when len(k.GoodsCode)>0 then k.PackRate else 1 end 最小订货量
  from 
[000]A .TBDEPTWORKSTATE   a
left join 
[000]A .tbGoods b on a.GoodsCode =b.GoodsCode 
left join 
[000]A .TBDEPTCIRCULATION c on a.DeptCode=c.DeptCode and a.GoodsCode=c.GoodsCode 
left join 
[000]A .tbDeptGoodsSupp d on a.DeptCode=d.DeptCode and a.GoodsCode=d.GoodsCode and d.ContractNumber in (select MAX(ContractNumber) from [000]A .tbDeptGoodsSupp z where d.DeptCode =z.DeptCode and d.GoodsCode =z.GoodsCode)
left join 
[000]A .TBCUSTOMPRICE e on a.DeptCode=e.DeptCode and a.GoodsCode=e.GoodsCode 
left join 
[000]A .TBDEPTSALEPRICE f on a.DeptCode=f.DeptCode and a.GoodsCode=f.GoodsCode
left join
[000]A .TBGOODSPROPINCLUSIONS g1 on a.goodscode=g1.goodscode and g1.GoodsPropertyCode='2001'
left join
[000]A .TBGOODSPROPINCLUSIONS g2 on a.goodscode=g2.goodscode and g2.GoodsPropertyCode='2002'
left join
[000]A .TBGOODSPROPINCLUSIONS g3 on a.goodscode=g3.goodscode and g3.GoodsPropertyCode='2003'
left join
[000]A .TBGOODSPROPINCLUSIONS g4 on a.goodscode=g4.goodscode and g4.GoodsPropertyCode='2004'
left join
[000]A .TBGOODSPROPINCLUSIONS g5 on a.goodscode=g5.goodscode and g5.GoodsPropertyCode='2005'
left join 
(select distinct deptcode,goodscode from 
(select deptcode,goodscode from 
(select  DeptCatItemCode,b.CategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0001'
where  a.DeptCatItemCode ='0001' 	)a
left join 
(select * from 
[000]A .TBCENTERCONTROL 
where DeptType ='0' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between BeginDate and BeginDate)b on a.CategoryCode=b.DeptCode and a.DeptCatItemCode=b.CategoryItemCode
union all 
select deptcode,goodscode from 
[000]A .TBCENTERCONTROL  where DeptType ='1' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between BeginDate and EndDate)a) h on a.DeptCode=h.DeptCode and a.GoodsCode=h.GoodsCode
left join 
(select distinct deptcode,goodscode from 
(select deptcode,goodscode from 
(select  DeptCatItemCode,b.CategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0001'
where  a.DeptCatItemCode ='0001' 	)a
left join 
(select * from 
[000]A .TBDIRECTCONTROL 
where DeptType ='0' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between BeginDate and BeginDate)b on a.CategoryCode=b.DeptCode and a.DeptCatItemCode=b.CategoryItemCode
union all 
select deptcode,goodscode from 
[000]A .TBDIRECTCONTROL  where DeptType ='1' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between BeginDate and EndDate)a) i on a.DeptCode=i.DeptCode and a.GoodsCode=i.GoodsCode
left join 
(select distinct deptcode,goodscode from 
(select deptcode,goodscode from 
(select  DeptCatItemCode,b.CategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0001'
where  a.DeptCatItemCode ='0001' 	)a
left join 
(select * from 
[000]A .TBRSKUPOLNO
where DeptType ='0' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between NBeginDate and NBeginDate)b on a.CategoryCode=b.DeptCode and a.DeptCatItemCode=b.CategoryItemCode
union all 
select deptcode,goodscode from 
[000]A .TBRSKUPOLNO  where DeptType ='1' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between NBeginDate and NEndDate)a) J on a.DeptCode=J.DeptCode and a.GoodsCode=J.GoodsCode
left join 
(select b.CategoryName,b.NodeCode,a.* from tbaowkxgoods a,
(select  b.CategoryCode,b.CategoryName,a.NodeCode from 
"000".TBCATTODEPARTMENT a
left join
"000".TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
where  a.DeptCatItemCode ='0011' and CategoryCode ='01')b
where a.zhcsku =1 and a.deletebz =1
union all 
select b.CategoryName,b.NodeCode,a.* from tbaowkxgoods a,
(select  b.CategoryCode,b.CategoryName,a.NodeCode from 
"000".TBCATTODEPARTMENT a
left join
"000".TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
where  a.DeptCatItemCode ='0011' and CategoryCode ='02')b
where a.bcsku  =1 and a.deletebz =1
union all 
select b.CategoryName,b.NodeCode,a.* from tbaowkxgoods a,
(select  b.CategoryCode,b.CategoryName,a.NodeCode from 
"000".TBCATTODEPARTMENT a
left join
"000".TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
where  a.DeptCatItemCode ='0011' and CategoryCode ='03')b
where a.dsqsku  =1 and a.deletebz =1
union all 
select b.CategoryName,b.NodeCode,a.* from tbaowkxgoods a,
(select  b.CategoryCode,b.CategoryName,a.NodeCode from 
"000".TBCATTODEPARTMENT a
left join
"000".TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
where  a.DeptCatItemCode ='0011' and CategoryCode ='06')b
where a.xsqsku =1 and a.deletebz =1
union all 
select b.CategoryName,b.NodeCode,a.* from tbaowkxgoods a,
(select  b.CategoryCode,b.CategoryName,a.NodeCode from 
"000".TBCATTODEPARTMENT a
left join
"000".TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
where  a.DeptCatItemCode ='0011' and CategoryCode ='07')b
where a.bldsu =1 and a.deletebz =1)  gxsp on a.goodscode=gxsp.goodscode and a.DeptCode=gxsp.NodeCode
left join 
(select distinct deptcode,goodscode,PackRate from 
(select deptcode,goodscode,PackRate from 
(select  DeptCatItemCode,b.CategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0001'
where  a.DeptCatItemCode ='0001' 	)a
left join 
(select * from 
[000]A .TBWRAPCONTROL
where DeptType ='0' and ControlArea='0' and ControlPass='2' )b on a.CategoryCode=b.DeptCode and a.DeptCatItemCode=b.CategoryItemCode
union all 
select deptcode,goodscode,PackRate from 
[000]A .TBWRAPCONTROL 
where DeptType ='1'and ControlArea='0' and ControlPass='2' )a) k on a.DeptCode=k.DeptCode and a.GoodsCode=k.GoodsCode
where a.GoodsCode =b.GoodsCode and   left(a.DeptCode,1) between 1 and 2  
and 1=1 ${if(len(fl2) == 0,  "",   "and left(b.CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(lx) == 0,   "",   "and b.GoodsType in ('" + replace(lx,",","','")+"')") }  and 1=1 ${if(len(lz) == 0,   "",   "and c.CirculationModeCode in ('" + replace(lz,",","','")+"')") }  
and 1=1 ${if(len(zt) == 0,   "",   "and a.WorkStateCode in ('" + replace(zt,",","','")+"')") }  
and 1=1 ${if(len(gys) == 0,   "",   "and d.SupplierCode in ('" + replace(gys,",","','")+"')") } 
and 1=1 ${if(len(jk) == 0,   "",   "and g1.GoodsPropertyCode ='2001'") }  
and 1=1 ${if(len(yj) == 0,   "",   "and g2.GoodsPropertyCode ='2002'") }  
and 1=1 ${if(len(tc) == 0,   "",   "and g3.GoodsPropertyCode ='2003'") }  
and 1=1 ${if(len(wh) == 0,   "",   "and g4.GoodsPropertyCode ='2004'") }  
and 1=1 ${if(len(sx) == 0,   "",   "and g5.GoodsPropertyCode ='2005'") }  
and 1=1 ${if(len(zykz) == 0, "",   "and len(h.GoodsCode)>0") }  
and 1=1 ${if(len(thkz) == 0, "",   "and len(j.GoodsCode)>0") }  
and 1=1 ${if(len(gxkz) == 0, "",   "and len(gxsp.GoodsCode)>0") }  

order by 1,2,3

select * from tbStocks

where  1=1 ${if(len(bm) == 0,   "",   "and CounterCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl2) == 0,   "",   "and left(goodscode,2) in ('" + replace(fl2,",","','")+"')") }

select ParentCategoryCode,CategoryCode,CategoryCode+' '+CategoryName CategoryName  from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and ( CategoryCode like '1%' or CategoryCode like '2%' or CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%') and CategoryLevel<=2

