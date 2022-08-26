SELECT 总部门 FROM 部门

select * from 
tb职员用户表

select FNumber,FName_L2 from 
T_ORG_Admin
where FIsSealUp='0' and  FNumber like '${=E4}%'
order by 1



select CategoryItemCode,CategoryCode,CategoryName CategoryName,Controllable,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode,CategoryLevel  from 
TB费用科目表
where  CategoryLevel='1' and CategoryItemCode ='0000' 
order by 1,6,5,cast(CategoryCode as int)





select ParentCategoryCode F_ID,CategoryCode ID,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel from 
TB分类对照表 a
where a.CategoryItemCode='0003' and CategoryLevel between 1 and 2

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






select * from 
[TB费用报销单]A a 
WHERE a.BillNumber = '${djh}'



