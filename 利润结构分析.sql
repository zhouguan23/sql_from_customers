SELECT 类别,sum(本期) as 本期金额 FROM 利润分析
group by 类别

SELECT 小类,sum(本期) as 本期金额 FROM 利润分析
where 类别='${leibie}'
group by 小类


SELECT * FROM 利润分析 where 1=1
 ${if(len(leibie) == 0,"","and 类别 = '" + leibie + "'")}
 ${if(len(pj) == 0,"","and 小类 = '" + pj + "'")}

SELECT * FROM 利润分析 where 类别='收入'

SELECT * FROM 利润分析 where 类别='支出'

