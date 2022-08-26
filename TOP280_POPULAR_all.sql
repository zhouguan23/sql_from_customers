
select distinct 
  b.BRAND_NAME as BRAND_NAME 
from 
(
  select 
    BRAND_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) 
  ${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} )  a,VBI_BRAND  b
where a.BRAND_NAME=b.BRAND_NAME 
-- 品牌维度




select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}

-- 分公司维度

SELECT DISTINCT REGULAR_CODE,REGULAR_NAME FROM DIM_ITEM 
ORDER BY REGULAR_CODE

SELECT WEEK_ALL,MIN(DAY_ID) AS DAY_ID
FROM DIM_DAY
group by WEEK_ALL
order  by WEEK_ALL

select  min(DAY_ID) AS DAY_ID from DIM_DAY where WEEK_ALL=(
select WEEK_ALL from DIM_DAY where DAY_SHORT_DESC =TRUNC(sysdate)-7)

SELECT 
  ITEM_ID,
  to_date('2010-12-20 00:00:00','yyyy-mm-dd hh24:mi:ss')+ WEEK_ALL *7  DDATE,
  SUM(REAL_QTY) AS ALL_QTY
FROM FACT_SALE_SUB_WEEK
WHERE WEEK_ALL in ('${ddate}'-1,'${ddate}'-2,'${ddate}'-3,'${ddate}'-4)
AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in('"+sub_company_name+"')")}
AND ITEM_ID IN (
  SELECT DISTINCT ITEM_ID FROM  DIM_ITEM_POPULAR
  WHERE WEEK_ALL in ('${ddate}','${ddate}'-1,'${ddate}'-2,'${ddate}'-3,'${ddate}'-4))  
GROUP BY ITEM_ID,WEEK_ALL
ORDER BY WEEK_ALL

SELECT 
		ITEM_ID,
		SUB_COMPANY_NAME,
		SUM(ORGI_AMOUNT) 原价金额,
		SUM(REAL_QTY) 总数量,
		SUM(REAL_AMOUNT) 销售金额
	FROM FACT_SALE_SUB_WEEK
	WHERE WEEK_ALL ='${ddate}'
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
	${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in( '"+sub_company_name+"')")}
    AND ITEM_ID 
    in (select ITEM_ID FROM DIM_ITEM_POPULAR where WEEK_ALL='${ddate}')
	GROUP BY ITEM_ID,SUB_COMPANY_NAME

SELECT ITEM_ID,SUM(STOCK_QTY),SUB_COMPANY_NAME
FROM FACT_STOCK_SUB_ITEM
WHERE CREATE_DATE = to_date('2010-12-20','yyyy-mm-dd')+ (${ddate}) *7
AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in( '"+sub_company_name+"')")}
AND ITEM_ID in 
(select ITEM_ID FROM DIM_ITEM_POPULAR where WEEK_ALL='${ddate}')
GROUP BY ITEM_ID,SUB_COMPANY_NAME


SELECT ITEM_ID,SUM(STOCK_QTY),SUB_COMPANY_NAME
FROM FACT_STOCK_SUB_ITEM
WHERE CREATE_DATE = to_date('2010-12-26','yyyy-mm-dd')+ (${ddate}) *7
AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in( '"+sub_company_name+"')")}
AND ITEM_ID 
in (select ITEM_ID FROM DIM_ITEM_POPULAR where WEEK_ALL='${ddate}')
GROUP BY ITEM_ID,SUB_COMPANY_NAME

select 
	a.ITEM_ID,
	b.SUB_COMPANY_NAME,
	sum(a.REAL_QTY) as REAL_QTY
from FACT_ON_PASSAGE_ITEM  a,DIM_SHOP  b     
where a.ORG_CODE=b.ORG_CODE
AND a.CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+(${ddate})*7,'yyyy-mm-dd')
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
${if(len(sub_company_name)=0,"","AND b.SUB_COMPANY_NAME  in( '"+sub_company_name+"')")}
AND ITEM_ID 
in (select ITEM_ID FROM DIM_ITEM_POPULAR where WEEK_ALL='${ddate}')
group by a.ITEM_ID,b.SUB_COMPANY_NAME


SELECT
	D.ITEM_ID,
	D.ORG_NAME,
	SUM(D.SUM_STOCK_QTY) AS SUM_QTY,
	SUM(D.SUM_STOCK_QTY * C.SALE_PRICE) AS SUM_AMOUNT
