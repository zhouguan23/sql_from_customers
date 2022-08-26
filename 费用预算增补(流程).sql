SELECT 总部门 FROM 部门

select * from 
tb职员用户表

select FNumber,FName_L2 from 
T_ORG_Admin
where FIsSealUp='0' and  FNumber like '${=E4}%'
order by 1



select CategoryItemCode,CategoryCode,CategoryCode+' '+CategoryName CategoryName,Controllable,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode,CategoryLevel  from 
TB费用科目表
where  CategoryLevel='1' and CategoryItemCode ='0000' 
order by 1,6,5,cast(CategoryCode as int)






select case when rank()  over(order by CategoryLevel)=1 then '' else  ParentCategoryCode end  F_ID,CategoryCode ID,CategoryCode, CategoryCode+' '+CategoryName  CategoryName,ParentCategoryCode,CategoryLevel,CategoryLengCode from
TB分类对照表 a 

where a.CategoryItemCode='0003'  and a.CategoryLevel>=0
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)

SELECT * FROM 
tb报销单据附件表

select CategoryItemCode,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel,Controllable,FlowCode from 
TB费用科目表
where  CategoryLevel='1' and CategoryItemCode ='0003'
order by 1,6,5,cast(CategoryCode as int)






select * from 
TB费用科目表
where  CategoryLevel='0' and CategoryItemCode ='0003'
order by 1,6,5,cast(CategoryCode as int)






select CategoryCode,CategoryCode+' '+CategoryName CategoryName,case when ParentCategoryCode='0000' then '' else ParentCategoryCode end ParentCategoryCode
 from TB费用科目表 
where  CategoryLevel>='0' and CategoryItemCode ='0000' 
order by CategoryLevel


 if not exists(select 1 from TB部门费用预算增补单  WHERE BillNumber = '${requestid}')
 select '${requestid}'BillNumber,CONVERT(varchar(8),GETDATE(),112)BuildDate,CONVERT(varchar(6),GETDATE(),112)BuildYM,
 c.CategoryCode [BuildDeptCode]A,职员编码 BuildManCode,职员名称 BuildManName,a.职位名称 BuildEmpLoyment,
 null ConsumeDate,null ConsumeYM,null ConsumeDeptCode,null [ConsumeManCode]A,null [ConsumeManName]A,null [ConsumeEmployment]A,
 '1' [InsideID]A,null [CategoryCode]A,'0003' [CategoryItemCode]A,'0' [BudgetType]A,c.CategoryCode [DeptCode]A,NULL [YM]A,0 [Salesindex]A,'0' [State]A,NULL [Remark]A
 from 
 tb职员用户表 a 
 left join 
 [tbCatToOperator]A b on a.部门编码=b.OperatorCode and b.CategoryItemCode='0003' and  b.OperatorCode=b.CategoryCode
 left join 
 TB分类对照表 c on b.CategoryCode=c.CategoryCode and c.CategoryItemCode='0003'
 where 职员编码='${gh}'
 else 

 select * from 
TB部门费用预算增补单 a 
WHERE a.BillNumber = '${requestid}'
order by InsideID

