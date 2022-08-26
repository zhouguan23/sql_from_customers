SELECT
     订单明细.产品ID as 订单明细_产品ID,
     YEAR(订单.订购日期) AS 订单_订购日期,
     订单.货主城市 AS 订单_货主城市,
     订单.货主地区 AS 订单_货主地区,
     sum(订单明细.单价*订单明细.数量*(1-订单明细.折扣)) as 营业额,
     sum(订单明细.进价*订单明细.数量) as 成本
FROM
     订单 订单 INNER JOIN 订单明细 订单明细 ON 订单.订单ID = 订单明细.订单ID
where year(订购日期) in (1996,1997)
group by YEAR(订单.订购日期),订单.货主城市,订单.货主地区,订单明细.产品ID

SELECT
     产品.产品名称 AS 产品_产品名称,
     产品.产品ID AS 产品_产品ID,
     类别.类别名称 AS 类别_类别名称
FROM
     产品 产品 INNER JOIN 类别 类别 ON 产品.类别ID = 类别.类别ID
     where 类别.类别ID<=3

