select
	A.ATTRI_MANAGE_REGION 区域,
	A.SHOP_NUM 店铺数,
	B.SUM_STOCK 总库存价值,
	E.REAL_AMOUNT/A.SHOP_NUM/TO_NUMBER(TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd'),'dd')
	--,'fm99'
	) 日店均,
	E.REAL_AMOUNT 月累计,
	E.REAL_QTY 累计销售数量,
	E.NUM 累计成交笔数,
	E.TRANS_AMOUNT 累计配送金额,
	E.ORGI_AMOUNT 累计原价金额
FROM
	-- 店铺数
	(SELECT 
		b.ATTRI_MANAGE_REGION,
		COUNT(1) AS SHOP_NUM
	FROM DIM_SHOP_DAY  a,DIM_S_SHOP  b
	WHERE CREATE_DATE = TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd'),'yyyy-mm-dd hh24:mi:ss')
	AND a.SUB_COMPANY_NAME NOT LIKE '%电商%'
	and a.ORG_CODE=b.ORG_CODE
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	${IF(LEN(brand)=0,"","AND a.BRAND_NAME_ALL ='"+brand+"'")}
	${IF(LEN(sub_company_name)=0,"","AND a.SUB_COMPANY_NAME ='"+sub_company_name+"'")}
	GROUP BY b.ATTRI_MANAGE_REGION) A,
	-- 区域总库存
	(SELECT 
		ATTRI_MANAGE_REGION,
		SUM(STOCK_AMOUNT) AS SUM_STOCK
	FROM FACT_STOCK_SUB_REGION
	WHERE  CREATE_DATE=TO_DATE('${ddate}','yyyy-mm-dd hh24:mi:ss') 
	AND 	SUB_COMPANY_NAME NOT LIKE '%电商%'
  AND (CURRENCY = '${currency}' 
  ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
  ${IF(LEN(brand)=0,"","AND BRAND_NAME ='"+brand+"'")}
  ${IF(LEN(sub_company_name)=0,"","AND SUB_COMPANY_NAME ='"+sub_company_name+"'")}
  GROUP BY ATTRI_MANAGE_REGION) B,
  -- 销售详细数据
  (SELECT
    ATTRI_MANAGE_REGION,
    SUM(REAL_QTY) AS REAL_QTY,
    SUM(REAL_AMOUNT) as REAL_AMOUNT,
    SUM(NUM) AS NUM,
    SUM(TRANS_AMOUNT) AS TRANS_AMOUNT,
    SUM(ORGI_AMOUNT) AS ORGI_AMOUNT
  FROM
    FACT_SALE_SUB_REGION
  WHERE CREATE_DATE >= TO_CHAR(TRUNC(TO_DATE('${ddate}','yyyy-mm-dd'),'mm'),'yyyy-mm-dd')
AND CREATE_DATE < TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd')+1,'yyyy-mm-dd')
AND  (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
  ${IF(LEN(brand)=0,"","AND BRAND_NAME ='"+brand+"'")}
  ${IF(LEN(sub_company_name)=0,"","AND SUB_COMPANY_NAME ='"+sub_company_name+"'")}
  GROUP BY ATTRI_MANAGE_REGION) E
WHERE A.ATTRI_MANAGE_REGION = B.ATTRI_MANAGE_REGION
AND A.ATTRI_MANAGE_REGION = E.ATTRI_MANAGE_REGION
order by 日店均 desc

select b.BRAND_NAME_ALL as BRAND_NAME from (
select BRAND_NAME from FILL_USER_BRAND  a,FR_T_USER b
where a.USER_ID=to_char(b.id)--,'fm9999999') 
${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} ) a,VBI_BRAND  b
where a.BRAND_NAME=b.BRAND_NAME 

-- 品牌，维度表

select 
  DISTINCT SUB_COMPANY_NAME 
from DIM_SHOP 
WHERE 
SUB_COMPANY_NAME NOT LIKE '%电商%'
${if(len(brand)==0,""," AND BRAND_NAME_ALL ='"+brand+"'")}
and SUB_COMPANY_NAME in
(
select SUB_COMPANY_NAME from FILL_USER_BRAND  a,FR_T_USER  b
where a.USER_ID=to_char(b.id) and b.username='${fr_username}'
)

-- 维度表，分公司

SELECT ATTRI_MANAGE_REGION,MANAGE_REGION_NAME
FROM DIM_SHOP
WHERE BRAND_NAME_ALL = '${brand}'
AND SUB_COMPANY_NAME = '${sub_company_name}'


-- 区域，维度表

SELECT DISTINCT CURRENCY FROM VBI_CURRENCY

-- 币种，维度表

SELECT 
		ATTRI_MANAGE_REGION,
		COUNT(1) AS SHOP_NUM
	FROM DIM_SHOP_DAY
	WHERE CREATE_DATE =TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd'),'yyyy-mm-dd hh24:mi:ss')
	AND SUB_COMPANY_NAME NOT LIKE '%电商%'
	${IF(LEN(brand)=0,"","AND BRAND_NAME_ALL ='"+brand+"'")}
	${IF(LEN(sub_company_name)=0,"","AND SUB_COMPANY_NAME ='"+sub_company_name+"'")}
	GROUP BY ATTRI_MANAGE_REGION


	-- 不使用

select A.*,B.BRAND_NAME_ALL,B.SUB_COMPANY_NAME,B.ATTRI_MANAGE_REGION,
		B.MANAGE_REGION_NAME
 from
(select CREATE_MONTH,ORG_CODE,sum(STOCK_AMOUNT) AS STOCK_AMOUNT,sum(TRANS_AMOUNT) AS TRANS_AMOUNT,decode(max(MONTH_DAY),0,'',sum(STOCK_AMOUNT)/max(MONTH_DAY)) AS A3,max(MONTH_DAY)
	from FACT_STOCK_SMALL_MONTH 
	where CREATE_MONTH= substr('${ddate}',1,7)
  	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
  AND SUBSTR(SMALL_CATE_CODE,1,2)<>'20'
  AND SUBSTR(SMALL_CATE_CODE,1,2)<>'21'
  AND SUBSTR(SMALL_CATE_CODE,1,2)<>'22'
  group by CREATE_MONTH,ORG_CODE) A,
 (select 
    ORG_CODE,
    BRAND_NAME_ALL,
    SUB_COMPANY_NAME,
    ATTRI_MANAGE_REGION,
    MANAGE_REGION_NAME
  from DIM_SHOP_DAY
  where CREATE_DATE =TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd'),'yyyy-mm-dd hh24:mi:ss')
  and SUB_COMPANY_NAME NOT LIKE '%电商%'
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	AND BRAND_NAME_ALL= '${brand}'
	--GROUP BY ORG_CODE 
	) B
WHERE A.ORG_CODE = B.ORG_CODE 

