SELECT * FROM 
tb费用科目表  a
where CategoryItemCode='${lx}'  and convert(varchar(12),CategoryCode)+'.'+CategoryName='${fl}'
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)

SELECT * FROM 
tb费用科目表 a
where CategoryItemCode='${lx}'  
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)

SELECT CategoryItemCode,CategoryCode,CategoryCode+''+CategoryName CategoryName,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode ,CategoryLevel FROM 
tb费用科目表 a
where CategoryItemCode='0003'   and CategoryLevel = '1' and ParentCategoryCode='0'
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)

SELECT * FROM 
tb费用科目表
where CategoryItemCode='${lx}' and CategoryLevel='3'

SELECT a.CategoryCode,a.CategoryName,a.ParentCategoryCode,a.CategoryLevel,count(b.CategoryCode)SKU FROM 
TB分类对照表  a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode =b.ParentCategoryCode and a.CategoryLevel=b.CategoryLevel-1
where a.CategoryItemCode='0002' and a.CategoryName not like '编码' 
group by a.CategoryCode,a.CategoryName,a.ParentCategoryCode,a.CategoryLevel

SELECT CategoryItemCode,CategoryCode,CategoryCode+''+CategoryName CategoryName,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode ,CategoryLevel FROM 
tb费用科目表 a
where CategoryItemCode='0003'   and CategoryLevel = '1' and ParentCategoryCode='1'
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)

SELECT CategoryItemCode,CategoryCode,CategoryCode+''+CategoryName CategoryName,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode ,CategoryLevel FROM 
tb费用科目表 a
where CategoryItemCode='0003'   and ParentCategoryCode like '1%'
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)

SELECT CategoryItemCode,CategoryCode,CategoryCode+''+CategoryName CategoryName,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode ,CategoryLevel FROM 
tb费用科目表 a
where CategoryItemCode='0003'   and ParentCategoryCode like '0%'
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)

