SELECT * FROM 
TB分类对照表 
where CategoryItemCode='${lx}'  and CategoryLengCode='${fl}'

SELECT * FROM 
TB分类对照表 
where CategoryItemCode='${lx}'  

SELECT * FROM 
TBCATTOGOODS
where CategoryItemCode='${lx}' 

SELECT * FROM 
TBCATTOdept
where CategoryItemCode='${lx}' 

SELECT a.CategoryCode,a.CategoryName,a.ParentCategoryCode,a.CategoryLevel,count(b.CategoryCode)SKU FROM 
TB分类对照表  a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode =b.ParentCategoryCode and a.CategoryLevel=b.CategoryLevel-1
where a.CategoryItemCode='0002' and a.CategoryName not like '编码' 
group by a.CategoryCode,a.CategoryName,a.ParentCategoryCode,a.CategoryLevel

SELECT * FROM 
tbCatToOperator
where CategoryItemCode='${lx}' 

select distinct 部门编码,部门名称 from 
tb职员用户表
order by 1

SELECT * FROM 
TBCATNotTOGOODS
where CategoryItemCode='${lx}' 

SELECT * FROM 
tbCatToDeptLeader
where CategoryItemCode='${lx}' 

select distinct 职位编码,部门名称+' '+职位名称 职位名称 from 
tb职员用户表
order by 1

select distinct 职员编码,职员名称 from 
tb职员用户表
where 部门长编码='00!01!0121!012105'
order by 1

