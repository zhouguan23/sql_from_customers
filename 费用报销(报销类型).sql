
SELECT a.categorycode ,a.CategoryName,b.categorycode KM_categorycode,b.CategoryName KM_CategoryName
FROM TB费用科目表 a
left join 
TB费用科目表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.ParentCategoryCode
where  a.CategoryLevel='1' and a.CategoryItemCode ='0003'and a.Parentcategorycode='${lx}'

