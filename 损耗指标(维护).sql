select * from tb损耗指标
where 1=1 ${if(len(bm) == 0,   "",   "and nodecode  in ('" + replace(bm,",","','")+"')") }

