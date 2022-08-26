select * from 
tb供应商实销月结
where OccurDate ='${YM}' 
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }
order by 1,2,3


