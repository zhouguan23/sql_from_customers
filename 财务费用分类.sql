select * from 
TB费用分类表
where    1=1 ${if(len(bm) == 0,   "",   "and CategoryItemCode in ('" + replace(bm,",","','")+"')") }
order by convert(int,CategoryCode)