FROM 
	DIM_ITEM_INFO_ALL C,
	(select 
		(A.STOCK_QTY+A.LIEN_QTY+nvl(A.SUB_STOCK_QTY,0)) AS SUM_STOCK_QTY,
		B.ORG_NAME,
		A.ITEM_ID,
		E.BRAND_NAME
	FROM VBI_STOCK_STOR A,VBI_ORG B, VBI_STORAGE E
	WHERE A.TARGET_TYPE = 0
	AND A.TARGET_ID = B.ORG_ID
	AND A.CREATE_DATE = to_date('2010-12-26','yyyy-mm-dd')+ (${ddate}) *7
	AND B.ORG_NAME NOT LIKE '%加盟%'
	AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	${if(len(sub_company_name)=0,""," AND B.ORG_NAME in( '"+sub_company_name+"')")}
	${if(len(brand)=0,""," AND E.BRAND_NAME ='"+brand+"'")}
	AND ITEM_ID in (select ITEM_ID FROM DIM_ITEM_POPULAR where WEEK_ALL='${ddate}')
	AND A.STORAGE_ID = E.STORAGE_ID) D
WHERE D.ITEM_ID = C.ITEM_ID
AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
GROUP BY D.ITEM_ID,D.ORG_NAME

SELECT ITEM_ID,SUM(SHOP_NUM),SUB_COMPANY_NAME
FROM DIM_CROSS_SHOP_NUMBER
WHERE CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+ (${ddate}) *7,'yyyy-mm-dd hh24:mi:ss')
AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in( '"+sub_company_name+"')")}
AND ITEM_ID in (select ITEM_ID FROM DIM_ITEM_POPULAR where WEEK_ALL='${ddate}')
GROUP BY ITEM_ID,SUB_COMPANY_NAME

-- DATE_ADD('2010-12-19 00:00:00',INTERVAL WEEK_ALL WEEK) 周初
-- DATE_ADD('2010-12-25 00:00:00',INTERVAL WEEK_ALL WEEK) 周末

select 
	a.ITEM_ID,
	a.ORG_NAME,
	sum(a.REAL_QTY) as REAL_QTY,
	sum(a.REAL_QTY*b.SALE_PRICE) as VALID_AMOUNT
from VBI_ORGI_NO_ARR  a ,DIM_ITEM_INFO_ALL  b,DIM_ITEM_POPULAR  c  
where a.CREATE_DATE = to_date('2010-12-26','yyyy-mm-dd')+ ${ddate}*7
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
${if(len(sub_company_name)=0,""," AND a.ORG_NAME in( '"+sub_company_name+"')")}
and a.ITEM_ID=b.ITEM_ID
and c.WEEK_ALL='${ddate}'
and a.ITEM_ID=c.ITEM_ID

group by a.ITEM_ID,a.ORG_NAME

SELECT 
  C.ITEM_ID,
  C.ITEM_CODE,
  C.ITEM_NAME 商品名称,
  C.SMALL_CATE_CODE 小类,
  C.SMALL_CATE_NAME 小类名称,
  C.SPEC 规格数,
  C.SALE_PRICE 零售价,
  C.FIRST_IN_DATE 最近入仓时间,
  C.LAST_IN_DATE 首次入仓时间,
  D.ORGI_AMOUNT 原价金额,
  D.REAL_QTY 销售数量,
  D.REAL_AMOUNT 销售金额
