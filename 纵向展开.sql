SELECT * FROM [销量]A where 地区 ='${地区}'

SELECT 销售员,sum(销量) as 销售总额 FROM 销量
group by 销售员

