select a.NodeCode,c.NodeName,a.DeptCategoryCode,b.CategoryName from 
[000]A .TBCATTODEPARTMENT a 
left join 
[000]A .TBDEPTCATEGORY b on b.CategoryItemCode='0008' and a.DeptCategoryCode=b.CategoryCode
left join 
[000]A .tbNode c on a.NodeCode =c.NodeCode 
where DeptCatItemCode='0008' and a.NodeCode in (select NodeCode  from 
[000]A .TBDEPARTMENT
where State='0' )


select DeptCode,SupplierCode,ERCode,BeginDate+' '+EndDate Date,BeginDate,EndDate,RecvMoneyType,Money,Pic,Remark from 
TBEXHRES
where  1=1 ${if(len(bm)==0,"","and DeptCode in ('"+replace(bm,",","','")+"')")} 

select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}


