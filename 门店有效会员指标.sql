select a.YM,a.NodeCode,isnull(b.Plannedvalue,0)Plannedvalue from 
(select YM,a.NodeCode  from 
(select  b.NodeCode
from dbo.TB部门信息表 b 
where left(b.NodeCode,1) between 1 and 2)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b)a
    left join 
    TB门店有效会员指标 b on a.NodeCode=b.nodecode and a.YM=b.OccurDate and b.CategoryItemCode='0000'

