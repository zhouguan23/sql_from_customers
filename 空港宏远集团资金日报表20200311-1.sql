SELECT 
	t.境内境外,
	t.公司名称,
	t.所属板块,
	t.公司可用余额,
	t.板块类型,
	t.公司简称,
	formmain_3391.field0003 AS 账户表账户编号,
	formmain_3391.field0001 AS 银行名称,
	formmain_3391.field0008 AS 账户币种,
	formmain_3391.field0028 AS 主表汇率,
	formmain_3391.field0050 AS 公司编号,
	formmain_3391.field0002 AS 期初金额,
	formmain_3391.field0004 AS 冻结金额,
	formmain_3282.field0001 AS 填报人,
	formmain_3282.field0002 AS 填报部门,
	formmain_3282.field0003 AS 记账日期,
	formmain_3282.field0006 AS 账户,
	formmain_3282.field0007 AS 币种,
	formmain_3282.field0008 AS 摘要,
	formmain_3282.field0009 AS 收支末类,
	formmain_3282.field0010 AS 收支类型,
	formmain_3282.field0011 AS 收支原币,
	formmain_3282.field0012 AS 汇率,
	formmain_3282.field0013 AS 人民币,
	formmain_3282.field0015 AS 预制记账,
	formmain_3282.field0016 AS 填报单号,
	formmain_3282.field0021 AS 填账表账户编号,
	formmain_3282.field0022 AS 付款方式,
	formmain_3282.field0023 AS 主表对主表,
	formmain_3282.field0024 AS 生成日期,
	formmain_3282.field0025 AS 填账表备注,
	formmain_3282.field0026 AS 参考余额,
	formmain_3282.field0027 AS 流水单有效性,
	formmain_3282.field0028 AS 收支大类,
	formmain_3282.field0029 AS 调拨单号,
	formmain_3282.field0030 AS 客商名称,
	formmain_3282.field0031 AS 记账月初日期,
	formmain_3282.field0033 AS 修改日期,
	formmain_3282.field0034 AS 填账表公司状态,
	formmain_3282.field0035 AS 账户状态,
	formmain_3282.field0045 AS 事业部
FROM
(
	SELECT
		formmain_3393.field0001 AS 境内境外,
		formmain_3393.field0002 AS 公司名称,
		formmain_3393.field0003 AS 所属板块,
		formmain_3393.field0004 AS 公司编号,
		formmain_3393.field0005 AS 公司可用余额,
		formmain_3393.field0007 AS 板块类型,
		formmain_3393.field0025 AS 公司状态,
		formmain_3393.field0026 AS 公司简称
	FROM
		formmain_3393
) t
INNER JOIN
formmain_3391 ON formmain_3391.field0050 = t.公司编号
LEFT JOIN
formmain_3282 ON formmain_3282.field0021 = formmain_3391.field0003
where 1=1 AND formmain_3282.field0027!='-2214852842734336358'
${if(len(记账日期) == 0,"","and formmain_3282.field0003 = '"+记账日期+"'")}
ORDER BY 记账日期

SELECT 
	t.境内境外,
	t.公司名称,
	t.所属板块,
	t.公司可用余额,
	t.板块类型,
	t.公司简称,
	formmain_3391.field0003 AS 账户表账户编号,
	formmain_3391.field0001 AS 银行名称,
	formmain_3391.field0008 AS 账户币种,
	formmain_3391.field0028 AS 主表汇率,
	formmain_3391.field0050 AS 公司编号,
	formmain_3391.field0002 AS 期初金额,
	formmain_3391.field0004 AS 冻结金额,
	formmain_3282.field0001 AS 填报人,
	formmain_3282.field0002 AS 填报部门,
	formmain_3282.field0003 AS 记账日期,
	formmain_3282.field0006 AS 账户,
	formmain_3282.field0007 AS 币种,
	formmain_3282.field0008 AS 摘要,
	formmain_3282.field0009 AS 收支末类,
	formmain_3282.field0010 AS 收支类型,
	formmain_3282.field0011 AS 收支原币,
	formmain_3282.field0012 AS 汇率,
	formmain_3282.field0013 AS 人民币,
	formmain_3282.field0015 AS 预制记账,
	formmain_3282.field0016 AS 填报单号,
	formmain_3282.field0021 AS 填账表账户编号,
	formmain_3282.field0022 AS 付款方式,
	formmain_3282.field0023 AS 主表对主表,
	formmain_3282.field0024 AS 生成日期,
	formmain_3282.field0025 AS 填账表备注,
	formmain_3282.field0026 AS 参考余额,
	formmain_3282.field0027 AS 流水单有效性,
	formmain_3282.field0028 AS 收支大类,
	formmain_3282.field0029 AS 调拨单号,
	formmain_3282.field0030 AS 客商名称,
	formmain_3282.field0031 AS 记账月初日期,
	formmain_3282.field0033 AS 修改日期,
	formmain_3282.field0034 AS 填账表公司状态,
	formmain_3282.field0035 AS 账户状态,
	formmain_3282.field0045 AS 事业部
