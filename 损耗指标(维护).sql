select * from tbæèææ 
where 1=1 ${if(len(bm) == 0,   "",   "and nodecode  in ('" + replace(bm,",","','")+"')") }

