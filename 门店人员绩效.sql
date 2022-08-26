select a.fid 部门ID,a.FNumber 部门编码,case when right(a.FNumber,2)='00' then left(a.FNumber,4) else a.FNumber end DeptCode,a.FName_L2  部门名称,B.fid 职位ID,b.FNumber  职位编码,b.FName_L2 职位名称,c.FID 员工ID,c.FNumber 员工编码,c.FName_L2 用户名称,c.FCell 手机号,c.FIDCardNO 

身份证号码 from 
T_ORG_Admin a
left join 
T_ORG_Position b on a.fid =b.FAdminOrgUnitID
left join 
(select a.fid,FPersonDep,FPrimaryPositionID,c.FName_L2 state,a.FNumber ,a.FName_L2,FCell,FIDCardNO from 
T_BD_Person a
left join 
T_HR_PersonPosition b on a.FID =b.FPersonID
left join 
(select a.* from 
T_HR_BDEmployeeType a
left join 
T_BD_EmployeeModle b on a.FEmployeeModleID=b.fid
where b.FName_l2 ='在职') c on a.FEmployeeTypeID=c.FID 
where a.FEmployeeTypeID=c.FID 

) c on a.FID =c.FPersonDep and b.FID=c.FPrimaryPositionID 

where a.FLongNumber like '00!02!%' and a.FNumber like '${bm}'+'%' and a.FNumber not like '%99' and a.FIsSealUp='0' and b.FDeletedStatus='1'
order by 2,6

select left(happenYM,4)FPERIODYEAR,right(happenYM,2)FPERIODMONTH,a.deptcode+''+c.shrCategoryCode deptcode,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,
sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross
 from 
TB门店绩效表  a 
left join 
TB部门信息表  B on a.DeptCode=B.NodeCode 
left join 
tbshr部门分类对照 c on B.FormatCode=c.deptcode and a.CategoryItemCode=c.CategoryItemCode and a.CategoryCode=c.CategoryCode
where HappenYM ='${YM}'  and a.CategoryItemCode='0000' 
and c.shrCategoryCode is not null  and a.CategoryLevel<='2'
group by left(happenYM,4),right(happenYM,2),a.deptcode,a.CategoryCode ,c.shrCategoryCode

union all 


select left(happenYM,4)FPERIODYEAR,right(happenYM,2)FPERIODMONTH,a.deptcode+''+c.shrCategoryCode deptcode,
sum(AfterTAXSaleindex)AfterTAXSaleindex, sum(AfterTAXSaleMoney)AfterTAXSaleMoney,
sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross
 from 
TB门店绩效表  a 
left join 
TB部门信息表  B on a.DeptCode=B.NodeCode 
left join 
tbshr部门分类对照 c on B.FormatCode=c.deptcode and a.CategoryItemCode=c.CategoryItemCode 
where HappenYM ='${YM}'  and a.CategoryItemCode='0001' and a.CategoryLevel='1'
and c.shrCategoryCode is not null 
group by left(happenYM,4),right(happenYM,2),a.deptcode,c.shrCategoryCode