FROM
(
	SELECT
		formmain_3393.field0001 AS 境内境外,
		formmain_3393.field0002 AS 公司名称,
		formmain_3393.field0003 AS 所属板块,
		formmain_3393.field0004 AS 公司编号,
		formmain_3393.field0005 AS 公司可用余额,
		formmain_3393.field0007 AS 板块类型,
		formmain_3393.field0025 AS 公司状态,
		formmain_3393.field0026 AS 公司简称
	FROM
		formmain_3393
) t
INNER JOIN
formmain_3391 ON formmain_3391.field0050 = t.公司编号
LEFT JOIN
formmain_3282 ON formmain_3282.field0021 = formmain_3391.field0003
where 1=1 and 板块类型='8511988683458956419' AND formmain_3282.field0027!='-2214852842734336358'
${if(len(记账月) == 0,"","and formmain_3282.field0003 >= '"+记账月+"'")}
ORDER BY 记账日期

SELECT 
	t.境内境外,
	t.公司名称,
	t.所属板块,
	t.公司可用余额,
	t.板块类型,
	t.公司简称,
	formmain_3391.field0003 AS 账户表账户编号,
	formmain_3391.field0029 AS 汇率编号,
	formmain_3391.field0001 AS 银行名称,
	formmain_3391.field0008 AS 账户币种,
	formmain_3391.field0028 AS 主表汇率,
	formmain_3391.field0050 AS 公司编号,
	formmain_3391.field0002 AS 期初金额,
	formmain_3391.field0004 AS 冻结金额,
	formmain_3282.field0001 AS 填报人,
	formmain_3282.field0002 AS 填报部门,
	formmain_3282.field0003 AS 记账日期,
	formmain_3282.field0006 AS 账户,
	formmain_3282.field0007 AS 币种,
	formmain_3282.field0008 AS 摘要,
	formmain_3282.field0009 AS 收支末类,
	formmain_3282.field0010 AS 收支类型,
	formmain_3282.field0011 AS 收支原币,
	formmain_3282.field0012 AS 汇率,
	formmain_3282.field0013 AS 人民币,
	formmain_3282.field0015 AS 预制记账,
	formmain_3282.field0016 AS 填报单号,
	formmain_3282.field0021 AS 填账表账户编号,
	formmain_3282.field0022 AS 付款方式,
	formmain_3282.field0023 AS 主表对主表,
	formmain_3282.field0024 AS 生成日期,
	formmain_3282.field0025 AS 填账表备注,
	formmain_3282.field0026 AS 参考余额,
	formmain_3282.field0027 AS 流水单有效性,
	formmain_3282.field0028 AS 收支大类,
	formmain_3282.field0029 AS 调拨单号,
	formmain_3282.field0030 AS 客商名称,
	formmain_3282.field0031 AS 记账月初日期,
	formmain_3282.field0033 AS 修改日期,
	formmain_3282.field0034 AS 填账表公司状态,
	formmain_3282.field0035 AS 账户状态,
	formmain_3282.field0045 AS 事业部
FROM
(
	SELECT
		formmain_3393.field0001 AS 境内境外,
		formmain_3393.field0002 AS 公司名称,
		formmain_3393.field0003 AS 所属板块,
		formmain_3393.field0004 AS 公司编号,
		formmain_3393.field0005 AS 公司可用余额,
		formmain_3393.field0007 AS 板块类型,
		formmain_3393.field0025 AS 公司状态,
		formmain_3393.field0026 AS 公司简称
	FROM
		formmain_3393
) t
INNER JOIN
formmain_3391 ON formmain_3391.field0050 = t.公司编号
LEFT JOIN
formmain_3282 ON formmain_3282.field0021 = formmain_3391.field0003
where 1=1 and 板块类型='8511988683458956419' AND formmain_3282.field0027!='-2214852842734336358'

ORDER BY 记账日期

SELECT field0001 AS 币种,	formmain_3276.field0003 AS '汇率编号',CONCAT(t.上月,'-01') AS 上月,t.汇率 AS 上月汇率,CONCAT(b.本月,'-01') AS 本月,b.汇率 as 本月汇率
FROM formmain_3276
JOIN
(SELECT 
formson_3515.formmain_id,
SHOWVALUE,field0005 AS 汇率,
CONCAT(LEFT(SHOWVALUE,4),'-',if(replace(REPLACE(SHOWVALUE,LEFT(SHOWVALUE,5),''),'月','')<10,concat('0',replace(REPLACE(SHOWVALUE,LEFT(SHOWVALUE,5),''),'月','')),replace(REPLACE(SHOWVALUE,LEFT(SHOWVALUE,5),''),'月',''))) AS 上月 
FROM formson_3515
JOIN
ctp_enum_item
ON formson_3515.field0004 = ctp_enum_item.id
HAVING date_format(date_sub(curdate(), interval 1 month),'%Y-%m') = 上月) t
ON formmain_3276.id = t.formmain_id
JOIN
(SELECT 
formson_3515.formmain_id,
SHOWVALUE,field0005 AS 汇率,
CONCAT(LEFT(SHOWVALUE,4),'-',if(replace(REPLACE(SHOWVALUE,LEFT(SHOWVALUE,5),''),'月','')<10,concat('0',replace(REPLACE(SHOWVALUE,LEFT(SHOWVALUE,5),''),'月','')),replace(REPLACE(SHOWVALUE,LEFT(SHOWVALUE,5),''),'月',''))) AS 本月 
FROM formson_3515
JOIN
ctp_enum_item
ON formson_3515.field0004 = ctp_enum_item.id
HAVING date_format(date_sub(curdate(), interval 0 month),'%Y-%m') = 本月) b
ON formmain_3276.id = b.formmain_id
where 1=1

SELECT field0001 AS 币种,field0002 AS 本月汇率
FROM formmain_3276

