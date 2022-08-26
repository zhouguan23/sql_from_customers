select
	A.SUB_COMPANY_NAME 分公司,
	A.A1 店铺数,
	B.A2 总库存价值,
	E.REAL_AMOUNT/A.A1/TO_NUMBER(TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd'),'dd'),'fm99') 日店均,
	E.REAL_AMOUNT 月累计,
	E.REAL_QTY 累计销售数量,
	E.NUM 累计成交笔数,
	E.TRANS_AMOUNT 累计配送金额,
	E.ORGI_AMOUNT 累计原价金额
FROM
	(select 
		SUB_COMPANY_NAME,
		count(1) as A1
	from DIM_SHOP_DAY
	where CREATE_DATE = TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd'),'yyyy-mm-dd hh24:mi:ss')
	and BRAND_NAME_ALL= '${brand}'
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	and SUB_COMPANY_NAME NOT LIKE '%电商%'
	GROUP BY SUB_COMPANY_NAME) A,    -- 店铺数
  
  (select SUB_COMPANY_NAME,sum(STOCK_AMOUNT) AS A2
  from FACT_STOCK_SUB where CREATE_DATE= TO_DATE('${ddate}','yyyy-mm-dd')
  AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
  AND BRAND_NAME = '${brand}' and SUB_COMPANY_NAME NOT LIKE '%电商%'
  
  group by SUB_COMPANY_NAME) B,     -- 库存数据

  (select
    SUB_COMPANY_NAME,
    SUM(REAL_QTY) AS REAL_QTY,
    SUM(REAL_AMOUNT) as REAL_AMOUNT,
    SUM(NUM) AS NUM,
    SUM(TRANS_AMOUNT) AS TRANS_AMOUNT,
    SUM(ORGI_AMOUNT) AS ORGI_AMOUNT
  from
    FACT_SALE_SUB
  WHERE BRAND_NAME= '${brand}'
  AND (CURRENCY = '${currency}'  ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
  AND CREATE_DATE >= TO_CHAR(TRUNC(TO_DATE('${ddate}','yyyy-mm-dd'),'mm'),'yyyy-mm-dd')
  AND CREATE_DATE < TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd')+1,'yyyy-mm-dd') 
  group by SUB_COMPANY_NAME) E     -- 销售数据
WHERE A.SUB_COMPANY_NAME = B.SUB_COMPANY_NAME 
AND A.SUB_COMPANY_NAME = E.SUB_COMPANY_NAME
order by 日店均 desc

select b.BRAND_NAME_ALL as BRAND_NAME from (
select BRAND_NAME from FILL_USER_BRAND  a,FR_T_USER b
where a.USER_ID=TO_CHAR(b.id)
${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} )  a,VBI_BRAND  b
where a.BRAND_NAME=b.BRAND_NAME 


-- 品牌，维度表

SELECT 
  DISTINCT CURRENCY 
FROM VBI_CURRENCY




-- 币种，维度表

select A.*,B.BRAND_NAME_ALL,B.SUB_COMPANY_NAME
 from
(select CREATE_MONTH,ORG_CODE,sum(STOCK_AMOUNT) AS STOCK_AMOUNT,sum(TRANS_AMOUNT) AS TRANS_AMOUNT,decode(max(MONTH_DAY),0,'',sum(STOCK_AMOUNT)/max(MONTH_DAY)) AS A3
	from FACT_STOCK_SMALL_MONTH 
	where CREATE_MONTH= SUBSTR('${ddate}',1,7)
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	AND SUBSTR(SMALL_CATE_CODE,1,2)<>'20'
	AND SUBSTR(SMALL_CATE_CODE,1,2)<>'21'
	AND SUBSTR(SMALL_CATE_CODE,1,2)<>'22'
	group by CREATE_MONTH, ORG_CODE) A,
 (select 
		ORG_CODE,
		BRAND_NAME_ALL,
		SUB_COMPANY_NAME
	from DIM_SHOP_DAY
	where CREATE_DATE = TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd'),'yyyy-mm-dd hh24:mi:ss')
	and SUB_COMPANY_NAME NOT LIKE '%电商%'
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	AND BRAND_NAME_ALL= '${brand}'
	--GROUP BY ORG_CODE 
	) B
WHERE A.ORG_CODE = B.ORG_CODE 

SELECT C.BRAND_NAME,
       C.SUB_COMPANY_NAME,
       (1 - SUM(C.TRANS_AMOUNT) / sum(C.STOCK_AMOUNT)) AS A4
  FROM (SELECT A.*,
               B.BRAND_NAME,
               B.SUB_COMPANY_NAME,
               E.TRANS_PRICE,
               (E.TRANS_PRICE * A.STOCK_QTY) AS TRANS_AMOUNT
          FROM (select ORG_CODE,
                       ITEM_ID,
                       sum(STOCK_QTY) AS STOCK_QTY,
                       sum(STOCK_AMOUNT) AS STOCK_AMOUNT
                  from FACT_STOCK_SHOP_ITEM
                 where CREATE_DATE >=TO_CHAR(TRUNC(TO_DATE('${ddate}','yyyy-mm-dd'),'mm'),'yyyy-mm-dd hh24:mi:ss')
                   AND CREATE_DATE <TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd')+1,'yyyy-mm-dd hh24:mi:ss')
                   AND (CURRENCY = '${currency}'
                        ${IF(currency = '人民币', "OR CURRENCY IS NULL", "") })
                 group by ORG_CODE, ITEM_ID) A,
               (select ORG_CODE, BRAND_NAME, SUB_COMPANY_NAME
                  from DIM_SHOP_DAY
                 where CREATE_DATE =TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd')-1,'yyyy-mm-dd hh24:mi:ss')
                   and SUB_COMPANY_NAME NOT LIKE '%电商%'
                   AND BRAND_NAME = '${brand}'
                 GROUP BY ORG_CODE) B,
               (select ITEM_ID, TRANS_PRICE from DIM_ITEM_INFO_ALL) E
         WHERE A.ORG_CODE = B.ORG_CODE
           AND A.ITEM_ID = E.ITEM_ID) C
 group by C.BRAND_NAME, C.SUB_COMPANY_NAME


SELECT C.CREATE_DATE,C.BRAND_NAME,C.SUB_COMPANY_NAME,SUM(C.TRANS_AMOUNT) AS TRANS_AMOUNT,
SUM(C.STOCK_AMOUNT) AS STOCK_AMOUNT,(1-SUM(C.TRANS_AMOUNT)/sum(C.STOCK_AMOUNT)) AS A4
FROM
(SELECT A.*,E.TRANS_PRICE,
(E.TRANS_PRICE*A.STOCK_QTY) AS TRANS_AMOUNT
FROM
(select CREATE_DATE,BRAND_NAME,SUB_COMPANY_NAME,ITEM_ID,sum(STOCK_QTY) AS STOCK_QTY,sum(STOCK_AMOUNT) AS STOCK_AMOUNT,
(CASE
         WHEN BRAND_NAME='兰诺' THEN
          'LANO'
         ELSE
          BRAND_NAME
       END) BRAND_NAME_ALL
  from FACT_STOCK_SUB_ITEM 
  where CREATE_DATE= TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd'),'yyyy-mm-dd hh24:mi:ss')
  AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
  and SUB_COMPANY_NAME NOT LIKE '%电商%'
  group by BRAND_NAME,SUB_COMPANY_NAME,ITEM_ID) A,
(select 
    ITEM_ID,
    TRANS_PRICE
  from DIM_ITEM_INFO_ALL) E 
WHERE  A.ITEM_ID = E.ITEM_ID 
AND BRAND_NAME_ALL = '${brand}'
) C
group by C.CREATE_DATE,C.BRAND_NAME,C.SUB_COMPANY_NAME

select CREATE_MONTH,
       ORG_CODE,
       sum(STOCK_AMOUNT) AS STOCK_AMOUNT,
       sum(TRANS_AMOUNT) AS TRANS_AMOUNT,
       sum(STOCK_AMOUNT) / MONTH_DAY AS A3
  from FACT_STOCK_SMALL_MONTH
  where CREATE_MONTH= SUBSTR('${ddate}',1,7)
  AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
  group by ORG_CODE

SELECT C.CREATE_DATE,
       C.BRAND_NAME,
       C.SUB_COMPANY_NAME,
       SUM(C.TRANS_AMOUNT) AS TRANS_AMOUNT,
       SUM(C.STOCK_AMOUNT) AS STOCK_AMOUNT,
       (1 - SUM(C.TRANS_AMOUNT) / sum(C.STOCK_AMOUNT)) AS A4
  FROM (SELECT A.*,
               E.TRANS_PRICE,
               (E.TRANS_PRICE * A.STOCK_QTY) AS TRANS_AMOUNT
          FROM (select CREATE_DATE,
                       BRAND_NAME,
                       SUB_COMPANY_NAME,
                       ITEM_ID,
                       sum(STOCK_QTY) AS STOCK_QTY,
                       sum(STOCK_AMOUNT) AS STOCK_AMOUNT
                  from FACT_STOCK_SUB_ITEM
                 where CREATE_DATE >=TO_CHAR(TRUNC(TO_DATE('${ddate}','yyyy-mm-dd'),'mm'),'yyyy-mm-dd hh24:mi:ss')
                   AND CREATE_DATE <TO_CHAR(TO_DATE('${ddate}','yyyy-mm-dd')+1,'yyyy-mm-dd hh24:mi:ss')
                   AND (CURRENCY = '${currency}'
                        ${IF(currency = '人民币', "OR CURRENCY IS NULL", "") })
                   AND BRAND_NAME = '${brand}'
                   and SUB_COMPANY_NAME NOT LIKE '%电商%'
                 group by BRAND_NAME, SUB_COMPANY_NAME, ITEM_ID) A,
               (select ITEM_ID, TRANS_PRICE from DIM_ITEM_INFO_ALL) E
         WHERE A.ITEM_ID = E.ITEM_ID) C
 group by C.CREATE_DATE, C.BRAND_NAME, C.SUB_COMPANY_NAME


SELECT * FROM FACT_STOCK_SMALL_MONTH where rownum<10

SELECT * FROM FACT_STOCK_SMALL where ORG_CODE='000267'
and CREATE_DATE=TO_DATE('2019-02-28','yyyy-mm-dd hh24:mi:ss')

