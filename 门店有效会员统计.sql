select a.OccurDate,a.NodeCode,a.CategoryItemCode,a.Number,ISNULL(b.Number,0)TQNumber,isnull(Plannedvalue,0)Plannedvalue from 
TB门店有效会员 a 
left join 
TB门店有效会员 b on a.nodecode=b.nodecode and a.CategoryItemCode=b.CategoryItemCode and b.OccurDate='${TQYM}'
left join 
TB门店有效会员指标  c on a.nodecode=c.nodecode and a.CategoryItemCode=c.CategoryItemCode and c.OccurDate=a.OccurDate
where a.OccurDate='${YM}' and left(a.nodecode,1) in (1,2) 