FROM
  (select A.* from (
SELECT 
    A.ITEM_ID,
    B.ITEM_CODE,
    B.ITEM_NAME,
    B.SMALL_CATE_CODE,
    B.SMALL_CATE_NAME,
    B.SPEC,
    B.SALE_PRICE ,
    B.FIRST_IN_DATE ,
    B.LAST_IN_DATE
  FROM DIM_ITEM_POPULAR A,DIM_ITEM_INFO_ALL B
  WHERE A.WEEK_ALL ='${ddate}'
  AND A.ITEM_ID = B.ITEM_ID
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
  -- 销售
  and (A.ITEM_ID in (SELECT ITEM_ID 
    FROM FACT_SALE_SUB_WEEK
    WHERE WEEK_ALL ='${ddate}'
    AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
    ${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
    ${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in( '"+sub_company_name+"')")})
  -- 期末库存
  or A.ITEM_ID in (SELECT ITEM_ID
    FROM FACT_STOCK_SUB_ITEM
    WHERE CREATE_DATE = to_date('2010-12-26','yyyy-mm-dd')+ (${ddate})*7
    AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
    ${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
    ${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in( '"+sub_company_name+"')")})
  -- 期初库存
  or A.ITEM_ID in(SELECT ITEM_ID
    FROM FACT_STOCK_SUB_ITEM
    WHERE CREATE_DATE = to_date('2010-12-20','yyyy-mm-dd')+ (${ddate})*7
    AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
    ${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
    ${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in( '"+sub_company_name+"')")})
  -- 虚拟库存
  or A.ITEM_ID in(SELECT D.ITEM_ID
    FROM DIM_ITEM_INFO_ALL C,
      (select 
        (A.STOCK_QTY+A.LIEN_QTY+nvl(A.SUB_STOCK_QTY,0)) AS SUM_STOCK_QTY,
        B.ORG_NAME,
        A.ITEM_ID,
        E.BRAND_NAME
      FROM VBI_STOCK_STOR A,VBI_ORG B, VBI_STORAGE E
      WHERE A.TARGET_TYPE = 0
      AND A.TARGET_ID = B.ORG_ID
      AND A.CREATE_DATE = to_date('2010-12-26','yyyy-mm-dd')+ (${ddate})*7
      AND B.ORG_NAME NOT LIKE '%加盟%'
      AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
      ${if(len(sub_company_name)=0,""," AND B.ORG_NAME in( '"+sub_company_name+"')")}
      ${if(len(brand)=0,""," AND E.BRAND_NAME ='"+brand+"'")}
      AND A.STORAGE_ID = E.STORAGE_ID) D
    WHERE D.ITEM_ID = C.ITEM_ID
    AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
    )
  -- 未到货
  or A.ITEM_ID IN (select distinct a.ITEM_ID
    from VBI_ORGI_NO_ARR  a,DIM_ITEM_INFO_ALL  b,DIM_ITEM_POPULAR  c  
    where a.CREATE_DATE = to_date('2010-12-26','yyyy-mm-dd')+ (${ddate})*7
    and c.WEEK_ALL='${ddate}' 
    and a.ITEM_ID=c.ITEM_ID
    AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
    AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
    ${if(len(sub_company_name)=0,""," AND a.ORG_NAME in( '"+sub_company_name+"')")}
    and a.ITEM_ID=b.ITEM_ID
    ${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
    )
  -- 在途
  or A.ITEM_ID IN(SELECT DISTINCT a.ITEM_ID
    from FACT_ON_PASSAGE_ITEM  a,DIM_SHOP  b     
    where a.ORG_CODE=b.ORG_CODE
    AND a.CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+ (${ddate})*7,'yyyy-mm-dd')
    AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
    ${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
    ${if(len(sub_company_name)=0,"","AND b.SUB_COMPANY_NAME  in( '"+sub_company_name+"')")}
    )
  ))  A,DIM_ITEM_INFO_ALL  B where A.ITEM_ID=B.ITEM_ID
  ${if(len(REGULAR_CODE)=0,"","AND B.REGULAR_CODE  in( '"+REGULAR_CODE+"')")}
  ) C left join 
  (SELECT 
    ITEM_ID,
    SUM(ORGI_AMOUNT) ORGI_AMOUNT,
    SUM(REAL_QTY) REAL_QTY,
    SUM(REAL_AMOUNT) REAL_AMOUNT
  FROM FACT_SALE_SUB_WEEK
  WHERE WEEK_ALL ='${ddate}'
  AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
  ${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
  ${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in( '"+sub_company_name+"')")}
  GROUP BY ITEM_ID) D
  on  C.ITEM_ID = D.ITEM_ID

SELECT ITEM_ID,SUM(SHOP_NUMBER),SUB_COMPANY_NAME
FROM FACT_STOCK_SUB_ITEM_SHOP_NUM
WHERE CREATE_DATE = to_date('2010-12-26','yyyy-mm-dd')+ (${ddate}) *7
AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in( '"+sub_company_name+"')")}
AND ITEM_ID in (select ITEM_ID FROM DIM_ITEM_POPULAR where WEEK_ALL='${ddate}')
GROUP BY ITEM_ID,SUB_COMPANY_NAME

SELECT DISTINCT CURRENCY FROM VBI_CURRENCY


select distinct REGULAR_CODE,concat(REGULAR_CODE,REGULAR_NAME) as REGULAR_NAME
from DIM_ITEM_INFO_ALL
where 1=1
${if(len(brand)==0,"","AND BRAND_NAME IN ('"+brand+"')")}
order by REGULAR_CODE

SELECT ITEM_ID,SUM(STOCK_QTY),SUB_COMPANY_NAME
FROM FACT_STOCK_SUB_ITEM
WHERE CREATE_DATE = TRUNC(sysdate)-1
AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
${if(len(sub_company_name)=0,"","AND SUB_COMPANY_NAME  in( '"+sub_company_name+"')")}
AND ITEM_ID
in (select ITEM_ID FROM DIM_ITEM_POPULAR where WEEK_ALL='${ddate}')
GROUP BY ITEM_ID,SUB_COMPANY_NAME

SELECT to_date('2010-12-20 00:00:00','yyyy-mm-dd hh24:mi:ss')+ ('${ddate}'-4) *7 AS DDATE
FROM dual
UNION ALL
SELECT to_date('2010-12-20 00:00:00','yyyy-mm-dd hh24:mi:ss')+ ('${ddate}'-3) *7 AS DDATE
FROM dual
UNION ALL
SELECT to_date('2010-12-20 00:00:00','yyyy-mm-dd hh24:mi:ss')+ ('${ddate}'-2) *7 AS DDATE
FROM dual
UNION ALL
SELECT to_date('2010-12-20 00:00:00','yyyy-mm-dd hh24:mi:ss')+ ('${ddate}'-1) *7 AS DDATE
FROM dual

